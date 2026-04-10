import SwiftUI

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
        .glassEffect(
            .regular.tint(AppTokens.Color.surface(for: colorScheme).opacity(0.5)),
            in: .capsule
        )
    }
}
