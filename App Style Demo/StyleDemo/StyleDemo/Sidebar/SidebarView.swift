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
        }
        .background(.ultraThinMaterial)
    }
}
