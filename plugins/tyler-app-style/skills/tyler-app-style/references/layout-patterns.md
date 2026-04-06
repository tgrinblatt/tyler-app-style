# Layout Patterns for Tyler App Style

## App Structure

Tyler App Style apps use a three-panel layout with floating sidebar:

```
+--------------------------------------------------+
|  [Toolbar: file info | stats | tier | actions]   |  <- System toolbar with glass buttons
+--------+----------------------------+------------+
|        |                            |            |
| Slide  |   Main Content Area       |   Notes /  |
| Map /  |   (Visual Compare,        |  Inspector |
| Review |    Text Compare,          |   Panel    |
| List   |    Slide Detail)          |            |
|        |                            |            |
| (float)|                            | (toggle)   |
+--------+----------------------------+------------+
|  [ Drop Zone | Comparison | Review ]             |  <- Glass tab bar
+--------------------------------------------------+
```

## NavigationSplitView (Floating Sidebar)

```swift
NavigationSplitView {
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
    .animation(NothingTokens.Motion.smooth, value: inspectorVisible)
}
.background(NothingTokens.Color.background)
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
.preferredColorScheme(.dark)
```

## Toolbar Pattern

```swift
@ToolbarContentBuilder
var toolbarItems: some ToolbarContent {
    ToolbarItem(placement: .automatic) {
        HStack(spacing: NothingTokens.Spacing.sm) {
            Image(systemName: "doc.text")
                .font(.system(size: 11))
                .foregroundStyle(NothingTokens.Color.textTertiary)
            Text("filename.pptx")
                .font(NothingTokens.Font.bodySmall)
                .foregroundStyle(NothingTokens.Color.textSecondary)
        }
    }

    ToolbarItem(placement: .automatic) {
        HStack(spacing: NothingTokens.Spacing.sm) {
            StatPill(value: "10", label: "SLIDES")
            StatPill(value: "3", label: "FLAGGED")
        }
    }

    ToolbarItem(placement: .automatic) {
        GlassButton(label: "Export", icon: "square.and.arrow.up") { ... }
    }

    ToolbarItem(placement: .automatic) {
        Button {
            withAnimation(NothingTokens.Motion.smooth) { inspectorVisible.toggle() }
        } label: {
            Image(systemName: "sidebar.trailing")
                .symbolVariant(inspectorVisible ? .none : .slash)
        }
        .help("Toggle Inspector")
    }
}
```

## Section Card Pattern (for notes/annotations)

```swift
struct GlassSectionCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        content
            .padding(NothingTokens.Spacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: NothingTokens.Radius.md)
                    .fill(NothingTokens.Color.surface.opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: NothingTokens.Radius.md)
                    .strokeBorder(
                        NothingTokens.Color.borderStrong.opacity(0.3),
                        lineWidth: NothingTokens.Border.hairline
                    )
            )
    }
}
```

## Sidebar Summary Stats

```swift
GlassEffectContainer {
    HStack(spacing: NothingTokens.Spacing.md) {
        StatBadge(value: "9", label: "PAIRS")
        StatBadge(value: "3", label: "REVIEWED")
        StatBadge(value: "2", label: "FLAGGED", valueColor: NothingTokens.Color.warning)
    }
    .padding(.vertical, NothingTokens.Spacing.sm)
    .padding(.horizontal, NothingTokens.Spacing.md)
}
```

## Hover + Selection on Interactive Elements

```swift
.overlay(
    RoundedRectangle(cornerRadius: NothingTokens.Radius.sm)
        .strokeBorder(
            isSelected ? NothingTokens.Color.accent : NothingTokens.Color.border,
            lineWidth: isSelected ? 2.5 : NothingTokens.Border.hairline
        )
)
.shadow(color: isSelected ? NothingTokens.Color.accent.opacity(0.25) : .clear, radius: 8)
.scaleEffect(isHovered && !isSelected ? 1.03 : 1.0)
.onHover { isHovered = $0 }
.animation(NothingTokens.Motion.snappy, value: isHovered)
```

## Inspector Panel Toggle

The notes/inspector panel slides in from the trailing edge:

```swift
if inspectorVisible {
    Divider()
    inspectorContent
        .frame(width: 300)
        .transition(.move(edge: .trailing).combined(with: .opacity))
}
```

Always animate with `Motion.smooth` and provide a toolbar toggle button.
