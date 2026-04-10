import SwiftUI

struct CanvasHeader: View {
    let title: String
    let subtitle: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: AppTokens.Spacing.md) {
            Text(title)
                .font(AppTokens.Font.displayMedium)
                .foregroundStyle(AppTokens.Color.textDisplay(for: colorScheme))
            Text(subtitle)
                .font(AppTokens.Font.label)
                .tracking(0.88)
                .textCase(.uppercase)
                .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
            Spacer()
        }
        .padding(.horizontal, AppTokens.Spacing.xl)
        .padding(.top, AppTokens.Spacing.lg)
        .padding(.bottom, AppTokens.Spacing.md)
    }
}
