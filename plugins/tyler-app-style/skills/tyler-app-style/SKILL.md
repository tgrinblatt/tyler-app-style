---
name: tyler-app-style
description: Build macOS SwiftUI apps using Tyler App Style — a hybrid design system combining Nothing Design (dark monochrome palette, orange accent, all-caps tracking labels, monospace data fonts, 8pt spacing grid) with Apple Liquid Glass (glassEffect, GlassEffectContainer, NavigationSplitView floating sidebars, spring animations, buttonStyle(.glass), system materials). Supports dark and light ColorScheme with adaptive tokens. Use when creating new SwiftUI apps with a dark professional aesthetic, applying glass effects to dark-themed UIs, building macOS 26+ Tahoe apps with translucent chrome, or when the user asks for "Tyler style", "Tyler App Style", "Nothing + Apple", or "dark glass" design patterns.
---

# Tyler App Style

A hybrid SwiftUI design system for macOS 26+ that combines **Nothing Design's** dark, typographic discipline with **Apple's Liquid Glass** translucency and native navigation patterns. Supports both **dark and light** color schemes via `ColorScheme`-adaptive token functions.

## Core Principles

1. **Dark-first, light-ready**: `#0A0A0A` background (dark) / `#FFFFFF` (light), monochrome surfaces, adaptive text hierarchy
2. **Glass on chrome, never on content**: Liquid Glass (`glassEffect`) is applied to toolbars, sidebars, buttons, badges, filters — never to data content like slide images, text diffs, or charts
3. **Orange accent sparingly**: `#E5600A` for selected states, active filters, annotation highlights, and interactive glass tint only
4. **Typography as hierarchy**: All-caps labels with 0.88pt tracking for section headers and controls. Monospace for data/numbers. Sans-serif for headings.
5. **8pt spacing grid**: All spacing derives from multiples of 8 (2, 4, 8, 16, 24, 32, 48, 64)
6. **Spring animations**: All transitions use `spring(duration:bounce:)` — no linear or easeIn/Out
7. **Floating navigation**: `NavigationSplitView` for sidebars, native toolbar for chrome, `TabView` for modes
8. **Frosted glass sidebar**: `.ultraThinMaterial` on sidebar background — never overridden by opaque child backgrounds
9. **Seamless title bar**: `.toolbarBackgroundVisibility(.hidden, for: .windowToolbar)` with transparent title bar styling

## When to Use This Skill

- Building a new macOS SwiftUI app targeting macOS 26+
- Adding Liquid Glass to an existing dark-themed app
- Creating professional/productivity tools (document comparison, review, analysis)
- User asks for "Tyler App Style", "dark glass", or "Nothing + Apple" design
- Migrating a Nothing Design app to use Apple's native glass effects

## Design Tokens

### Colors (ColorScheme-Adaptive)

All views MUST reference these tokens — no hardcoded colors. Colors are provided via functions that accept a `ColorScheme` parameter so the app adapts to dark and light mode.

```swift
enum AppTokens {
    enum Color {
        // Core palette
        static func background(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "0A0A0A")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "FFFFFF")!)
        }
        static func surface(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "111111")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "F5F5F5")!)
        }
        static func surfaceElevated(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "1A1A1A")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "EBEBEB")!)
        }
        static func border(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "222222")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "DDDDDD")!)
        }
        static func borderStrong(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "333333")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "CCCCCC")!)
        }

        // Text hierarchy
        static func textPrimary(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "E8E8E8")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "1A1A1A")!)
        }
        static func textDisplay(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark ? .white : .black
        }
        static func textSecondary(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "999999")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "666666")!)
        }
        static func textTertiary(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "666666")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "999999")!)
        }

        // Accent — used sparingly for selected/focused/interactive states
        static let accent = SwiftUI.Color(nsColor: NSColor(hex: "E5600A")!)
        static func accentDim(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "3D2510")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "FFF0E6")!)
        }

        // Status — same in both schemes
        static let destructive = SwiftUI.Color(nsColor: NSColor(hex: "CC1018")!)
        static let warning = SwiftUI.Color(nsColor: NSColor(hex: "B8912E")!)
        static let success = SwiftUI.Color(nsColor: NSColor(hex: "2D8A3E")!)
        static let info = SwiftUI.Color(nsColor: NSColor(hex: "2E6FBA")!)

        // Diff backgrounds (very dark/light tints — subtle, never bright)
        static func diffAddedBg(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "1A2E1A")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "E6F5E6")!)
        }
        static func diffRemovedBg(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "2E1A1A")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "F5E6E6")!)
        }
        static func diffChangedBg(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "1A1A2E")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "E6E6F5")!)
        }
    }
}
```

### Typography

Use **Geist** (sans-serif) for headings/labels and **GeistMono** (monospace) for data/numbers/body. Fall back to system fonts if Geist is not bundled.

