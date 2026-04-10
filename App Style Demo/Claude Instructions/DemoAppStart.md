# DemoAppStart — Build Instructions for the Tyler App Style Demo

Build a macOS 26+ SwiftUI app named **`StyleDemo`** that serves as a living visual reference for the Tyler App Style design system. The app has **no real functionality** — every view exists solely to showcase UI primitives so Tyler can visually refine tokens, components, and Liquid Glass usage.

Before writing any code, read these files (all paths are relative to the repo root `/Users/tyler-m3-kc/Documents/03 Claudes House/03 Development Center/tyler-app-style`):

1. `App Style Demo/CLAUDE.md` — project context and working rules
2. `plugins/tyler-app-style/skills/tyler-app-style/SKILL.md` — design system definition
3. `plugins/tyler-app-style/skills/tyler-app-style/references/design-tokens.md` — the full `AppTokens.swift` to copy in
4. `plugins/tyler-app-style/skills/tyler-app-style/references/glass-patterns.md` — Liquid Glass component patterns
5. `plugins/tyler-app-style/skills/tyler-app-style/references/layout-patterns.md` — NavigationSplitView, toolbar, inspector layout
6. `plugins/tyler-app-style/skills/tyler-app-style/references/anti-patterns.md` — what NOT to do
7. `Design Documents/UI Basics-Tyler-App-Style.pdf` — Tyler's anatomy diagram (SideBar / Canvas / Inspector, sidebar states, font family)

---

## 1. Project Setup

Create a new SwiftUI macOS app:

- **Location:** `/Users/tyler-m3-kc/Documents/03 Claudes House/03 Development Center/tyler-app-style/App Style Demo/StyleDemo/`
- **Project name:** `StyleDemo`
- **Interface:** SwiftUI
- **Language:** Swift (6.0+)
- **Deployment target:** macOS 26.0
- **Bundle identifier:** `com.tylergrinblatt.StyleDemo`
- **Includes tests:** No (this is a visual demo, not a testable unit)

After creating the project, verify the target minimum deployment is macOS 26.0 — anything lower will break Liquid Glass APIs (`.glassEffect(...)`, `GlassEffectContainer`, `.buttonStyle(.glass)`).

### 1.1 Folder Structure

Organize the project like this:

```
StyleDemo/
├── StyleDemoApp.swift              # @main entry, title bar fix, AppDelegate
├── ContentView.swift               # NavigationSplitView shell — sidebar + canvas + inspector
├── Design/
│   ├── AppTokens.swift             # Copy verbatim from references/design-tokens.md
│   ├── AppLabelStyle.swift         # .appLabel() modifier
│   ├── Motion.swift                # (if separate from AppTokens)
│   └── NSColor+Hex.swift           # Hex initializer
├── Components/
│   ├── GlassButton.swift
│   ├── StatPill.swift
│   ├── ConnectionBadge.swift
│   ├── GlassPillTitle.swift
│   ├── GlassFilterBar.swift
│   ├── GlassSectionCard.swift
│   ├── SegmentedProgressBar.swift
│   └── GlassSliderHandle.swift
├── Sidebar/
│   ├── SidebarView.swift           # frosted glass sidebar with search + menu
│   ├── SidebarItem.swift           # model: title, icon, section
│   ├── SidebarRow.swift            # one menu row (respects Full vs Condensed state)
│   └── SidebarSearch.swift         # search field
├── Canvas/
│   ├── CanvasHeader.swift          # shows App Title + contextual toolbar info
│   └── CanvasContainer.swift       # wraps each showcase in a consistent frame
├── Showcases/
│   ├── OverviewShowcase.swift      # anatomy diagram rendered as a live app
│   ├── ButtonsShowcase.swift       # glass buttons, icon buttons, destructive, etc.
│   ├── MenuItemsShowcase.swift     # sidebar row states, menus, pickers
│   ├── LiquidGlassShowcase.swift   # where glass goes vs where it does not
│   ├── TypographyShowcase.swift    # Geist / Geist Mono / Geist Pixel, all weights
│   ├── ColorsShowcase.swift        # full palette, dark + light side-by-side
│   ├── MotionShowcase.swift        # snappy / smooth / bouncy demos
│   └── InspectorShowcase.swift     # showcase that activates the right inspector panel
├── Inspector/
│   └── InspectorPanel.swift        # right-side collapsible panel
├── Resources/
│   ├── Fonts/                      # Geist / GeistMono / GeistPixel .otf or .ttf files
│   └── Assets.xcassets             # app icon, accent color (set to #E5600A)
└── Info.plist                      # ATSApplicationFontsPath entry for Geist
```

