# Example: Document Comparison App Layout (v3 Architecture)

A complete example showing how to structure a Tyler App Style document comparison app using the v3 architecture: NavigationSplitView shell, unified sidebar router, workspace toolbar with mode toggle, collapsible annotation panel with tool controls, pin overlays, properties popovers, verdict tags, and explicit save editors.

## App Entry Point

```swift
@main
struct MyComparisonApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(appState)
                .frame(minWidth: 1200, minHeight: 700)
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
        }
        .defaultSize(width: 1440, height: 900)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApp.windows.first {
            window.titlebarAppearsTransparent = true
            window.backgroundColor = NSColor(hex: "0A0A0A")
        }
    }
}
```

## App State

```swift
@Observable @MainActor
class AppState {
    enum AppView { case dropZone, matchConfirmation, workspace }
    enum WorkspaceMode { case comparison, review }

    var currentView: AppView = .dropZone
    var workspaceMode: WorkspaceMode = .comparison

    func toggleWorkspaceMode() {
        workspaceMode = workspaceMode == .comparison ? .review : .comparison
    }
}
```

## Main View (NavigationSplitView Shell)

```swift
struct MainView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationSplitView {
            SidebarView()
                .background(.ultraThinMaterial)
                .navigationSplitViewColumnWidth(min: 280, ideal: 340, max: 500)
        } detail: {
            DetailRouter()
        }
        .background(AppTokens.Color.background(for: colorScheme))
    }
}
```

## Sidebar Router

The sidebar switches content based on app state — it acts as a unified router:

```swift
struct SidebarView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            switch appState.currentView {
            case .dropZone:
                DropZoneSidebar()
            case .matchConfirmation:
                MatchConfirmationSidebar()
            case .workspace:
                switch appState.workspaceMode {
                case .comparison:
                    ComparisonSidebar()
                case .review:
                    ReviewSidebar()
                }
            }
        }
        // No opaque background here — let .ultraThinMaterial from parent show through
    }
}
```

## Detail Router

```swift
struct DetailRouter: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        switch appState.currentView {
        case .dropZone:
            DropZoneView()
        case .matchConfirmation:
            MatchConfirmationView()
        case .workspace:
            WorkspaceView()
        }
    }
}
```

## Workspace View (Toolbar + HStack with Content + Notes Panel)

```swift
struct WorkspaceView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.colorScheme) private var colorScheme
    @State private var notesPanelVisible = true

    var body: some View {
        HStack(spacing: 0) {
            // Main content switches on workspace mode
            Group {
                switch appState.workspaceMode {
                case .comparison:
                    ComparisonContentView()
                case .review:
                    ReviewContentView()
                }
            }
            .frame(maxWidth: .infinity)

            // Collapsible notes/inspector panel
            if notesPanelVisible {
                Divider()
                NotesSidePanel()
                    .frame(width: 300)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .toolbar { workspaceToolbar }
        .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
        .animation(AppTokens.Motion.smooth, value: notesPanelVisible)
    }

    @ToolbarContentBuilder
    var workspaceToolbar: some ToolbarContent {
        // File info
        ToolbarItem(placement: .automatic) {
            HStack(spacing: AppTokens.Spacing.sm) {
                Text("OldDeck.pptx")
                    .font(AppTokens.Font.bodySmall)
                    .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
                Image(systemName: "arrow.right")
                    .font(.system(size: 9))
                    .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
                Text("NewDeck.pptx")
                    .font(AppTokens.Font.bodySmall)
                    .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
            }
        }

        // Stats
        ToolbarItem(placement: .automatic) {
            GlassEffectContainer {
                HStack(spacing: AppTokens.Spacing.sm) {
                    StatPill(value: "12", label: "SLIDES")
                    StatPill(value: "3", label: "FLAGGED")
                    StatPill(value: "8/12", label: "REVIEWED")
                }
            }
        }

        // Mode toggle
        ToolbarItem(placement: .automatic) {
            GlassEffectContainer {
                HStack(spacing: AppTokens.Spacing.xxs) {
                    modeButton("Compare", icon: "arrow.left.arrow.right", mode: .comparison)
                    modeButton("Review", icon: "doc.text.magnifyingglass", mode: .review)
                }
            }
        }

        // Export
        ToolbarItem(placement: .automatic) {
            GlassButton(label: "Export", icon: "square.and.arrow.up") { }
        }

        // Notes panel toggle
        ToolbarItem(placement: .automatic) {
            Button {
                withAnimation(AppTokens.Motion.smooth) { notesPanelVisible.toggle() }
            } label: {
                Image(systemName: "sidebar.trailing")
                    .symbolVariant(notesPanelVisible ? .none : .slash)
            }
            .help("Toggle Notes Panel")
        }
    }

    private func modeButton(_ label: String, icon: String, mode: AppState.WorkspaceMode) -> some View {
        Button {
            withAnimation(AppTokens.Motion.snappy) {
                appState.workspaceMode = mode
            }
        } label: {
            HStack(spacing: AppTokens.Spacing.xs) {
                Image(systemName: icon).font(.system(size: 11, weight: .medium))
                Text(label).font(AppTokens.Font.label).tracking(0.88).textCase(.uppercase)
            }
            .foregroundStyle(
                appState.workspaceMode == mode
                    ? AppTokens.Color.textDisplay(for: colorScheme)
                    : AppTokens.Color.textTertiary(for: colorScheme)
            )
            .padding(.horizontal, AppTokens.Spacing.sm)
            .padding(.vertical, AppTokens.Spacing.xs)
        }
        .buttonStyle(.plain)
        .glassEffect(
            appState.workspaceMode == mode
                ? .regular.tint(AppTokens.Color.accent.opacity(0.2)).interactive()
                : .clear,
            in: .capsule
        )
    }
}
```

