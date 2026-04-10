import SwiftUI

struct GlassButton: View {
    let label: String
    var icon: String? = nil
    var isActive: Bool = false
    var tint: Color = .clear
    let action: () -> Void

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTokens.Spacing.xs) {
                if let icon {
                    Image(systemName: icon)
                        .font(.system(size: 11, weight: .medium))
                }
                Text(label)
                    .font(AppTokens.Font.label)
                    .tracking(0.88)
                    .textCase(.uppercase)
            }
            .foregroundStyle(
                isActive
                    ? AppTokens.Color.textDisplay(for: colorScheme)
                    : AppTokens.Color.textSecondary(for: colorScheme)
            )
            .padding(.horizontal, AppTokens.Spacing.md)
            .padding(.vertical, AppTokens.Spacing.sm - 2)
        }
        .buttonStyle(.glass)
        .tint(isActive ? tint : .clear)
        .help(label)
    }
}
