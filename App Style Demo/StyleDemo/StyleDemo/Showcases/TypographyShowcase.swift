import SwiftUI

struct TypographyShowcase: View {
    @Environment(\.colorScheme) private var colorScheme

    private let pangram = "The quick brown fox jumps over the lazy dog"
    private let symbols = "0123456789 !@#$%^&*()"

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xl) {
            // TODO: swap to Geist when bundled — showing fallback notice
            ConnectionBadge(label: "GEIST FONTS NOT BUNDLED — USING SYSTEM FALLBACKS", color: AppTokens.Color.warning)

            familyPanel(
                title: "GEIST",
                design: .default,
                weights: [("BLACK", .black), ("BOLD", .bold), ("MEDIUM", .medium), ("LIGHT", .light)]
            )

            familyPanel(
                title: "GEIST MONO",
                design: .monospaced,
                weights: [("BLACK", .black), ("BOLD", .bold), ("MEDIUM", .medium), ("LIGHT", .light)]
            )

            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("GEIST PIXEL").appLabel()
                GlassSectionCard {
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        Text("HELLO WORLD")
                            .font(.system(size: 42, weight: .regular, design: .monospaced))
                            .foregroundStyle(AppTokens.Color.textDisplay(for: colorScheme))
                        Text("AA BB CC 00 11 22")
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                            .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
                    }
                }
            }

            tokenTable
        }
    }

    private func familyPanel(title: String, design: SwiftUI.Font.Design, weights: [(String, SwiftUI.Font.Weight)]) -> some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
            Text(title).appLabel()
            GlassSectionCard {
                VStack(alignment: .leading, spacing: AppTokens.Spacing.lg) {
                    ForEach(weights, id: \.0) { name, weight in
                        VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
                            Text(name).appLabel()
                            Text(pangram)
                                .font(.system(size: 42, weight: weight, design: design))
                                .foregroundStyle(AppTokens.Color.textDisplay(for: colorScheme))
                            Text(symbols)
                                .font(.system(size: 14, weight: weight, design: design))
                                .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
                        }
                    }
                }
            }
        }
    }

    private var tokenTable: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
            Text("TOKEN TABLE").appLabel()
            GlassSectionCard {
                VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                    tokenRow("DISPLAY LARGE", AppTokens.Font.displayLarge, "The quick brown fox")
                    tokenRow("DISPLAY MEDIUM", AppTokens.Font.displayMedium, "The quick brown fox")
                    tokenRow("DISPLAY SMALL", AppTokens.Font.displaySmall, "The quick brown fox")
                    tokenRow("HEADING LARGE", AppTokens.Font.headingLarge, "The quick brown fox")
                    tokenRow("HEADING SMALL", AppTokens.Font.headingSmall, "The quick brown fox")
                    tokenRow("BODY LARGE", AppTokens.Font.bodyLarge, "The quick brown fox")
                    tokenRow("BODY SMALL", AppTokens.Font.bodySmall, "The quick brown fox")
                    tokenRow("CAPTION", AppTokens.Font.caption, "The quick brown fox")
                    HStack(alignment: .firstTextBaseline) {
                        Text("LABEL").appLabel().frame(width: 140, alignment: .leading)
                        Text("THE QUICK BROWN FOX")
                            .font(AppTokens.Font.label)
                            .tracking(0.88)
                            .textCase(.uppercase)
                            .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
                    }
                    tokenRow("NUMERIC", AppTokens.Font.numeric, "0123456789")
                    tokenRow("NUMERIC SMALL", AppTokens.Font.numericSmall, "0123456789")
                }
            }
        }
    }

    private func tokenRow(_ name: String, _ font: SwiftUI.Font, _ sample: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(name).appLabel().frame(width: 140, alignment: .leading)
            Text(sample)
                .font(font)
                .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
        }
    }
}
