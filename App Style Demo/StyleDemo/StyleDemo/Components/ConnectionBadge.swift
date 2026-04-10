import SwiftUI

struct ConnectionBadge: View {
    let label: String
    let color: Color

    var body: some View {
        Text(label)
            .font(AppTokens.Font.caption)
            .tracking(0.88)
            .textCase(.uppercase)
            .foregroundStyle(color)
            .padding(.horizontal, AppTokens.Spacing.sm)
            .padding(.vertical, AppTokens.Spacing.xxs + 1)
            .glassEffect(.regular.tint(color.opacity(0.15)), in: .capsule)
    }
}
