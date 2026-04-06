---
name: tyler-app-style
description: Build macOS SwiftUI apps using Tyler App Style — a hybrid design system combining Nothing Design (dark monochrome palette, orange accent, all-caps tracking labels, monospace data fonts, 8pt spacing grid) with Apple Liquid Glass (glassEffect, GlassEffectContainer, NavigationSplitView floating sidebars, spring animations, buttonStyle(.glass), system materials). Use when creating new SwiftUI apps with a dark professional aesthetic, applying glass effects to dark-themed UIs, building macOS 26+ Tahoe apps with translucent chrome, or when the user asks for "Tyler style", "Tyler App Style", "Nothing + Apple", or "dark glass" design patterns.
---

# Tyler App Style

A hybrid SwiftUI design system for macOS 26+ that combines **Nothing Design's** dark, typographic discipline with **Apple's Liquid Glass** translucency and native navigation patterns.

## Core Principles

1. **Dark-first**: `#0A0A0A` background, monochrome surfaces (`#111111`, `#1A1A1A`), white text hierarchy
2. **Glass on chrome, never on content**: Liquid Glass (`glassEffect`) is applied to toolbars, sidebars, buttons, badges, filters — never to data content like slide images, text diffs, or charts
3. **Orange accent sparingly**: `#F47421` for selected states, active filters, annotation highlights, and interactive glass tint only
4. **Typography as hierarchy**: All-caps labels with 0.88pt tracking for section headers and controls. Monospace for data/numbers. Sans-serif for headings.
5. **8pt spacing grid**: All spacing derives from multiples of 8 (2, 4, 8, 16, 24, 32, 48, 64)
6. **Spring animations**: All transitions use `spring(duration:bounce:)` — no linear or easeIn/Out
7. **Floating navigation**: `NavigationSplitView` for sidebars, native toolbar for chrome, `TabView` for modes

## When to Use This Skill

- Building a new macOS SwiftUI app targeting macOS 26+
- Adding Liquid Glass to an existing dark-themed app
- Creating professional/productivity tools (document comparison, review, analysis)
- User asks for "Tyler App Style", "dark glass", or "Nothing + Apple" design
- Migrating a Nothing Design app to use Apple's native glass effects

## Design Tokens

### Colors

All views MUST reference these tokens — no hardcoded colors.

```swift
enum NothingTokens {
    enum Color {
        // Core palette
        static let background = Color(nsColor: NSColor(hex: "0A0A0A")!)       // App background
        static let surface = Color(nsColor: NSColor(hex: "111111")!)           // Cards, panels
        static let surfaceElevated = Color(nsColor: NSColor(hex: "1A1A1A")!)   // Elevated content
        static let border = Color(nsColor: NSColor(hex: "222222")!)            // Subtle borders
        static let borderStrong = Color(nsColor: NSColor(hex: "333333")!)      // Emphasized borders

        // Text hierarchy
        static let textPrimary = Color(nsColor: NSColor(hex: "E8E8E8")!)       // Body text
        static let textDisplay = Color.white                                    // Headings, selected
        static let textSecondary = Color(nsColor: NSColor(hex: "999999")!)      // Supporting text
        static let textTertiary = Color(nsColor: NSColor(hex: "666666")!)       // Disabled, hints

        // Accent — used sparingly for selected/focused/interactive states
        static let accent = Color(nsColor: NSColor(hex: "F47421")!)            // Primary orange
        static let accentDim = Color(nsColor: NSColor(hex: "3D2510")!)         // Tinted backgrounds

        // Status — the only non-monochrome colors allowed in content
        static let destructive = Color(nsColor: NSColor(hex: "D71921")!)       // Errors, removals
        static let warning = Color(nsColor: NSColor(hex: "D4A843")!)           // Caution, flags
        static let success = Color(nsColor: NSColor(hex: "4A9E5C")!)           // Added, confirmed
        static let redesigned = Color(nsColor: NSColor(hex: "4A8ED4")!)        // Informational blue

        // Diff backgrounds (very dark tints — subtle, never bright)
        static let diffAddedBg = Color(nsColor: NSColor(hex: "1A2E1A")!)
        static let diffRemovedBg = Color(nsColor: NSColor(hex: "2E1A1A")!)
        static let diffChangedBg = Color(nsColor: NSColor(hex: "1A1A2E")!)
    }
}
```

