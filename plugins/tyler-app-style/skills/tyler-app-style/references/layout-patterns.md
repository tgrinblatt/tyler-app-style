# Layout Patterns for Tyler App Style

## App Structure

Tyler App Style apps use a NavigationSplitView shell with a sidebar router, workspace toolbar, and optional collapsible side panel:

```
+--------------------------------------------------+
|  [Toolbar: deck names | stats | mode | actions]  |  <- Toolbar (background hidden)
+--------+----------------------------+------------+
|        |                            |            |
| Slide  |   Main Content Area       |   Notes /  |
| Map /  |   (Visual Compare,        |  Inspector |
| Review |    Text Compare,          |   Panel    |
| List   |    Slide Detail)          |            |
|        |                            |            |
| (float)|                            | (toggle)   |
+--------+----------------------------+------------+
```

## Title Bar Fix (Black/Grey Title Bar Prevention)

On macOS 26, the default toolbar style produces a grey or black title bar that does not match the app background. This is the fix:

```swift
@main
struct MyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView()
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
        }
        .defaultSize(width: 1440, height: 900)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let window = NSApp.windows.first {
            window.titlebarAppearsTransparent = true
            window.backgroundColor = NSColor(hex: "0A0A0A")  // Match background token
        }
    }
}
```

**Why**: Without `.toolbarBackgroundVisibility(.hidden, for: .windowToolbar)`, the system draws its own toolbar background (grey in light mode, near-black in dark mode) that clashes with the custom background. Making the titlebar transparent and setting `window.backgroundColor` ensures the title area blends seamlessly.

## NavigationSplitView (Floating Sidebar with Frosted Glass)

```swift
NavigationSplitView {
    sidebarContent
        .background(.ultraThinMaterial)
        .navigationSplitViewColumnWidth(min: 280, ideal: 340, max: 500)
} detail: {
    HStack(spacing: 0) {
        mainContent
            .frame(maxWidth: .infinity)

        if inspectorVisible {
            Divider()
            inspectorPanel
                .frame(width: 300)
                .transition(.move(edge: .trailing).combined(with: .opacity))
        }
    }
    .toolbar { toolbarItems }
    .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
    .animation(AppTokens.Motion.smooth, value: inspectorVisible)
}
.background(AppTokens.Color.background(for: colorScheme))
```

## Sidebar Router Pattern

Use the sidebar to switch content based on app state. The sidebar view acts as a router that shows different content depending on the current mode:

```swift
struct SidebarView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            switch appState.currentView {
            case .dropZone:
                DropZoneSidebar()
            case .workspace:
                switch appState.workspaceMode {
                case .comparison:
                    ComparisonSidebar()
                case .review:
                    ReviewSidebar()
                }
            }
        }
        .background(.ultraThinMaterial)
    }
}
```

## Workspace Toolbar Pattern

The workspace toolbar shows contextual information — file names, stats pills, mode toggle, and actions:

```swift
@ToolbarContentBuilder
var workspaceToolbar: some ToolbarContent {
    // Leading: file info
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

    // Center: stat pills
    ToolbarItem(placement: .automatic) {
        GlassEffectContainer {
            HStack(spacing: AppTokens.Spacing.sm) {
                StatPill(value: "12", label: "SLIDES")
                StatPill(value: "3", label: "FLAGGED")
                StatPill(value: "8/12", label: "REVIEWED")
            }
        }
    }

    // Mode toggle (comparison vs review)
    ToolbarItem(placement: .automatic) {
        GlassEffectContainer {
            HStack(spacing: AppTokens.Spacing.xxs) {
                modeButton("Compare", icon: "arrow.left.arrow.right", mode: .comparison)
                modeButton("Review", icon: "doc.text.magnifyingglass", mode: .review)
            }
        }
    }

    // Trailing: actions
    ToolbarItem(placement: .automatic) {
        GlassButton(label: "Export", icon: "square.and.arrow.up") { exportAction() }
    }

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
```

