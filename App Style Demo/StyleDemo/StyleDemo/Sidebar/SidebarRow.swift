import SwiftUI

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
                            : (isHovered
                                ? AppTokens.Color.surface(for: colorScheme).opacity(0.6)
                                : .clear)
                    )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(AppTokens.Motion.snappy) { isHovered = hovering }
        }
        .padding(.horizontal, AppTokens.Spacing.xs)
        .help(item.title)
    }
}