### Typography

Use **Geist** (sans-serif) for headings/labels and **GeistMono** (monospace) for data/numbers/body. Fall back to system fonts if Geist is not bundled.

```swift
enum Font {
    // Display — bold sans-serif for titles
    static let displayLarge: Font = .system(size: 42, weight: .bold)
    static let displayMedium: Font = .system(size: 28, weight: .bold)
    static let displaySmall: Font = .system(size: 20, weight: .semibold)

    // Headings
    static let headingLarge: Font = .system(size: 17, weight: .medium)
    static let headingSmall: Font = .system(size: 13, weight: .medium)

    // Body — monospace for data
    static let bodyLarge: Font = .system(size: 15, weight: .regular, design: .monospaced)
    static let bodySmall: Font = .system(size: 12, weight: .regular, design: .monospaced)

    // Caption & Label
    static let caption: Font = .system(size: 10, weight: .regular, design: .monospaced)
    static let label: Font = .system(size: 11, weight: .medium)  // ALL-CAPS + 0.88 tracking

    // Numeric — bold monospace for stats
    static let numeric: Font = .system(size: 24, weight: .bold, design: .monospaced)
    static let numericSmall: Font = .system(size: 14, weight: .bold, design: .monospaced)
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
struct NothingLabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(NothingTokens.Font.label)
            .tracking(0.88)
            .textCase(.uppercase)
            .foregroundStyle(NothingTokens.Color.textSecondary)
    }
}

extension View {
    func nothingLabel() -> some View { modifier(NothingLabelStyle()) }
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

### Floating Sidebar Layout

```swift
NavigationSplitView {
    // Sidebar content — gets system floating glass treatment
    sidebarContent
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
    .animation(Motion.smooth, value: inspectorVisible)
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
struct NothingProgressBar: View {
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

## Anti-Patterns — Do NOT

1. **Do not use `.background(.regularMaterial)`** on content areas — glass is only for chrome/navigation
2. **Do not place glass elements outside a `GlassEffectContainer`** when they are near other glass elements
3. **Do not use linear or ease animations** — always spring
4. **Do not use bright/saturated background colors** — the palette is monochrome with color reserved for status
5. **Do not use system semantic colors** (`.primary`, `.secondary`) — always use `NothingTokens.Color.*`
6. **Do not use rounded corners > 16pt** — keep shapes geometric, not bubbly
7. **Do not add glass tint opacity > 0.3** — glass should be subtle, not colored
8. **Do not put glass on text content**, diff views, or data visualization
9. **Do not use `HSplitView`** when `NavigationSplitView` is available — prefer the floating sidebar
10. **Do not skip the `.help()` tooltip** on toolbar buttons

## Color Usage Quick Reference

| Context | Color |
|---------|-------|
| App background | `#0A0A0A` |
| Card/panel surface | `#111111` |
| Elevated surface | `#1A1A1A` |
| Default border | `#222222` |
| Strong border | `#333333` |
| Primary text | `#E8E8E8` |
| Headings / selected text | `white` |
| Secondary text | `#999999` |
| Tertiary / disabled text | `#666666` |
| Accent (selected/active) | `#F47421` (orange) |
| Accent dim background | `#3D2510` |
| Error / removed / destructive | `#D71921` (red) |
| Warning / flagged | `#D4A843` (gold) |
| Success / added | `#4A9E5C` (green) |
| Informational / redesigned | `#4A8ED4` (blue) |
| Diff added background | `#1A2E1A` |
| Diff removed background | `#2E1A1A` |
| Diff changed background | `#1A1A2E` |

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
