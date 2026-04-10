# Liquid Glass Patterns for Tyler App Style

## Glass Button

The primary interactive button. Uses `.buttonStyle(.glass)` with optional accent tint when active.

```swift
struct GlassButton: View {
    let label: String
    var icon: String? = nil
    var isActive: Bool = false
    var tint: Color = .clear
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTokens.Spacing.xs) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 11, weight: .medium))
                }
                Text(label)
                    .font(AppTokens.Font.label)
                    .tracking(0.88)
                    .textCase(.uppercase)
            }
            .foregroundStyle(isActive ? AppTokens.Color.textDisplay(for: colorScheme) : AppTokens.Color.textSecondary(for: colorScheme))
            .padding(.horizontal, AppTokens.Spacing.md)
            .padding(.vertical, AppTokens.Spacing.sm - 2)
        }
        .buttonStyle(.glass)
        .tint(isActive ? tint : .clear)
        .help(label)
    }

    @Environment(\.colorScheme) private var colorScheme
}
```

## Glass Stat Pill

Used in toolbars to display key metrics with glass backing.

```swift
struct StatPill: View {
    let value: String
    let label: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: AppTokens.Spacing.xs) {
            Text(value)
                .font(AppTokens.Font.numericSmall)
                .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
            Text(label)
                .font(AppTokens.Font.caption)
                .tracking(0.88)
                .textCase(.uppercase)
                .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
        }
        .padding(.horizontal, AppTokens.Spacing.sm)
        .padding(.vertical, AppTokens.Spacing.xxs + 1)
        .glassEffect(.regular.tint(AppTokens.Color.surface(for: colorScheme).opacity(0.5)), in: .capsule)
    }
}
```

## Glass Connection Badge

Status badges with colored glass tint.

```swift
struct ConnectionBadge: View {
    let label: String
    let color: Color

    var body: some View {
        Text(label)
            .font(AppTokens.Font.caption)
            .tracking(0.88)
            .textCase(.uppercase)
            .foregroundStyle(color)
            .padding(.horizontal, AppTokens.Spacing.sm)
            .padding(.vertical, AppTokens.Spacing.xxs + 1)
            .glassEffect(.regular.tint(color.opacity(0.15)), in: .capsule)
    }
}
```

## Glass Filter Bar

Segmented filter with interactive glass pills inside a `GlassEffectContainer`.

```swift
GlassEffectContainer {
    HStack(spacing: AppTokens.Spacing.xxs) {
        ForEach(FilterMode.allCases, id: \.self) { mode in
            Button {
                withAnimation(AppTokens.Motion.snappy) { filterMode = mode }
            } label: {
                Text(mode.rawValue)
                    .font(AppTokens.Font.caption)
                    .tracking(0.88)
                    .textCase(.uppercase)
                    .foregroundStyle(
                        filterMode == mode
                            ? AppTokens.Color.textDisplay(for: colorScheme)
                            : AppTokens.Color.textTertiary(for: colorScheme)
                    )
                    .padding(.horizontal, AppTokens.Spacing.sm)
                    .padding(.vertical, AppTokens.Spacing.xs)
            }
            .buttonStyle(.plain)
            .glassEffect(
                filterMode == mode
                    ? .regular.tint(AppTokens.Color.accent.opacity(0.2)).interactive()
                    : .clear,
                in: .capsule
            )
        }
        Spacer()
    }
}
```

## Glass Drop Zone

Large interactive areas with subtle glass backing.

```swift
content
    .frame(maxWidth: .infinity, minHeight: 200)
    .padding(AppTokens.Spacing.lg)
    .background(
        RoundedRectangle(cornerRadius: AppTokens.Radius.xl)
            .fill(AppTokens.Color.surface(for: colorScheme).opacity(0.6))
    )
    .glassEffect(
        .regular.tint(isLoaded ? AppTokens.Color.accent.opacity(0.05) : .clear),
        in: .rect(cornerRadius: AppTokens.Radius.xl)
    )
```

## Glass Slider Handle

Interactive glass circle for before/after sliders.

```swift
Circle()
    .fill(.ultraThinMaterial)
    .frame(width: 32, height: 32)
    .overlay(
        Image(systemName: "arrow.left.and.right")
            .font(.system(size: 11, weight: .bold))
            .foregroundStyle(AppTokens.Color.textDisplay(for: colorScheme))
    )
    .glassEffect(.regular.interactive(), in: .circle)
```

## Glass Pill Title

A title label displayed as a floating glass pill, useful for overlay titles on content areas.