Create this structure exactly. Do not collapse multiple concerns into a single file — the demo should be easy to navigate and each component should live where you would expect it.

### 1.2 Fonts

If Geist font files are already present in `Resources/Fonts/`, register them by adding this key to `Info.plist`:

```xml
<key>ATSApplicationFontsPath</key>
<string>Fonts</string>
```

Then add each `.otf` / `.ttf` file to the app target's "Copy Bundle Resources" build phase. Reference them in Swift by their **exact PostScript name** (e.g. `Geist-Bold`, `GeistMono-Regular`, `GeistPixel-Regular`). Do not guess — if Tyler has not yet provided the font files, fall back to `.system(size:, weight:, design: .default/.monospaced)` and leave a `// TODO: swap to Geist when bundled` comment next to each font token.

Tyler's PDF design document specifies these weights for the demo typography showcase:

- **Geist** — Black, Bold, Medium, Light
- **Geist Mono** — Black, Bold, Medium, Light
- **Geist Pixel** — Regular only (treat as a decorative/pixel-art face)

The Typography showcase should display a complete grid of these weights with a sample pangram at each.

---

## 2. App Entry + Title Bar Fix

`StyleDemoApp.swift`:

```swift
import SwiftUI
import AppKit

@main
struct StyleDemoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.colorScheme) private var colorScheme

    var body: some Scene {
        WindowGroup {
            ContentView()
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                .frame(minWidth: 1100, minHeight: 720)
        }
        .defaultSize(width: 1440, height: 900)
        .windowStyle(.hiddenTitleBar)  // we draw our own title via CanvasHeader
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let window = NSApp.windows.first else { return }
        window.titlebarAppearsTransparent = true
        // Match the background token; NSColor(hex:) lives in NSColor+Hex.swift
        window.backgroundColor = NSColor(hex: "0A0A0A")
        window.isMovableByWindowBackground = true
    }
}
```

Critical notes:

- `.toolbarBackgroundVisibility(.hidden, for: .windowToolbar)` is not optional. Without it, macOS 26 draws a grey/black title bar seam.
- `window.backgroundColor` must match the dark-mode background token (`#0A0A0A`). When the app opens in light mode the background flips through the `AppTokens.Color.background(for:)` function, but the base window color stays dark so the traffic lights never flash.
- Do **not** use `.windowToolbarStyle(.unified)`. It re-enables the default toolbar background.

---

## 3. Design Tokens

Copy `AppTokens.swift` from `plugins/tyler-app-style/skills/tyler-app-style/references/design-tokens.md` into `Design/AppTokens.swift` **verbatim**. Do not trim, do not rename, do not inline anything. If the copy needs minor refactoring (splitting `AppTokens_continued` into a single enum, separating `NSFont` extensions into a sibling file), keep the public API identical so references across the demo continue to compile.

After copying, verify the following are reachable from any view:

- `AppTokens.Color.background(for:)`, `surface(for:)`, `surfaceElevated(for:)`, `border(for:)`, `borderStrong(for:)`
- `AppTokens.Color.textPrimary(for:)`, `textDisplay(for:)`, `textSecondary(for:)`, `textTertiary(for:)`
- `AppTokens.Color.accent`, `accentDim(for:)`, `destructive`, `warning`, `success`, `info`
- `AppTokens.Font.displayLarge / displayMedium / displaySmall / headingLarge / headingSmall / bodyLarge / bodySmall / caption / label / numeric / numericSmall`
- `AppTokens.Spacing.xxs / xs / sm / md / lg / xl / xxl / xxxl`
- `AppTokens.Radius.sm / md / lg / xl`
- `AppTokens.Motion.snappy / smooth / bouncy`
- `AppTokens.Border.hairline / thin / medium`
- `.appLabel()` view modifier