```swift
enum Font {
    // Display — bold sans-serif for titles
    static let displayLarge: SwiftUI.Font = .system(size: 42, weight: .bold)
    static let displayMedium: SwiftUI.Font = .system(size: 28, weight: .bold)
    static let displaySmall: SwiftUI.Font = .system(size: 20, weight: .semibold)

    // Headings
    static let headingLarge: SwiftUI.Font = .system(size: 17, weight: .medium)
    static let headingSmall: SwiftUI.Font = .system(size: 13, weight: .medium)

    // Body — monospace for data
    static let bodyLarge: SwiftUI.Font = .system(size: 15, weight: .regular, design: .monospaced)
    static let bodySmall: SwiftUI.Font = .system(size: 12, weight: .regular, design: .monospaced)

    // Caption & Label
    static let caption: SwiftUI.Font = .system(size: 10, weight: .regular, design: .monospaced)
    static let label: SwiftUI.Font = .system(size: 11, weight: .medium)  // ALL-CAPS + 0.88 tracking

    // Numeric — bold monospace for stats
    static let numeric: SwiftUI.Font = .system(size: 24, weight: .bold, design: .monospaced)
    static let numericSmall: SwiftUI.Font = .system(size: 14, weight: .bold, design: .monospaced)
}
```

### NSFont Equivalents (for AppKit / NSViewRepresentable contexts)

When building `NSViewRepresentable` wrappers (e.g. for `NSTextView`, `NSTextField`, or custom AppKit drawing), use `NSFont` equivalents of the SwiftUI tokens:

```swift
extension NSFont {
    static let appBodySmall = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
    static let appCaption = NSFont.monospacedSystemFont(ofSize: 10, weight: .regular)
    static let appLabel = NSFont.systemFont(ofSize: 11, weight: .medium)
    static let appHeadingSmall = NSFont.systemFont(ofSize: 13, weight: .medium)
    static let appNumericSmall = NSFont.monospacedSystemFont(ofSize: 14, weight: .bold)
}
```

### Spacing (8pt Grid)

```swift
enum Spacing {
    static let xxs: CGFloat = 2
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
    static let xxl: CGFloat = 48
    static let xxxl: CGFloat = 64
}
```

### Corner Radius

```swift
enum Radius {
    static let sm: CGFloat = 4    // Thumbnails, checkboxes
    static let md: CGFloat = 8    // Cards, panels
    static let lg: CGFloat = 12   // Drop zones, slide images
    static let xl: CGFloat = 16   // Large containers
}
```

### Motion — Spring Animations Only

```swift
enum Motion {
    static let snappy: Animation = .spring(duration: 0.25, bounce: 0.0)   // Selection, toggles
    static let smooth: Animation = .spring(duration: 0.35, bounce: 0.0)   // Panel show/hide
    static let bouncy: Animation = .spring(duration: 0.4, bounce: 0.15)   // Playful emphasis
}
```

## Title Bar Fix

On macOS 26, using `.windowToolbarStyle(.unified)` or default toolbar styles often produces a grey/black title bar that does not match the app background. The fix:

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
        }
        .defaultSize(width: 1440, height: 900)
    }
}
```

Then in your `NSApplicationDelegateAdaptor` or window configuration:

```swift
if let window = NSApp.windows.first {
    window.titlebarAppearsTransparent = true
    window.backgroundColor = NSColor(hex: "0A0A0A")  // Match your background token
}
```

This ensures the title bar blends seamlessly with the app background in both dark and light mode.

## Frosted Glass Sidebar

Instead of a solid-color sidebar background, use `.ultraThinMaterial` for a frosted glass effect:

```swift
NavigationSplitView {
    sidebarContent
        .background(.ultraThinMaterial)
        .navigationSplitViewColumnWidth(min: 200, ideal: 300, max: 400)
} detail: {
    detailContent
}
```

**Critical rule**: Individual views inside the sidebar must NOT set their own opaque `.background()` — doing so defeats the frosted glass effect. Use `.clear` or no background on child views.

## Liquid Glass Integration Rules

### Where to Apply Glass

Glass goes on the **navigation layer** — surfaces the user interacts with to control the app:

| Element | Glass Treatment |
|---------|----------------|
| Toolbar buttons | `.buttonStyle(.glass)` |
| Filter pills | `.glassEffect(.regular.tint(color).interactive(), in: .capsule)` |
| Stat badges | `.glassEffect(.regular.tint(surface), in: .capsule)` |
| Connection badges | `.glassEffect(.regular.tint(color.opacity(0.15)), in: .capsule)` |
| Sidebar | `NavigationSplitView` (system glass sidebar) |
| Tab bar | `TabView` with `Tab()` (system glass tab bar) |
| Slider handle | `.glassEffect(.regular.interactive(), in: .circle)` |
| Drop zones | `.glassEffect(.regular.tint(accent.opacity(0.05)), in: .rect(cornerRadius:))` |

### Where NOT to Apply Glass

- Slide images / thumbnails (content, not chrome)
- Diff text areas (data display)
- Connector Bezier lines (data visualization)
- Annotation overlays (user-created content)
- Speaker notes / text fields (editable content)

### GlassEffectContainer

**Always** wrap adjacent glass elements in a `GlassEffectContainer`. Glass cannot correctly sample other glass — the container prevents visual artifacts.

```swift
GlassEffectContainer {
    HStack(spacing: Spacing.xxs) {
        ForEach(filters) { filter in
            Button { ... } label: { Text(filter.label) ... }
                .buttonStyle(.plain)
                .glassEffect(
                    selected == filter
                        ? .regular.tint(Color.accent.opacity(0.2)).interactive()
                        : .clear,
                    in: .capsule
                )
        }
    }
}
```

### Glass Tinting

- **Active/selected state**: `.tint(Color.accent.opacity(0.2))` — subtle orange warmth
- **Neutral chrome**: `.tint(Color.surface.opacity(0.4))` — dark-tinted glass
- **Status badges**: `.tint(statusColor.opacity(0.15))` — barely there color hint
- **Inactive/deselected**: `.clear` — no glass, element disappears into background

## View Patterns

### Label Modifier (ALL-CAPS)

Every section header, filter label, and control label uses this:

```swift
struct AppLabelStyle: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .font(AppTokens.Font.label)
            .tracking(0.88)
            .textCase(.uppercase)
            .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
    }
}

