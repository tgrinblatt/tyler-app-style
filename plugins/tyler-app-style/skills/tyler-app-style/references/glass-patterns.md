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
            HStack(spacing: NothingTokens.Spacing.xs) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 11, weight: .medium))
                }
                Text(label)
                    .font(NothingTokens.Font.label)
                    .tracking(0.88)
                    .textCase(.uppercase)
            }
            .foregroundStyle(isActive ? NothingTokens.Color.textDisplay : NothingTokens.Color.textSecondary)
            .padding(.horizontal, NothingTokens.Spacing.md)
            .padding(.vertical, NothingTokens.Spacing.sm - 2)
        }
        .buttonStyle(.glass)
        .tint(isActive ? tint : .clear)
        .help(label)
    }
}
```

## Glass Stat Pill

Used in toolbars to display key metrics with glass backing.

```swift
struct StatPill: View {
    let value: String
    let label: String

    var body: some View {
        HStack(spacing: NothingTokens.Spacing.xs) {
            Text(value)
                .font(NothingTokens.Font.numericSmall)
                .foregroundStyle(NothingTokens.Color.textPrimary)
            Text(label)
                .font(NothingTokens.Font.caption)
                .tracking(0.88)
                .textCase(.uppercase)
                .foregroundStyle(NothingTokens.Color.textTertiary)
        }
        .padding(.horizontal, NothingTokens.Spacing.sm)
        .padding(.vertical, NothingTokens.Spacing.xxs + 1)
        .glassEffect(.regular.tint(NothingTokens.Color.surface.opacity(0.5)), in: .capsule)
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
            .font(NothingTokens.Font.caption)
            .tracking(0.88)
            .textCase(.uppercase)
            .foregroundStyle(color)
            .padding(.horizontal, NothingTokens.Spacing.sm)
            .padding(.vertical, NothingTokens.Spacing.xxs + 1)
            .glassEffect(.regular.tint(color.opacity(0.15)), in: .capsule)
    }
}
```

## Glass Filter Bar

Segmented filter with interactive glass pills inside a `GlassEffectContainer`.

```swift
GlassEffectContainer {
    HStack(spacing: NothingTokens.Spacing.xxs) {
        ForEach(FilterMode.allCases, id: \.self) { mode in
            Button {
                withAnimation(NothingTokens.Motion.snappy) { filterMode = mode }
            } label: {
                Text(mode.rawValue)
                    .font(NothingTokens.Font.caption)
                    .tracking(0.88)
                    .textCase(.uppercase)
                    .foregroundStyle(
                        filterMode == mode
                            ? NothingTokens.Color.textDisplay
                            : NothingTokens.Color.textTertiary
                    )
                    .padding(.horizontal, NothingTokens.Spacing.sm)
                    .padding(.vertical, NothingTokens.Spacing.xs)
            }
            .buttonStyle(.plain)
            .glassEffect(
                filterMode == mode
                    ? .regular.tint(NothingTokens.Color.accent.opacity(0.2)).interactive()
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
    .padding(NothingTokens.Spacing.lg)
    .background(
        RoundedRectangle(cornerRadius: NothingTokens.Radius.xl)
            .fill(NothingTokens.Color.surface.opacity(0.6))
    )
    .glassEffect(
        .regular.tint(isLoaded ? NothingTokens.Color.accent.opacity(0.05) : .clear),
        in: .rect(cornerRadius: NothingTokens.Radius.xl)
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
            .foregroundStyle(NothingTokens.Color.textDisplay)
    )
    .glassEffect(.regular.interactive(), in: .circle)
```

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