Add `.accentColor = #E5600A` to the app's asset catalog so `AccentColor` also matches.

---

## 4. Core Shell — `ContentView.swift`

The shell is a `NavigationSplitView` with three visible regions: **Sidebar** (left), **Canvas** (center), and **Inspector** (right, collapsible). The Inspector is only visible when the active showcase requests it, or when the user toggles it via the toolbar.

```swift
import SwiftUI

enum Showcase: String, CaseIterable, Identifiable {
    case overview, buttons, menuItems, liquidGlass, typography, colors, motion, inspector
    var id: String { rawValue }

    var title: String {
        switch self {
        case .overview: return "Overview"
        case .buttons: return "Buttons"
        case .menuItems: return "Menu Items"
        case .liquidGlass: return "Liquid Glass"
        case .typography: return "Typography"
        case .colors: return "Colors"
        case .motion: return "Motion"
        case .inspector: return "Inspector"
        }
    }

    var icon: String {
        switch self {
        case .overview: return "square.grid.2x2"
        case .buttons: return "rectangle.roundedtop"
        case .menuItems: return "list.bullet"
        case .liquidGlass: return "circle.hexagongrid.fill"
        case .typography: return "textformat"
        case .colors: return "paintpalette"
        case .motion: return "waveform.path"
        case .inspector: return "sidebar.right"
        }
    }

    var section: String {
        switch self {
        case .overview: return "START"
        case .buttons, .menuItems, .liquidGlass: return "COMPONENTS"
        case .typography, .colors, .motion: return "STYLES"
        case .inspector: return "LAYOUT"
        }
    }
}

struct ContentView: View {
    @State private var selected: Showcase = .overview
    @State private var searchText: String = ""
    @State private var inspectorVisible: Bool = false
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(selected: $selected, searchText: $searchText)
                .navigationSplitViewColumnWidth(min: 220, ideal: 300, max: 360)
        } detail: {
            HStack(spacing: 0) {
                CanvasContainer(title: "StyleDemo", subtitle: selected.title) {
                    showcaseView(for: selected)
                }
                .frame(maxWidth: .infinity)

                if inspectorVisible || selected == .inspector {
                    Divider()
                    InspectorPanel()
                        .frame(width: 300)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .toolbar { canvasToolbar }
            .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
            .animation(AppTokens.Motion.smooth, value: inspectorVisible)
            .animation(AppTokens.Motion.smooth, value: selected)
        }
        .background(AppTokens.Color.background(for: colorScheme))
    }

    @ViewBuilder
    private func showcaseView(for showcase: Showcase) -> some View {
        switch showcase {
        case .overview: OverviewShowcase()
        case .buttons: ButtonsShowcase()
        case .menuItems: MenuItemsShowcase()
        case .liquidGlass: LiquidGlassShowcase()
        case .typography: TypographyShowcase()
        case .colors: ColorsShowcase()
        case .motion: MotionShowcase()
        case .inspector: InspectorShowcase()
        }
    }

    @ToolbarContentBuilder
    private var canvasToolbar: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            GlassEffectContainer {
                HStack(spacing: AppTokens.Spacing.sm) {
                    StatPill(value: "\(Showcase.allCases.count)", label: "SHOWCASES")
                    StatPill(value: "2", label: "SCHEMES")
                    StatPill(value: "1", label: "ACCENT")
                }
            }
        }

        ToolbarItem(placement: .automatic) {
            GlassButton(label: "Export Mock", icon: "square.and.arrow.up") { /* no-op */ }
        }

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
}
```

**Critical requirements:**

