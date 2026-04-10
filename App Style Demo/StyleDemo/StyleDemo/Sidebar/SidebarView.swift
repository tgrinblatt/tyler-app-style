import SwiftUI

struct SidebarView: View {
    @Binding var selected: Showcase
    @Binding var searchText: String
    let onOpenSettings: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    private var filtered: [Showcase] {
        guard !searchText.isEmpty else { return Showcase.allCases }
        return Showcase.allCases.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
        }
    }

    private var sections: [(String, [Showcase])] {
        let grouped = Dictionary(grouping: filtered, by: { $0.section })
        let order = ["START", "COMPONENTS", "STYLES", "LAYOUT", "TOOLS"]
        return order.compactMap { key in
            guard let items = grouped[key], !items.isEmpty else { return nil }
            return (key, items)
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            SidebarSearch(text: $searchText)
                .padding(.horizontal, AppTokens.Spacing.md)
                .padding(.top, AppTokens.Spacing.sm)
                .padding(.bottom, AppTokens.Spacing.sm)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
                    ForEach(sections, id: \.0) { section, items in
                        VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
                            Text(section)
                                .appLabel()
                                .padding(.horizontal, AppTokens.Spacing.md)
                            ForEach(items) { item in
                                SidebarRow(
                                    item: item,
                                    isSelected: selected == item
                                ) {
                                    withAnimation(AppTokens.Motion.snappy) {
                                        selected = item
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, AppTokens.Spacing.sm)
            }

            Spacer(minLength: 0)

            // Footer action bar — settings + future tool buttons live here,
            // not in the window titlebar.
            SidebarFooter(onOpenSettings: onOpenSettings)
        }
        .background(.ultraThinMaterial)
    }
}

private struct SidebarFooter: View {
    let onOpenSettings: () -> Void
    @Environment(\.colorScheme) private var colorScheme
    @State private var isHovered: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            Divider().opacity(0.3)
            HStack(spacing: AppTokens.Spacing.xs) {
                Button(action: onOpenSettings) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(
                            isHovered
                                ? AppTokens.Color.textDisplay(for: colorScheme)
                                : AppTokens.Color.textSecondary(for: colorScheme)
                        )
                        .frame(width: 32, height: 32)
                        .background(
                            RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                                .fill(
                                    isHovered
                                        ? AppTokens.Color.surface(for: colorScheme).opacity(0.6)
                                        : .clear
                                )
                        )
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .scaleEffect(isHovered ? 1.03 : 1.0)
                .onHover { hovering in
                    withAnimation(AppTokens.Motion.snappy) { isHovered = hovering }
                }
                .help("Demo Settings")

                Spacer()
            }
            .padding(.horizontal, AppTokens.Spacing.sm)
            .padding(.vertical, AppTokens.Spacing.sm)
        }
    }
}