## Collapsible Side Panel (Notes / Inspector / Tool Controls)

The right-side panel is a simple HStack child that toggles with a trailing transition. Tool controls (mode buttons, color picker) live in the **panel header** rather than at the bottom of the main content, keeping the main content area clean.

```swift
struct WorkspaceView: View {
    @State private var notesPanelVisible = true
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 0) {
            // Main workspace content — stays clean, no tool controls here
            mainContent
                .frame(maxWidth: .infinity)

            // Collapsible side panel with tool controls in header
            if notesPanelVisible {
                Divider()
                AnnotationPanel(/* ... */)
                    .frame(width: 300)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .toolbar { workspaceToolbar }
        .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
        .animation(AppTokens.Motion.smooth, value: notesPanelVisible)
    }
}

// Panel header with tool controls
struct AnnotationPanelHeader: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: AppTokens.Spacing.sm) {
            HStack {
                Text("ANNOTATIONS").appLabel()
                Spacer()
                // Tool mode buttons in the panel header
                GlassEffectContainer {
                    HStack(spacing: AppTokens.Spacing.xxs) {
                        toolButton("rectangle.dashed", mode: .draw)
                        toolButton("mappin", mode: .pin)
                        toolButton("character.cursor.ibeam", mode: .textEdit)
                    }
                }
            }
            // Color picker row also in the panel header
            ColorPickerRow(selectedIndex: $colorIndex, customHex: $customHex)
        }
        .padding(.horizontal, AppTokens.Spacing.md)
        .padding(.vertical, AppTokens.Spacing.sm)
        .background(AppTokens.Color.surface(for: colorScheme).opacity(0.5))
    }
}
```

### Notes Side Panel Content

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
                            reviewCheckbox
                            flagButton
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

## Tab View (Mode Switching)

```swift
GlassEffectContainer {
    TabView(selection: $currentMode) {
        Tab("Drop Zone", systemImage: "square.and.arrow.down", value: .dropZone) {
            DropZoneView()
        }
        Tab("Comparison", systemImage: "arrow.left.arrow.right", value: .comparison) {
            ComparisonView()
        }
        Tab("Review", systemImage: "doc.text.magnifyingglass", value: .review) {
            ReviewView()
        }
    }
}
```

## Section Card Pattern (for notes/annotations)

```swift
struct GlassSectionCard<Content: View>: View {
    let content: Content
    @Environment(\.colorScheme) private var colorScheme

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        content
            .padding(AppTokens.Spacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                    .fill(AppTokens.Color.surface(for: colorScheme).opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                    .strokeBorder(
                        AppTokens.Color.borderStrong(for: colorScheme).opacity(0.3),
                        lineWidth: AppTokens.Border.hairline
                    )
            )
    }
}
```

## Sidebar Summary Stats

```swift
GlassEffectContainer {
    HStack(spacing: AppTokens.Spacing.md) {
        StatBadge(value: "9", label: "PAIRS")
        StatBadge(value: "3", label: "REVIEWED")
        StatBadge(value: "2", label: "FLAGGED", valueColor: AppTokens.Color.warning)
    }
    .padding(.vertical, AppTokens.Spacing.sm)
    .padding(.horizontal, AppTokens.Spacing.md)
}
```

## Hover + Selection on Interactive Elements

```swift
.overlay(
    RoundedRectangle(cornerRadius: AppTokens.Radius.sm)
        .strokeBorder(
            isSelected ? AppTokens.Color.accent : AppTokens.Color.border(for: colorScheme),
            lineWidth: isSelected ? 2.5 : AppTokens.Border.hairline
        )
)
.shadow(color: isSelected ? AppTokens.Color.accent.opacity(0.25) : .clear, radius: 8)
.scaleEffect(isHovered && !isSelected ? 1.03 : 1.0)
.onHover { isHovered = $0 }
.animation(AppTokens.Motion.snappy, value: isHovered)
```