- The sidebar **must** use `.background(.ultraThinMaterial)` (set inside `SidebarView`). No opaque child backgrounds.
- The Inspector panel shows automatically when `selected == .inspector` so the user can see the inspector anatomy live. It can also be toggled independently via the toolbar button.
- Use `NavigationSplitView`'s built-in column toggling for the **Full Width ↔ Condensed** transition. The user drives this via the standard macOS sidebar button (the system draws one at the top-left of the canvas column). Do not build a custom toggle — rely on the system toggle so the demo accurately represents what every future Tyler App Style app will ship.

---

## 5. Sidebar (frosted, with search, respecting both states)

`Sidebar/SidebarView.swift`:

```swift
import SwiftUI

struct SidebarView: View {
    @Binding var selected: Showcase
    @Binding var searchText: String
    @Environment(\.colorScheme) private var colorScheme

    private var filtered: [Showcase] {
        guard !searchText.isEmpty else { return Showcase.allCases }
        return Showcase.allCases.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var sections: [(String, [Showcase])] {
        let grouped = Dictionary(grouping: filtered, by: { $0.section })
        let order = ["START", "COMPONENTS", "STYLES", "LAYOUT"]
        return order.compactMap { key in
            guard let items = grouped[key], !items.isEmpty else { return nil }
            return (key, items)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // SEARCH — top of the sidebar body
            SidebarSearch(text: $searchText)
                .padding(.horizontal, AppTokens.Spacing.md)
                .padding(.top, AppTokens.Spacing.sm)
                .padding(.bottom, AppTokens.Spacing.sm)

            // MENU — scrolling, grouped by section
            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
                    ForEach(sections, id: \.0) { section, items in
                        VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
                            Text(section).appLabel()
                                .padding(.horizontal, AppTokens.Spacing.md)
                            ForEach(items) { item in
                                SidebarRow(
                                    item: item,
                                    isSelected: selected == item
                                ) {
                                    withAnimation(AppTokens.Motion.snappy) { selected = item }
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, AppTokens.Spacing.sm)
            }

            Spacer(minLength: 0)
        }
        .background(.ultraThinMaterial)  // frosted glass — never override
    }
}
```

`Sidebar/SidebarRow.swift` must handle both sidebar states. The row should render differently based on available width — when the sidebar is condensed, hide the label and center the icon:

```swift
struct SidebarRow: View {
    let item: Showcase
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered: Bool = false

    var body: some View {
        Button(action: action) {
            ViewThatFits(in: .horizontal) {
                // Full Width: icon + label
                HStack(spacing: AppTokens.Spacing.sm) {
                    Image(systemName: item.icon)
                        .font(.system(size: 13, weight: .medium))
                        .frame(width: 20)
                    Text(item.title)
                        .font(AppTokens.Font.headingSmall)
                    Spacer(minLength: 0)
                }
                // Condensed Width: icon only
                Image(systemName: item.icon)
                    .font(.system(size: 15, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .foregroundStyle(
                isSelected
                    ? AppTokens.Color.textDisplay(for: colorScheme)
                    : AppTokens.Color.textSecondary(for: colorScheme)
            )
            .padding(.horizontal, AppTokens.Spacing.md)
            .padding(.vertical, AppTokens.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                    .fill(
                        isSelected
                            ? AppTokens.Color.accent.opacity(0.18)
                            : (isHovered ? AppTokens.Color.surface(for: colorScheme).opacity(0.6) : .clear)
                    )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { isHovered = $0 }
        .padding(.horizontal, AppTokens.Spacing.xs)
        .help(item.title)
    }
}
```

`ViewThatFits` is the simplest way to satisfy the PDF's "Full Width vs Condensed Width" requirement without writing width-measurement code. When the column is narrow the full-label variant no longer fits and SwiftUI automatically swaps to the icon-only fallback.

`Sidebar/SidebarSearch.swift`:

