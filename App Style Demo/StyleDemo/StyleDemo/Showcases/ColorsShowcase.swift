import SwiftUI

struct ColorsShowcase: View {
    @Environment(\.colorScheme) private var colorScheme

    private var groups: [(String, [(String, String, Color)])] {
        [
            ("SURFACES", [
                ("background", colorScheme == .dark ? "#0A0A0A" : "#FFFFFF", AppTokens.Color.background(for: colorScheme)),
                ("surface", colorScheme == .dark ? "#111111" : "#F5F5F5", AppTokens.Color.surface(for: colorScheme)),
                ("surfaceElevated", colorScheme == .dark ? "#1A1A1A" : "#EBEBEB", AppTokens.Color.surfaceElevated(for: colorScheme)),
                ("border", colorScheme == .dark ? "#222222" : "#DDDDDD", AppTokens.Color.border(for: colorScheme)),
                ("borderStrong", colorScheme == .dark ? "#333333" : "#CCCCCC", AppTokens.Color.borderStrong(for: colorScheme))
            ]),
            ("TEXT", [
                ("textPrimary", colorScheme == .dark ? "#E8E8E8" : "#1A1A1A", AppTokens.Color.textPrimary(for: colorScheme)),
                ("textDisplay", colorScheme == .dark ? "#FFFFFF" : "#000000", AppTokens.Color.textDisplay(for: colorScheme)),
                ("textSecondary", colorScheme == .dark ? "#999999" : "#666666", AppTokens.Color.textSecondary(for: colorScheme)),
                ("textTertiary", colorScheme == .dark ? "#666666" : "#999999", AppTokens.Color.textTertiary(for: colorScheme))
            ]),
            ("ACCENT", [
                ("accent", "#E5600A", AppTokens.Color.accent),
                ("accentDim", colorScheme == .dark ? "#3D2510" : "#FFF0E6", AppTokens.Color.accentDim(for: colorScheme))
            ]),
            ("STATUS", [
                ("destructive", "#CC1018", AppTokens.Color.destructive),
                ("warning", "#B8912E", AppTokens.Color.warning),
                ("success", "#2D8A3E", AppTokens.Color.success),
                ("info", "#2E6FBA", AppTokens.Color.info)
            ]),
            ("DIFF", [
                ("diffAddedBg", colorScheme == .dark ? "#1A2E1A" : "#E6F5E6", AppTokens.Color.diffAddedBg(for: colorScheme)),
                ("diffRemovedBg", colorScheme == .dark ? "#2E1A1A" : "#F5E6E6", AppTokens.Color.diffRemovedBg(for: colorScheme)),
                ("diffChangedBg", colorScheme == .dark ? "#1A1A2E" : "#E6E6F5", AppTokens.Color.diffChangedBg(for: colorScheme))
            ])
        ]
    }

    private let columns = [
        GridItem(.adaptive(minimum: 120), spacing: AppTokens.Spacing.md)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xl) {
            Text("Toggle System Settings → Appearance to see dark/light mode.")
                .font(AppTokens.Font.bodySmall)
                .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))

            ForEach(groups, id: \.0) { name, swatches in
                VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                    Text(name).appLabel()
                    LazyVGrid(columns: columns, spacing: AppTokens.Spacing.md) {
                        ForEach(swatches, id: \.0) { token, hex, color in
                            Swatch(token: token, hex: hex, color: color)
                        }
                    }
                }
            }
        }
    }
}

private struct Swatch: View {
    let token: String
    let hex: String
    let color: Color
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
            RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                .fill(color)
                .frame(height: 72)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                        .strokeBorder(
                            AppTokens.Color.border(for: colorScheme).opacity(0.5),
                            lineWidth: AppTokens.Border.hairline
                        )
                )
            Text(token).appLabel()
            Text(hex)
                .font(AppTokens.Font.caption)
                .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
        }
    }
}
