import SwiftUI

struct GlassPillTitle: View {
    let title: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Text(title)
            .font(AppTokens.Font.headingSmall)
            .foregroundStyle(AppTokens.Color.textDisplay(for: colorScheme))
            .padding(.horizontal, AppTokens.Spacing.md)
            .padding(.vertical, AppTokens.Spacing.xs)
            .glassEffect(
                .regular.tint(AppTokens.Color.surface(for: colorScheme).opacity(0.3)),
                in: .capsule
            )
    }
}