```swift
struct SidebarSearch: View {
    @Binding var text: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: AppTokens.Spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
            TextField("Search", text: $text)
                .textFieldStyle(.plain)
                .font(AppTokens.Font.bodySmall)
                .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
        }
        .padding(.horizontal, AppTokens.Spacing.sm)
        .padding(.vertical, AppTokens.Spacing.xs + 2)
        .background(
            RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                .fill(AppTokens.Color.surface(for: colorScheme).opacity(0.6))
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                .strokeBorder(
                    AppTokens.Color.border(for: colorScheme).opacity(0.5),
                    lineWidth: AppTokens.Border.hairline
                )
        )
    }
}
```

---

## 6. Canvas Header and Container

The canvas needs to display the **App Title** prominently (as specified in the PDF). Use a dedicated header strip at the top of the canvas column rather than stuffing it into the system toolbar.

`Canvas/CanvasHeader.swift`:

```swift
struct CanvasHeader: View {
    let title: String
    let subtitle: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: AppTokens.Spacing.md) {
            Text(title)
                .font(AppTokens.Font.displayMedium)
                .foregroundStyle(AppTokens.Color.textDisplay(for: colorScheme))
            Text(subtitle)
                .font(AppTokens.Font.label)
                .tracking(0.88)
                .textCase(.uppercase)
                .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
            Spacer()
        }
        .padding(.horizontal, AppTokens.Spacing.xl)
        .padding(.top, AppTokens.Spacing.lg)
        .padding(.bottom, AppTokens.Spacing.md)
    }
}
```

`Canvas/CanvasContainer.swift` wraps every showcase so the app title and section padding are consistent:

```swift
struct CanvasContainer<Content: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder let content: () -> Content
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            CanvasHeader(title: title, subtitle: subtitle)
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
```

---

## 7. Reusable Components

Each component below should live in its own file under `Components/`. Copy the bodies from the parent repo's reference files verbatim and only adapt property names for clarity. Do not invent new APIs.

| File | Copied from | Notes |
|---|---|---|
| `GlassButton.swift` | `glass-patterns.md` → `GlassButton` | Label, icon, isActive, tint, action |
| `StatPill.swift` | `glass-patterns.md` → `StatPill` | Value + ALL-CAPS label |
| `ConnectionBadge.swift` | `glass-patterns.md` → `ConnectionBadge` | Status pill with colored glass |
| `GlassPillTitle.swift` | `glass-patterns.md` → Glass Pill Title | Overlay titles |
| `GlassFilterBar.swift` | `glass-patterns.md` → Glass Filter Bar | Segmented pill group |
| `GlassSectionCard.swift` | `layout-patterns.md` → `GlassSectionCard` | Card for note/annotation content |
| `SegmentedProgressBar.swift` | `design-tokens.md` → `SegmentedProgressBar` | Already in AppTokens |
| `GlassSliderHandle.swift` | `glass-patterns.md` → Glass Slider Handle | Circle with arrow.left.and.right |

Every component must accept `@Environment(\.colorScheme)` and use the `(for: colorScheme)` token functions — do not create dark-only versions.

---

## 8. Showcases (the heart of the demo)

Each showcase lives in `Showcases/`. They are pure presentation — no state beyond local hover/selection. Build them in the order below because later showcases depend on components introduced in earlier ones.

### 8.1 `OverviewShowcase.swift`

A live rendition of the PDF anatomy diagram. Show a labeled cross-section of the app identifying:

1. Window Controls (traffic lights) callout
2. SideBar Toggle callout
3. App Title callout
4. Search field callout
5. Menu items callout
6. Canvas area callout
7. Full Width sidebar state (mini preview)
8. Condensed Width sidebar state (mini preview)

Implementation: render two small "mini app" previews side-by-side inside `GlassSectionCard` containers, each showing the same mock app at the two sidebar widths. Use numbered pins overlaid on top of each anchor element, with a legend below the previews explaining each number. Use the `accent` color for the pins so they pop against the monochrome.

Do **not** try to recreate the anatomy inside a single drawn diagram — build it with real SwiftUI views. That's the whole point of the showcase: seeing the anatomy rendered as the app itself runs.

### 8.2 `ButtonsShowcase.swift`

