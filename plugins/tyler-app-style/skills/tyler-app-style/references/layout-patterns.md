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

## Window Toolbar Pattern (app title + page title + system icons)

Tyler App Style apps split the window toolbar into three slots with specific
semantics. Get this layout consistent across every app — it's load-bearing
for the whole design language:

| Slot | Placement | Contents | Glass? |
|---|---|---|---|
| Left | `.navigation` wrapped in `ToolbarItemGroup` with `.sharedBackgroundVisibility(.hidden)` | **App name** as plain display text | **No** — pill suppressed |
| Center | `.principal` | **Current page name** (ALL-CAPS label with horizontal padding so the auto-pill breathes) | **Yes** — auto-applied by macOS 26 |
| Right | `.automatic` / `.primaryAction` | System-style icon buttons (inspector toggle, etc.) | **Yes** — individual glass pills |

**Stat pills, Export, mode toggles do NOT live in the window toolbar.** They
live in the `CanvasActionBar` below the toolbar (see next section). The
window toolbar is reserved for identity (app + page) and system icons.

```swift
@ToolbarContentBuilder
var windowToolbar: some ToolbarContent {
    // LEFT — App name, plain text, no glass pill
    ToolbarItemGroup(placement: .navigation) {
        Text("StyleDemo")
            .font(AppTokens.Font.displaySmall)
            .foregroundStyle(AppTokens.Color.textDisplay(for: colorScheme))
            .padding(.leading, AppTokens.Spacing.md)  // aligns with canvas content
    }
    .sharedBackgroundVisibility(.hidden)

    // CENTER — Current page, inside the auto-applied glass pill
    ToolbarItem(placement: .principal) {
        Text(currentPage.title)
            .font(AppTokens.Font.label)
            .tracking(0.88)
            .textCase(.uppercase)
            .foregroundStyle(AppTokens.Color.textDisplay(for: colorScheme))
            .padding(.horizontal, AppTokens.Spacing.md)
            .padding(.vertical, AppTokens.Spacing.xs)
    }

    // RIGHT — System icons only
    ToolbarItem(placement: .automatic) {
        Button {
            withAnimation(AppTokens.Motion.smooth) { inspectorVisible.toggle() }
        } label: {
            Image(systemName: "sidebar.trailing")
                .symbolVariant(inspectorVisible ? .none : .slash)
        }
        .help("Toggle Inspector")
    }
}
```

### Why `ToolbarItemGroup` + `sharedBackgroundVisibility(.hidden)` for the app title?

macOS 26 Liquid Glass wraps every `ToolbarItem` in its own glass pill
automatically. For the app name we want **plain text**, not a pill — the pill
only belongs on interactive or semantic-state content (the current page). The
only reliable way to opt out is to wrap the item in a `ToolbarItemGroup` and
set `.sharedBackgroundVisibility(.hidden)`, which tells the system not to
draw any background for the group's contents.

A lone `ToolbarItem(placement: .navigation) { Text(...) }` **will** get
pilled. Use the group.

## Canvas Action Bar

Below the window toolbar, at the top of the detail column, every app renders
a **CanvasActionBar** — a horizontal row containing stat pills on the left
and one or more glass action buttons on the right. This is where contextual
metrics and actions live (never in the window toolbar).

```swift
struct CanvasContainer<Content: View>: View {
    @ViewBuilder let content: () -> Content
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            CanvasActionBar()
            Divider().opacity(0.3)
            ScrollView {
                content()
                    .padding(.horizontal, AppTokens.Spacing.xl)
                    .padding(.vertical, AppTokens.Spacing.lg)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
        .background(AppTokens.Color.background(for: colorScheme))
    }
}

private struct CanvasActionBar: View {
    var body: some View {
        HStack(spacing: AppTokens.Spacing.md) {
            GlassEffectContainer {
                HStack(spacing: AppTokens.Spacing.sm) {
                    StatPill(value: "12", label: "SLIDES")
                    StatPill(value: "3", label: "FLAGGED")
                    StatPill(value: "8/12", label: "REVIEWED")
                }
            }
            Spacer()
            GlassEffectContainer {
                GlassButton(label: "Export", icon: "square.and.arrow.up") { }
            }
        }
        .padding(.horizontal, AppTokens.Spacing.xl)
        .padding(.vertical, AppTokens.Spacing.md)
    }
}
```