extension View {
    func appLabel() -> some View { modifier(AppLabelStyle()) }
}
```

### Glass Button

```swift
struct GlassButton: View {
    let label: String
    var icon: String? = nil
    var isActive: Bool = false
    var tint: Color = .clear
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.xs) {
                if let icon { Image(systemName: icon).font(.system(size: 11, weight: .medium)) }
                Text(label).font(Font.label).tracking(0.88).textCase(.uppercase)
            }
            .foregroundStyle(isActive ? Color.textDisplay : Color.textSecondary)
            .padding(.horizontal, Spacing.md)
            .padding(.vertical, Spacing.sm - 2)
        }
        .buttonStyle(.glass)
        .tint(isActive ? tint : .clear)
        .help(label)
    }
}
```

### Floating Sidebar Layout with Frosted Glass

```swift
NavigationSplitView {
    // Sidebar content — frosted glass background
    sidebarContent
        .background(.ultraThinMaterial)
        .navigationSplitViewColumnWidth(min: 200, ideal: 300, max: 400)
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
    .animation(Motion.smooth, value: inspectorVisible)
}
```

### Collapsible Inspector / Notes Side Panel

The right-side inspector panel is a simple HStack child with a toolbar toggle:

```swift
struct WorkspaceView: View {
    @State private var notesPanelVisible = true

    var body: some View {
        HStack(spacing: 0) {
            // Main workspace content
            mainContent
                .frame(maxWidth: .infinity)

            // Collapsible side panel
            if notesPanelVisible {
                Divider()
                NotesSidePanel()
                    .frame(width: 300)
                    .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    withAnimation(AppTokens.Motion.smooth) {
                        notesPanelVisible.toggle()
                    }
                } label: {
                    Image(systemName: "sidebar.trailing")
                        .symbolVariant(notesPanelVisible ? .none : .slash)
                }
                .help("Toggle Notes Panel")
            }
        }
        .animation(AppTokens.Motion.smooth, value: notesPanelVisible)
    }
}
```

### Stat Pill (Glass-Backed)

```swift
struct StatPill: View {
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: Spacing.xs) {
            Text(value).font(Font.numericSmall).foregroundStyle(Color.textPrimary)
            Text(label).font(Font.caption).tracking(0.88).textCase(.uppercase)
                .foregroundStyle(Color.textTertiary)
        }
        .padding(.horizontal, Spacing.sm)
        .padding(.vertical, Spacing.xxs + 1)
        .glassEffect(.regular.tint(Color.surface.opacity(0.5)), in: .capsule)
    }
}
```

### Segmented Progress Bar

```swift
struct SegmentedProgressBar: View {
    let progress: Double
    let segments: Int

    var body: some View {
        HStack(spacing: 2) {
            let filled = Int(progress * Double(segments))
            ForEach(0..<segments, id: \.self) { i in
                RoundedRectangle(cornerRadius: 1)
                    .fill(i < filled ? Color.accent : Color.borderStrong)
                    .frame(height: 6)
            }
        }
    }
}
```

### Hover + Selection on Thumbnails

```swift
MockSlideThumbnail(...)
    .overlay(
        RoundedRectangle(cornerRadius: Radius.sm)
            .strokeBorder(isSelected ? Color.accent : Color.border,
                          lineWidth: isSelected ? 2.5 : Border.hairline)
    )
    .shadow(color: isSelected ? Color.accent.opacity(0.25) : .clear, radius: 8)
    .scaleEffect(isHovered && !isSelected ? 1.03 : 1.0)
    .onHover { isHovered = $0 }
    .animation(Motion.snappy, value: isHovered)
