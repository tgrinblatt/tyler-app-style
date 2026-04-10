import SwiftUI

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