```swift
Text("Section Title")
    .font(AppTokens.Font.headingSmall)
    .foregroundStyle(AppTokens.Color.textDisplay(for: colorScheme))
    .padding(.horizontal, AppTokens.Spacing.md)
    .padding(.vertical, AppTokens.Spacing.xs)
    .glassEffect(.regular.tint(AppTokens.Color.surface(for: colorScheme).opacity(0.3)), in: .capsule)
```

## Frosted Glass Sidebar

Use `.ultraThinMaterial` on the sidebar background for a frosted glass effect. This is the preferred approach for sidebar backgrounds — it allows the app content to subtly show through.

```swift
NavigationSplitView {
    VStack(spacing: 0) {
        // Summary stats, filter bar, slide list, etc.
        sidebarContent
    }
    .background(.ultraThinMaterial)  // Frosted glass
    .navigationSplitViewColumnWidth(min: 280, ideal: 340, max: 500)
} detail: {
    detailContent
}
```

**Critical**: Child views inside the sidebar must NOT set opaque `.background()` — this defeats the frosted effect. Use `.clear` or omit the background modifier entirely on sidebar child views.

## Scroll Edge Fade (Gradient Overlay)

Add a subtle fade at scroll edges to indicate more content is available:

```swift
ScrollView {
    content
}
.overlay(alignment: .top) {
    LinearGradient(
        colors: [AppTokens.Color.background(for: colorScheme), .clear],
        startPoint: .top,
        endPoint: .bottom
    )
    .frame(height: 16)
    .allowsHitTesting(false)
}
.overlay(alignment: .bottom) {
    LinearGradient(
        colors: [.clear, AppTokens.Color.background(for: colorScheme)],
        startPoint: .top,
        endPoint: .bottom
    )
    .frame(height: 16)
    .allowsHitTesting(false)
}
```

## Visual Hint Overlay (Tool Mode Activation)

When a tool mode is active (e.g., pin placement, draw box, text edit), show a dimmed overlay with a centered instruction message. Use `.allowsHitTesting(false)` so taps pass through to the content underneath. Show the hint only when no items of that type exist yet — once the user places their first annotation, the hint disappears (progressive disclosure).

```swift
// Overlay on the main content area, inside the ZStack
if isPinMode && pinAnnotations.isEmpty {
    VStack(spacing: AppTokens.Spacing.sm) {
        Image(systemName: "mappin.and.ellipse")
            .font(.system(size: 32))
            .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
        Text("Click to place a pin")
            .font(AppTokens.Font.headingSmall)
            .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppTokens.Color.background(for: colorScheme).opacity(0.5))
    .allowsHitTesting(false)  // Critical — taps pass through to content
}
```

This pattern works for any tool mode — swap the icon, message, and empty-check condition.

## Toolbar Auto-Glass (and how to opt out)

On macOS 26, **every `ToolbarItem` is automatically wrapped in its own glass
pill**. This is the right default for interactive icons and semantic-state
items (the current page name, toggle buttons, filter chips), but it's wrong
for plain-text labels like the app name.

There is no per-item background modifier that disables this. The only
reliable escape hatch is wrapping the item in a `ToolbarItemGroup` and
setting `.sharedBackgroundVisibility(.hidden)`:

```swift
// WRONG — lone ToolbarItem with plain Text: still gets pilled
ToolbarItem(placement: .navigation) {
    Text("StyleDemo")
        .font(AppTokens.Font.displaySmall)
}

// CORRECT — ToolbarItemGroup with shared background hidden
ToolbarItemGroup(placement: .navigation) {
    Text("StyleDemo")
        .font(AppTokens.Font.displaySmall)
        .padding(.leading, AppTokens.Spacing.md)  // aligns with canvas content
}
.sharedBackgroundVisibility(.hidden)
```

Use this only for the **app name** on the leading edge. Every other toolbar
item should keep its glass pill. See `layout-patterns.md → Window Toolbar
Pattern` for the full three-slot layout (app name left, page name center,
system icons right).

## Important: GlassEffectContainer Grouping

Always wrap adjacent glass elements in a container to prevent sampling artifacts:

```swift
// WRONG — glass elements sample each other
HStack {
    button1.glassEffect(.regular, in: .capsule)
    button2.glassEffect(.regular, in: .capsule)
}

// CORRECT — container handles glass compositing
GlassEffectContainer {
    HStack {
        button1.glassEffect(.regular, in: .capsule)
        button2.glassEffect(.regular, in: .capsule)
    }
}
```