Horizontal padding on the action bar **must match** the horizontal padding on
the canvas content scroll view (`AppTokens.Spacing.xl` = 32pt). This gives a
clean vertical alignment from the stat pills down through every section
label in the content area.

## Settings — use the `Settings` Scene, not a toolbar gear

App-level settings live in the **macOS app menu**, accessed via `⌘,` or
`AppName → Settings…`. Do **NOT** add a gear icon to the window toolbar or a
settings button to the sidebar footer — both feel wrong in this design
language. SwiftUI provides the `Settings` scene specifically for this:

```swift
@main
struct MyApp: App {
    @State private var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settings)
                .preferredColorScheme(settings.appearance.preferredColorScheme)
        }
        .defaultSize(width: 1440, height: 900)
        .windowStyle(.hiddenTitleBar)

        // Adds the standard "Settings..." item (Cmd+,) to the app menu.
        Settings {
            SettingsPanel(settings: settings)
                .preferredColorScheme(settings.appearance.preferredColorScheme)
        }
    }
}
```

### Multi-page Settings layout

The Settings panel mirrors the main app's NavigationSplitView shape — its
own frosted sidebar (~200pt wide) on the left listing pages, and a detail
pane on the right. Fixed window size (e.g. 760×520), no in-view Done button
(macOS settings windows close via the red traffic light or ⌘W).

```swift
struct SettingsPanel: View {
    @Bindable var settings: AppSettings
    @State private var page: SettingsPage = .appearance
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("SETTINGS").appLabel()
                    .padding(AppTokens.Spacing.md)
                Divider().opacity(0.3)
                ForEach(SettingsPage.allCases) { pageRow($0) }
                Spacer(minLength: 0)
            }
            .frame(width: 200)
            .background(.ultraThinMaterial)

            Divider()

            ScrollView {
                pageContent
                    .padding(.horizontal, AppTokens.Spacing.xl)
                    .padding(.vertical, AppTokens.Spacing.lg)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .background(AppTokens.Color.background(for: colorScheme))
        }
        .frame(width: 760, height: 520)
    }
}
```

## Appearance Override (System / Light / Dark)

Every app must offer a per-window appearance override in Settings, even
though the design system is already adaptive. Use an `@Observable` settings
class with a persisted `AppearanceMode` enum, apply it via
`.preferredColorScheme` at the root, and sync the `NSWindow` background so
the title bar area doesn't flash the wrong color during a light/dark flip:

```swift
@Observable
final class AppSettings {
    enum AppearanceMode: String, CaseIterable, Identifiable {
        case system, light, dark
        var id: String { rawValue }
        var preferredColorScheme: ColorScheme? {
            switch self {
            case .system: return nil
            case .light:  return .light
            case .dark:   return .dark
            }
        }
    }

    var appearance: AppearanceMode {
        didSet {
            UserDefaults.standard.set(appearance.rawValue, forKey: "appearance")
        }
    }

    init() {
        let raw = UserDefaults.standard.string(forKey: "appearance") ?? "system"
        self.appearance = AppearanceMode(rawValue: raw) ?? .system
    }

    /// Resolves `.system` against NSApp's effective appearance so the
    /// window background can flip without waiting for a colorScheme
    /// environment update.
    func effectiveIsDark() -> Bool {
        switch appearance {
        case .dark:   return true
        case .light:  return false
        case .system:
            return NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        }
    }
}

// In ContentView:
.onAppear { syncWindowBackground() }
.onChange(of: settings.appearance) { _, _ in syncWindowBackground() }
.onChange(of: colorScheme)         { _, _ in syncWindowBackground() }

private func syncWindowBackground() {
    let hex = settings.effectiveIsDark() ? "0A0A0A" : "FFFFFF"
    NSApp.windows.forEach { $0.backgroundColor = NSColor(hex: hex) }
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
