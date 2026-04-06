# Example: Document Comparison App Layout

A complete example showing how to structure a Tyler App Style document comparison app.

## App Entry Point

```swift
@main
struct MyComparisonApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 1200, minHeight: 700)
        }
        .defaultSize(width: 1440, height: 900)
    }
}
```

## Content View with Tab Modes

```swift
struct ContentView: View {
    @State private var currentMode: AppMode = .comparison

    enum AppMode: String, CaseIterable, Identifiable {
        case dropZone = "Import"
        case comparison = "Compare"
        case review = "Review"

        var id: String { rawValue }
        var icon: String {
            switch self {
            case .dropZone: "square.and.arrow.down"
            case .comparison: "arrow.left.arrow.right"
            case .review: "doc.text.magnifyingglass"
            }
        }
    }

    var body: some View {
        GlassEffectContainer {
            TabView(selection: $currentMode) {
                Tab(AppMode.dropZone.rawValue, systemImage: AppMode.dropZone.icon, value: .dropZone) {
                    DropZoneView()
                }
                Tab(AppMode.comparison.rawValue, systemImage: AppMode.comparison.icon, value: .comparison) {
                    ComparisonView()
                }
                Tab(AppMode.review.rawValue, systemImage: AppMode.review.icon, value: .review) {
                    ReviewView()
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
```

## Comparison View (Three-Panel)

```swift
struct ComparisonView: View {
    @State private var selectedIndex: Int? = 0
    @State private var notesVisible = true

    var body: some View {
        NavigationSplitView {
            // Floating glass sidebar
            VStack(spacing: 0) {
                // Summary stats
                GlassEffectContainer {
                    HStack(spacing: NothingTokens.Spacing.md) {
                        StatBadge(value: "10", label: "OLD")
                        StatBadge(value: "12", label: "NEW")
                        StatBadge(value: "8", label: "PAIRS")
                    }
                    .padding(NothingTokens.Spacing.sm)
                }

                // Filter bar
                GlassEffectContainer {
                    HStack(spacing: NothingTokens.Spacing.xxs) {
                        filterPill("ALL", isActive: true)
                        filterPill("UNREVIEWED", isActive: false)
                        filterPill("FLAGGED", isActive: false)
                        Spacer()
                    }
                    .padding(.horizontal, NothingTokens.Spacing.sm)
                    .padding(.vertical, NothingTokens.Spacing.sm)
                }

                // Slide list with connector canvas
                ScrollView {
                    slideMapContent
                }
            }
            .background(NothingTokens.Color.background.opacity(0.5))
            .navigationSplitViewColumnWidth(min: 300, ideal: 380, max: 500)
        } detail: {
            HStack(spacing: 0) {
                // Center: compare detail
                VStack(spacing: 0) {
                    slideHeader
                    compareTabBar
                    compareContent
                }
                .frame(maxWidth: .infinity)

                // Right: toggleable notes panel
                if notesVisible {
                    Divider()
                    NotesPanel()
                        .frame(width: 300)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    fileInfoLabel
                }
                ToolbarItem(placement: .automatic) {
                    GlassButton(label: "Export", icon: "square.and.arrow.up") { }
                }
                ToolbarItem(placement: .automatic) {
                    Button {
                        withAnimation(NothingTokens.Motion.smooth) {
                            notesVisible.toggle()
                        }
                    } label: {
                        Image(systemName: "sidebar.trailing")
                            .symbolVariant(notesVisible ? .none : .slash)
                    }
                    .help("Toggle Notes")
                }
            }
            .animation(NothingTokens.Motion.smooth, value: notesVisible)
        }
        .background(NothingTokens.Color.background)
    }

    private func filterPill(_ label: String, isActive: Bool) -> some View {
        Button { } label: {
            Text(label)
                .font(NothingTokens.Font.caption)
                .tracking(0.88)
                .textCase(.uppercase)
                .foregroundStyle(isActive ? NothingTokens.Color.textDisplay : NothingTokens.Color.textTertiary)
                .padding(.horizontal, NothingTokens.Spacing.sm)
                .padding(.vertical, NothingTokens.Spacing.xs)
        }
        .buttonStyle(.plain)
        .glassEffect(
            isActive ? .regular.tint(NothingTokens.Color.accent.opacity(0.2)).interactive() : .clear,
            in: .capsule
        )
    }
}
```

## Notes Panel

```swift
struct NotesPanel: View {
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("NOTES").nothingLabel()
                Spacer()
                Text("SLIDE 3").font(NothingTokens.Font.caption)
                    .foregroundStyle(NothingTokens.Color.textTertiary)
            }
            .padding(.horizontal, NothingTokens.Spacing.md)
            .frame(height: 44)
            .background(NothingTokens.Color.surface.opacity(0.5))

            ScrollView {
                VStack(alignment: .leading, spacing: NothingTokens.Spacing.md) {
                    // Review controls
                    VStack(alignment: .leading, spacing: NothingTokens.Spacing.sm) {
                        SectionHeader(title: "REVIEW")
                        HStack(spacing: NothingTokens.Spacing.md) {
                            reviewCheckbox
                            flagButton
                        }
                    }

                    Divider()
                        .background(NothingTokens.Color.borderStrong.opacity(0.3))

                    // Speaker notes in a section card
                    VStack(alignment: .leading, spacing: NothingTokens.Spacing.sm) {
                        SectionHeader(title: "SPEAKER NOTES")
                        GlassSectionCard {
                            Text("Notes content here...")
                                .font(NothingTokens.Font.bodySmall)
                                .foregroundStyle(NothingTokens.Color.textSecondary)
                        }
                    }
                }
                .padding(NothingTokens.Spacing.md)
            }
        }
        .background(NothingTokens.Color.background)
    }
}
```

## Key Takeaways

1. **`GlassEffectContainer`** wraps the entire `TabView` and individual filter/stat groups
2. **`NavigationSplitView`** provides the floating glass sidebar
3. **Inspector panel** (notes) is a simple `if visible` with trailing transition
4. **Toolbar** uses `@ToolbarContentBuilder` with `GlassButton` and `StatPill`
5. **All animations** use `NothingTokens.Motion.*` springs
6. **All colors** come from `NothingTokens.Color.*`
7. **All labels** use `.nothingLabel()` modifier