Sections (each wrapped in `GlassSectionCard` with an `.appLabel()` header):

- **PRIMARY GLASS BUTTONS** — default, hover, active (tinted orange), disabled
- **ICON-ONLY GLASS BUTTONS** — 28pt square with `.buttonStyle(.glass)`
- **DESTRUCTIVE** — glass button tinted with `destructive.opacity(0.2)`
- **FILTER PILLS** — four `GlassFilterBar` pills with one selected
- **STAT PILLS** — row of three `StatPill` values
- **CONNECTION BADGES** — four `ConnectionBadge` with success / warning / destructive / info tints
- **TOOLBAR ICON** — `Image(systemName: "sidebar.trailing")` with and without `.symbolVariant(.slash)`

Every button-like surface must show at least two visible states. For hover, use `onHover` + `scaleEffect(1.03)` with `Motion.snappy`.

### 8.3 `MenuItemsShowcase.swift`

Sections:

- **SIDEBAR ROW STATES** — four stacked `SidebarRow` instances showing: default, hovered, selected, selected + hovered. Include both Full Width and Condensed variants side-by-side so Tyler can see the rows in both modes without actually resizing the real sidebar.
- **CONTEXT MENU** — a `GlassSectionCard` with a "Right-click me" hint; wire `.contextMenu` with 3 items (Rename, Duplicate, Delete).
- **DROPDOWN PICKER** — a `Picker` with 4 options, styled to match the AppTokens palette (wrap in a glass pill or plain rounded surface).
- **TOGGLE GROUP** — 2 `Toggle` switches with ALL-CAPS labels.
- **SEGMENTED CONTROL** — `Picker` with `.pickerStyle(.segmented)` showing 3 modes, placed inside a `GlassEffectContainer`.

### 8.4 `LiquidGlassShowcase.swift`

This is the single most important showcase. It must visually teach the "glass on chrome, flat on content" rule.

Split the canvas into a 2-column layout:

**Left column — "GLASS GOES HERE"** (title via `.appLabel()`):
- Toolbar buttons
- Filter bar
- Stat pills
- Badges
- Drop zone placeholder with `.glassEffect(.regular.tint(accent.opacity(0.05)), in: .rect(cornerRadius: Radius.xl))`
- Slider handle
- Glass Pill Title over a mock content area

