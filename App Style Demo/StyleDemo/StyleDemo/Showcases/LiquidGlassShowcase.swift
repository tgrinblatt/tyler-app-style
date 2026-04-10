import SwiftUI

struct LiquidGlassShowcase: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var filterSelection: DemoFilter = .all

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.lg) {
            Text("Glass goes on chrome. Flat on content. Toggle System Settings → Appearance to test both schemes.")
                .font(AppTokens.Font.bodySmall)
                .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))

            HStack(alignment: .top, spacing: AppTokens.Spacing.lg) {
                glassGoesHere
                glassDoesNotGoHere
            }
        }
    }

    private var glassGoesHere: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            Text("GLASS GOES HERE").appLabel()

            caption("Toolbar button — chrome → glass allowed") {
                GlassEffectContainer {
                    GlassButton(label: "Export", icon: "square.and.arrow.up") { }
                }
            }

            caption("Filter pills — active selection needs chrome → glass") {
                GlassFilterBar(options: DemoFilter.allCases, selection: $filterSelection)
            }

            caption("Stat pills — metric chrome → glass") {
                GlassEffectContainer {
                    HStack(spacing: AppTokens.Spacing.sm) {
                        StatPill(value: "12", label: "SLIDES")
                        StatPill(value: "3", label: "FLAGGED")
                    }
                }
            }

            caption("Connection badges — status chrome → glass") {
                GlassEffectContainer {
                    HStack(spacing: AppTokens.Spacing.sm) {
                        ConnectionBadge(label: "Ready", color: AppTokens.Color.success)
                        ConnectionBadge(label: "Pending", color: AppTokens.Color.warning)
                    }
                }
            }

            caption("Drop zone — interactive surface → subtle glass tint") {
                Text("Drop .pptx files")
                    .font(AppTokens.Font.bodySmall)
                    .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
                    .frame(maxWidth: .infinity, minHeight: 80)
                    .padding(AppTokens.Spacing.lg)
                    .background(
                        RoundedRectangle(cornerRadius: AppTokens.Radius.xl)
                            .fill(AppTokens.Color.surface(for: colorScheme).opacity(0.6))
                    )
                    .glassEffect(
                        .regular.tint(AppTokens.Color.accent.opacity(0.05)),
                        in: .rect(cornerRadius: AppTokens.Radius.xl)
                    )
            }

            caption("Slider handle — chrome → glass") {
                GlassSliderHandle()
            }

            caption("Pill title — floating chrome over content → glass") {
                GlassPillTitle(title: "Section Title")
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    private var glassDoesNotGoHere: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            Text("GLASS DOES NOT GO HERE").appLabel()

            caption("Slide thumbnail — content image → flat surface") {
                VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
                    RoundedRectangle(cornerRadius: AppTokens.Radius.sm)
                        .fill(
                            LinearGradient(
                                colors: [AppTokens.Color.accent.opacity(0.3), AppTokens.Color.info.opacity(0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 90)
                    Text("Slide 3")
                        .font(AppTokens.Font.caption)
                        .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
                }
            }

            caption("Diff text — content → flat, no glass") {
                VStack(alignment: .leading, spacing: 2) {
                    diffLine("- Old revenue: $12,400", bg: AppTokens.Color.diffRemovedBg(for: colorScheme))
                    diffLine("+ New revenue: $14,800", bg: AppTokens.Color.diffAddedBg(for: colorScheme))
                    diffLine("  Total growth: 19.4%", bg: AppTokens.Color.surface(for: colorScheme).opacity(0.3))
                }
            }

            caption("Chart bars — content data → flat, no glass") {
                HStack(alignment: .bottom, spacing: AppTokens.Spacing.sm) {
                    Rectangle().fill(AppTokens.Color.accent).frame(width: 24, height: 60)
                    Rectangle().fill(AppTokens.Color.accent).frame(width: 24, height: 40)
                    Rectangle().fill(AppTokens.Color.accent).frame(width: 24, height: 80)
                }
                .frame(height: 100, alignment: .bottom)
            }

            caption("Annotation pin — overlay on content → flat circle") {
                ZStack(alignment: .topLeading) {
                    RoundedRectangle(cornerRadius: AppTokens.Radius.sm)
                        .fill(AppTokens.Color.surface(for: colorScheme))
                        .frame(height: 80)
                    ZStack {
                        Circle().fill(AppTokens.Color.accent)
                        Text("1").font(AppTokens.Font.caption).foregroundStyle(.white)
                    }
                    .frame(width: 20, height: 20)
                    .padding(AppTokens.Spacing.sm)
                }
            }

            caption("Speaker notes — GlassSectionCard uses a flat surface fill, NOT .glassEffect") {
                GlassSectionCard {
                    Text("The audience should leave with three takeaways: growth, margin, roadmap.")
                        .font(AppTokens.Font.bodySmall)
                        .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }

    @ViewBuilder
    private func caption<Content: View>(_ text: String, @ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
            content()
            Text(text)
                .font(AppTokens.Font.caption)
                .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
        }
    }

    private func diffLine(_ text: String, bg: Color) -> some View {
        Text(text)
            .font(AppTokens.Font.bodySmall)
            .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
            .padding(.horizontal, AppTokens.Spacing.sm)
            .padding(.vertical, AppTokens.Spacing.xxs)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(bg)
    }
}