## Comparison Sidebar (Slide Map)

```swift
struct ComparisonSidebar: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            // Summary stats
            GlassEffectContainer {
                HStack(spacing: AppTokens.Spacing.md) {
                    StatPill(value: "10", label: "OLD")
                    StatPill(value: "12", label: "NEW")
                    StatPill(value: "8", label: "PAIRS")
                }
                .padding(AppTokens.Spacing.sm)
            }

            // Filter bar
            GlassEffectContainer {
                HStack(spacing: AppTokens.Spacing.xxs) {
                    filterPill("ALL", isActive: true)
                    filterPill("UNREVIEWED", isActive: false)
                    filterPill("FLAGGED", isActive: false)
                    Spacer()
                }
                .padding(.horizontal, AppTokens.Spacing.sm)
                .padding(.vertical, AppTokens.Spacing.sm)
            }

            // Slide list
            ScrollView {
                slideMapContent
            }
        }
        // No opaque background — frosted glass from parent shows through
    }

    private func filterPill(_ label: String, isActive: Bool) -> some View {
        Button { } label: {
            Text(label)
                .font(AppTokens.Font.caption)
                .tracking(0.88)
                .textCase(.uppercase)
                .foregroundStyle(isActive ? AppTokens.Color.textDisplay(for: colorScheme) : AppTokens.Color.textTertiary(for: colorScheme))
                .padding(.horizontal, AppTokens.Spacing.sm)
                .padding(.vertical, AppTokens.Spacing.xs)
        }
        .buttonStyle(.plain)
        .glassEffect(
            isActive ? .regular.tint(AppTokens.Color.accent.opacity(0.2)).interactive() : .clear,
            in: .capsule
        )
    }
}
```

## Notes Side Panel

```swift
struct NotesSidePanel: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("NOTES").appLabel()
                Spacer()
                Text("SLIDE 3").font(AppTokens.Font.caption)
                    .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
            }
            .padding(.horizontal, AppTokens.Spacing.md)
            .frame(height: 44)
            .background(AppTokens.Color.surface(for: colorScheme).opacity(0.5))

            ScrollView {
                VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
                    // Review controls
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        Text("REVIEW").appLabel()
                        HStack(spacing: AppTokens.Spacing.md) {
                            // reviewCheckbox, flagButton, etc.
                        }
                    }

                    Divider()
                        .background(AppTokens.Color.borderStrong(for: colorScheme).opacity(0.3))

                    // Speaker notes
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        Text("SPEAKER NOTES").appLabel()
                        GlassSectionCard {
                            Text("Notes content here...")
                                .font(AppTokens.Font.bodySmall)
                                .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
                        }
                    }
                }
                .padding(AppTokens.Spacing.md)
            }
        }
        .background(AppTokens.Color.background(for: colorScheme))
    }
}
```

## Pin Overlay on Content Area

Draggable numbered pin markers overlaid on the slide image. Pins use `NormalizedPoint` for resolution independence and local `@State` offset for smooth dragging.

```swift
struct SlideWithPins: View {
    let annotations: [Annotation]
    let selectedID: UUID?
    let onPinDragEnd: (UUID, NormalizedPoint) -> Void
    let onPinTap: (UUID) -> Void

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Slide image content
                slideImage
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                // Pin overlay
                ForEach(pinAnnotations) { annotation in
                    PinMarkerView(
                        annotation: annotation,
                        displayNumber: displayNumber(for: annotation),
                        isSelected: annotation.id == selectedID,
                        containerSize: geo.size,
                        onDragEnd: { point in onPinDragEnd(annotation.id, point) },
                        onTap: { onPinTap(annotation.id) }
                    )
                }
            }
        }
    }

    private var pinAnnotations: [Annotation] {
        annotations.filter { if case .pin = $0.type { return true }; return false }
    }
}
```

## Annotation Properties Popover

Click an annotation in the side panel list to show a popover with note editor, color picker, and delete. Uses explicit cancel/save buttons instead of auto-save bindings.