**Right column — "GLASS DOES NOT GO HERE"**:
- Mock slide thumbnail (use a gradient-filled `RoundedRectangle` with a caption below)
- Mock diff text (3 lines of monospaced text on surface background with `diffAddedBg` / `diffRemovedBg` highlights)
- Mock chart (3 `Rectangle` bars filled with `accent`)
- Mock annotation overlay (a `Circle` with a number badge on top of a surface placeholder)
- Mock speaker notes text block (`GlassSectionCard` is allowed here because it's using the flat surface fill, not the `.glassEffect` modifier — make sure to point this distinction out in a comment)

Add a caption under each example noting why (e.g. "Selected filter → active state chrome → glass allowed" vs "Slide image → content surface → must be flat").

Every glass element on the left must be inside a `GlassEffectContainer`. If two different glass components are nearby, wrap both in the same container.

### 8.5 `TypographyShowcase.swift`

Three panels (one per font family): **GEIST**, **GEIST MONO**, **GEIST PIXEL**.

For **GEIST** and **GEIST MONO**, show every weight specified in the PDF: Black / Bold / Medium / Light. For each weight, render:

- A weight label (`.appLabel()`)
- A 42pt sample line: "The quick brown fox jumps over the lazy dog"
- A 14pt sample line: "0123456789 !@#$%^&*()"

For **GEIST PIXEL**, render only the default weight with a fun pixel-style sample like "HELLO WORLD" and "AA BB CC 00 11 22".

Below the three family panels, render the full `AppTokens.Font` token table with each token used on its own line and a label showing the token name:

```
DISPLAY LARGE    →  The quick brown fox
DISPLAY MEDIUM   →  The quick brown fox
...
LABEL            →  THE QUICK BROWN FOX (tracking 0.88)
NUMERIC          →  0123456789
NUMERIC SMALL    →  0123456789
```

If Geist is not yet bundled, use `.system(size:, weight:)` (sans) and `.system(size:, weight:, design: .monospaced)` as fallbacks and place a persistent `ConnectionBadge(label: "GEIST FONTS NOT BUNDLED", color: .warning)` at the top of the showcase.

### 8.6 `ColorsShowcase.swift`

Render every token color as a swatch. Layout: a `LazyVGrid` with 4 columns. Each swatch is:

- 72×72 square filled with the token color
- Below: token name in `.appLabel()`
- Below: hex value in `AppTokens.Font.caption`

Group the swatches into sections with `.appLabel()` headers:

1. **SURFACES** — background, surface, surfaceElevated, border, borderStrong
2. **TEXT** — textPrimary, textDisplay, textSecondary, textTertiary
3. **ACCENT** — accent, accentDim
4. **STATUS** — destructive, warning, success, info
5. **DIFF** — diffAddedBg, diffRemovedBg, diffChangedBg

Each swatch must render using `AppTokens.Color.<name>(for: colorScheme)` so toggling the OS color scheme swaps every swatch at once. Text color inside each swatch must pick black or white based on luminance for legibility.

Add a bold note at the top of the showcase: "Toggle System Settings → Appearance to see dark/light mode."

### 8.7 `MotionShowcase.swift`

Three buttons, one per `Motion` preset (`snappy`, `smooth`, `bouncy`). Each button triggers an offset animation on a 48×48 accent-colored square. Place the squares in a row with labels underneath so Tyler can visually compare the feel of each spring.

Add a fourth section demonstrating `.transition(.move(edge: .trailing).combined(with: .opacity))` with a "Show/Hide" toggle, mirroring the inspector panel animation.

### 8.8 `InspectorShowcase.swift`

A minimal view that says "The Inspector panel is visible on the right side of the canvas whenever this showcase is selected." Include a `GlassSectionCard` summarising what the inspector is for (contextual detail, secondary controls, notes, metadata).

The `ContentView` already opens the inspector panel automatically when `selected == .inspector`, so this showcase just needs to explain the pattern.

---

## 9. Inspector Panel

`Inspector/InspectorPanel.swift`:

```swift
import SwiftUI

struct InspectorPanel: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("INSPECTOR").appLabel()
                Spacer()
                Text("STYLE DEMO").font(AppTokens.Font.caption)
                    .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
            }
            .padding(.horizontal, AppTokens.Spacing.md)
            .frame(height: 44)
            .background(AppTokens.Color.surface(for: colorScheme).opacity(0.5))

            // Content
            ScrollView {
                VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        Text("DETAILS").appLabel()
                        GlassSectionCard {
                            VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
                                InspectorRow(key: "SURFACE", value: "Liquid Glass")
                                InspectorRow(key: "ACCENT", value: "#E5600A")
                                InspectorRow(key: "RADIUS", value: "12pt")
                                InspectorRow(key: "MOTION", value: "smooth")
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        Text("NOTES").appLabel()
                        GlassSectionCard {
                            Text("The Inspector panel provides contextual detail for the selected showcase. It collapses with a spring animation and never contains primary navigation.")
                                .font(AppTokens.Font.bodySmall)
                                .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
                        }
                    }

                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        Text("ACTIONS").appLabel()
                        HStack(spacing: AppTokens.Spacing.sm) {
                            GlassButton(label: "Save", icon: "checkmark") { /* no-op */ }
                            GlassButton(label: "Revert", icon: "arrow.uturn.backward") { /* no-op */ }
                        }
                    }
                }
                .padding(AppTokens.Spacing.md)
            }
        }
        .background(AppTokens.Color.background(for: colorScheme))
    }
}

struct InspectorRow: View {
    let key: String
    let value: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack {
            Text(key).appLabel()
            Spacer()
            Text(value)
                .font(AppTokens.Font.bodySmall)
                .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
        }
    }
}
```

---

## 10. Validation Checklist

After the app builds, run through this checklist before declaring the demo done. Every item must be visually verified by opening the app.

**Anatomy**
- [ ] Traffic lights (red/yellow/green) sit flush with the top of the sidebar column
- [ ] Sidebar toggle button (system-provided) expands/collapses the sidebar
- [ ] App Title "StyleDemo" appears in the canvas header
- [ ] Search field appears at the top of the sidebar body
- [ ] Menu items are grouped under ALL-CAPS section headers (START, COMPONENTS, STYLES, LAYOUT)
- [ ] Inspector panel appears on the right when toggled or when the Inspector showcase is selected

**Sidebar states**
- [ ] Full Width: icons + labels are visible for every menu row
- [ ] Condensed Width: only icons remain, centered in the column
- [ ] The transition between states uses a spring animation (no jank)
- [ ] The sidebar background is `.ultraThinMaterial` (frosted), not opaque
- [ ] No sidebar child view has an opaque `.background()` that hides the material

**Title bar fix**
- [ ] Title bar has no grey/black seam in either color scheme
- [ ] Window background color matches the `background` token at launch
- [ ] `.toolbarBackgroundVisibility(.hidden, for: .windowToolbar)` is applied

**Liquid Glass**
- [ ] Every adjacent glass group is wrapped in `GlassEffectContainer`
- [ ] Glass elements use `.tint(...)` with opacity ≤ 0.3
- [ ] No glass is applied to content (slide placeholders, diff text, chart bars, annotations)
- [ ] Toolbar buttons use `.buttonStyle(.glass)`

**Typography**
- [ ] All labels use `.appLabel()` (ALL-CAPS + 0.88 tracking)
- [ ] Data / numbers use monospace
- [ ] Headings use sans-serif
- [ ] Geist weights are present (or fallback + warning badge is shown)

**Color scheme**
- [ ] Every view renders correctly in dark mode AND light mode
- [ ] No hardcoded `Color(hex:)` outside `AppTokens`
- [ ] No `.primary` / `.secondary` / `Color(.systemBackground)` usage

**Motion**
- [ ] Every animation uses `AppTokens.Motion.snappy / smooth / bouncy`
- [ ] No `.easeIn`, `.easeOut`, `.linear`, or `.easeInOut` anywhere in the codebase

**Interaction**
- [ ] Every clickable row has `.contentShape(Rectangle())`
- [ ] Every icon/button has a `.help(...)` tooltip
- [ ] Hover states scale by 1.03 with `Motion.snappy`

---

## 11. Build, Run, and Report Back

1. Build the app with `⌘B` in Xcode. Fix compile errors before running.
2. Run with `⌘R`.
3. Cycle through every showcase and verify the checklist above.
4. Toggle System Settings → Appearance between Dark and Light to check color scheme adaptation.
5. Resize the window down to ~1100pt wide and confirm the sidebar collapses to Condensed state via `ViewThatFits`.
6. Report back to Tyler with:
   - The list of showcases implemented
   - Any checklist items that fall short (and why)
   - Screenshots of each showcase in both color schemes (save them to `App Style Demo/Screenshots/`)
   - Any tokens, components, or patterns that feel missing from the parent skill and would need a follow-up in the skill plugin

Do not proceed past any failing checklist item by silently working around it. If you cannot satisfy an item, stop and ask Tyler how to proceed.

---

## 12. Out of Scope (do not build)

- Real file I/O, network calls, persistence, or preferences beyond `@State`
- Annotation tools, pin placement, draw boxes — those live in the separate annotation-patterns reference and are not part of this demo
- Document import / export — the "Export" button in the toolbar is a mock
- Multi-window, secondary scenes, menu bar extras
- Localization beyond the default English strings
- Accessibility beyond what SwiftUI gives for free (tooltips via `.help` and default VoiceOver)

If a request during the build would require any of the above, flag it and keep going without it. The demo's value is its purity as a style reference — growing it into a real app would dilute that.
