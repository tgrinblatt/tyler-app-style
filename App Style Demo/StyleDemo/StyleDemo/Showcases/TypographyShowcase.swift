import SwiftUI

struct TypographyShowcase: View {
    @Environment(\.colorScheme) private var colorScheme

    private let pangram = "The quick brown fox jumps over the lazy dog"
    private let symbols = "0123456789 !@#$%^&*()"

    private let weights: [(String, String)] = [
        ("BLACK",  "Black"),
        ("BOLD",   "Bold"),
        ("MEDIUM", "Medium"),
        ("LIGHT",  "Light")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xl) {
            familyPanel(title: "GEIST", prefix: "Geist")
            familyPanel(title: "GEIST MONO", prefix: "GeistMono")

            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("GEIST PIXEL").appLabel()
                GlassSectionCard {
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.lg) {
                        ForEach(Array(AppTokens.FontFamily.PixelVariant.allCases.enumerated()), id: \.element) { index, variant in
                            pixelVariantRow(variant)
                            if index < AppTokens.FontFamily.PixelVariant.allCases.count - 1 {
                                Divider().opacity(0.3)
                            }
                        }
                    }
                }
            }

            tokenTable
        }
    }

    private func familyPanel(title: String, prefix: String) -> some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
            Text(title).appLabel()
            GlassSectionCard {
                VStack(alignment: .leading, spacing: AppTokens.Spacing.lg) {
                    ForEach(weights, id: \.0) { name, weight in
                        VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
                            Text(name).appLabel()
                            Text(pangram)
                                .font(.custom("\(prefix)-\(weight)", size: 42))
                                .foregroundStyle(AppTokens.Color.textDisplay(for: colorScheme))
                            Text(symbols)
                                .font(.custom("\(prefix)-\(weight)", size: 14))
                                .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
                        }
                    }
                }
            }
        }
    }

    private func pixelVariantRow(_ variant: AppTokens.FontFamily.PixelVariant) -> some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
            HStack(alignment: .firstTextBaseline) {
                Text(variant.label).appLabel()
                Spacer()
                Text("GeistPixel-\(variant.rawValue)")
                    .font(AppTokens.Font.caption)
                    .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
            }
            Text("HELLO WORLD 0123")
                .font(AppTokens.FontFamily.geistPixel(variant, size: 42))
                .foregroundStyle(AppTokens.Color.textDisplay(for: colorScheme))
            Text("AA BB CC 00 11 22")
                .font(AppTokens.FontFamily.geistPixel(variant, size: 14))
                .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
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