```swift
struct AnnotationRow: View {
    let annotation: Annotation
    let displayNumber: Int
    let isSelected: Bool
    @State private var showPopover = false
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: AppTokens.Spacing.sm) {
            Circle()
                .fill(resolvedColor(for: annotation.colorIndex, customHex: annotation.customColorHex))
                .frame(width: 24, height: 24)
                .overlay(
                    Text("\(displayNumber)")
                        .font(AppTokens.Font.caption)
                        .foregroundStyle(.white)
                )
            VStack(alignment: .leading) {
                Text(annotation.typeLabel).font(AppTokens.Font.label).appLabel()
                if !annotation.noteText.isEmpty {
                    Text(annotation.noteText)
                        .font(AppTokens.Font.bodySmall)
                        .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
                        .lineLimit(1)
                }
            }
            Spacer()
        }
        .padding(AppTokens.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                .fill(isSelected ? AppTokens.Color.accentDim(for: colorScheme) : .clear)
        )
        .onTapGesture { showPopover = true }
        .popover(isPresented: $showPopover) {
            AnnotationPropertiesPopover(
                annotation: annotation,
                onSave: { noteText in /* update model */ },
                onDelete: { /* delete from model */ },
                onRecolor: { index, hex in /* update model */ }
            )
        }
    }
}
```

## Verdict Tags with Slide Picker

Verdict tags are displayed as colored glass capsules. The MERGE verdict includes a slide picker for selecting which slide to merge with.

```swift
struct VerdictSection: View {
    @Binding var verdict: SlideVerdict?
    let availableSlides: [SlideInfo]
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
            Text("VERDICT").appLabel()

            // Verdict tag buttons
            GlassEffectContainer {
                HStack(spacing: AppTokens.Spacing.xxs) {
                    ForEach(Verdict.allCases, id: \.self) { v in
                        Button {
                            withAnimation(AppTokens.Motion.snappy) {
                                verdict = SlideVerdict(verdict: v, context: defaultContext(for: v), noteText: "")
                            }
                        } label: {
                            Text(v.rawValue)
                                .font(AppTokens.Font.caption)
                                .tracking(0.88)
                                .foregroundStyle(verdict?.verdict == v ? verdictColor(v) : AppTokens.Color.textTertiary(for: colorScheme))
                                .padding(.horizontal, AppTokens.Spacing.sm)
                                .padding(.vertical, AppTokens.Spacing.xxs)
                        }
                        .buttonStyle(.plain)
                        .glassEffect(
                            verdict?.verdict == v
                                ? .regular.tint(verdictColor(v).opacity(0.15)).interactive()
                                : .clear,
                            in: .capsule
                        )
                    }
                }
            }

            // Contextual controls based on verdict type
            if let v = verdict {
                switch v.verdict {
                case .merge:
                    // Slide picker for merge target
                    Picker("Merge with", selection: mergeTargetBinding) {
                        ForEach(availableSlides) { slide in
                            Text("Slide \(slide.number)").tag(slide.id)
                        }
                    }
                    .pickerStyle(.menu)
                case .revise:
                    // Free text for revision instructions (explicit save)
                    RevisionNoteEditor(
                        initialText: v.noteText,
                        onSave: { text in verdict?.noteText = text }
                    )
                default:
                    EmptyView()
                }
            }
        }
    }
}
```

## Key Takeaways (v3 Architecture)

1. **`NavigationSplitView`** is the app shell — sidebar with `.ultraThinMaterial`, detail with workspace content
2. **Sidebar is a router** — switches content based on `appState.currentView` and `appState.workspaceMode`
3. **`DetailRouter`** maps app state to the correct detail view
4. **Workspace toolbar** has file names, stat pills, mode toggle (comparison/review), export, and panel toggle
5. **Annotation panel** replaces simple notes panel — tool controls (draw/pin/text edit modes) and color picker live in the panel header
6. **Pin overlay** uses `NormalizedPoint` + local `@State` drag offset for smooth dragging
7. **Properties popover** on annotation list items — note editor, color picker, delete with explicit cancel/save buttons
8. **Verdict tags** as colored glass capsules with typed context (slide picker for MERGE, free text for REVISE)
9. **Explicit save pattern** on all note editors — prevents value-type binding single-character bug
10. **Visual hint overlay** when tool mode is active but no items exist yet — dims content, shows instruction, uses `.allowsHitTesting(false)`
11. **Title bar** uses `.toolbarBackgroundVisibility(.hidden)` + `titlebarAppearsTransparent` + `window.backgroundColor`
12. **All animations** use `AppTokens.Motion.*` springs
13. **All colors** come from `AppTokens.Color.*` with `ColorScheme` parameter
14. **All labels** use `.appLabel()` modifier
15. **No opaque backgrounds** on sidebar child views — frosted glass must show through