```

### Section Card (Notes, Annotations)

```swift
content
    .padding(Spacing.sm)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(
        RoundedRectangle(cornerRadius: Radius.md)
            .fill(Color.surface.opacity(0.5))
    )
    .overlay(
        RoundedRectangle(cornerRadius: Radius.md)
            .strokeBorder(Color.borderStrong.opacity(0.3), lineWidth: Border.hairline)
    )
```

## Annotation & Review System

For apps with annotation/review workflows (document review, design critique, slide markup), use these patterns from the `annotation-patterns.md` reference:

- **Unified annotation types** — enum wrapping draw boxes, pins, text edits with shared properties (id, colorIndex, noteText, createdAt) and unified numbering
- **Draggable pin markers** — `NormalizedPoint` (0-1 range) with local `@State` drag offset for smooth gesture handling
- **Properties popover** — click annotation in list to show popover with note editor, color picker, delete; uses **explicit save buttons** (cancel / add note / save) instead of auto-save to prevent value-type binding bugs
- **Custom color** — 8 preset colors + `ColorPicker` for custom, stored as hex string, resolved via `resolvedColor(for:customHex:)`
- **Recolor after placement** — color picker sets next color AND updates selected item's color
- **Tool mode mutual exclusivity** — boolean flags with one-clears-all activation; tool controls live in the side panel header
- **Verdict/disposition tags** — enum-based status tags (APPROVE/REVISE/CUT/MERGE/SPLIT/REORDER) with typed context as colored glass capsules
- **Visual hint overlay** — when tool mode is active and no items exist, dim content to 50% with centered instruction, `.allowsHitTesting(false)` so taps pass through

## Anti-Patterns — Do NOT

1. **Do not use `.background(.regularMaterial)`** on content areas — glass is only for chrome/navigation
2. **Do not place glass elements outside a `GlassEffectContainer`** when they are near other glass elements
3. **Do not use linear or ease animations** — always spring
4. **Do not use bright/saturated background colors** — the palette is monochrome with color reserved for status
5. **Do not use system semantic colors** (`.primary`, `.secondary`) — always use `AppTokens.Color.*`
6. **Do not use rounded corners > 16pt** — keep shapes geometric, not bubbly
7. **Do not add glass tint opacity > 0.3** — glass should be subtle, not colored
8. **Do not put glass on text content**, diff views, or data visualization
9. **Do not use `HSplitView`** when `NavigationSplitView` is available — prefer the floating sidebar
10. **Do not skip the `.help()` tooltip** on toolbar buttons
11. **Do not use `.windowToolbarStyle(.unified)` without `.toolbarBackgroundVisibility(.hidden)`** — causes grey title bar
12. **Do not override sidebar background with opaque colors** when using `.ultraThinMaterial` — defeats frosted glass

## Color Usage Quick Reference (Dark / Light)

| Context | Dark | Light |
|---------|------|-------|
| App background | `#0A0A0A` | `#FFFFFF` |
| Card/panel surface | `#111111` | `#F5F5F5` |
| Elevated surface | `#1A1A1A` | `#EBEBEB` |
| Default border | `#222222` | `#DDDDDD` |
| Strong border | `#333333` | `#CCCCCC` |
| Primary text | `#E8E8E8` | `#1A1A1A` |
| Headings / selected text | `white` | `black` |
| Secondary text | `#999999` | `#666666` |
| Tertiary / disabled text | `#666666` | `#999999` |
| Accent (selected/active) | `#E5600A` | `#E5600A` |
| Accent dim background | `#3D2510` | `#FFF0E6` |
| Error / destructive | `#CC1018` | `#CC1018` |
| Warning / flagged | `#B8912E` | `#B8912E` |
| Success / added | `#2D8A3E` | `#2D8A3E` |
| Informational | `#2E6FBA` | `#2E6FBA` |
| Diff added background | `#1A2E1A` | `#E6F5E6` |
| Diff removed background | `#2E1A1A` | `#F5E6E6` |
| Diff changed background | `#1A1A2E` | `#E6E6F5` |

## Required NSColor Extension

```swift
extension NSColor {
    convenience init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        guard hex.count == 6 else { return nil }
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(
            srgbRed: CGFloat((int >> 16) & 0xFF) / 255.0,
            green: CGFloat((int >> 8) & 0xFF) / 255.0,
            blue: CGFloat(int & 0xFF) / 255.0,
            alpha: 1.0
        )
    }
}
```
