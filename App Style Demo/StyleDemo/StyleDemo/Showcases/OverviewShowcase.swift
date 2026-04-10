import SwiftUI

struct OverviewShowcase: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xl) {
            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("APP ANATOMY").appLabel()
                Text("Every Tyler App Style app follows the same SideBar / Canvas / Inspector skeleton. The sidebar has exactly two states: Full Width and Condensed Width.")
                    .font(AppTokens.Font.bodySmall)
                    .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
            }

            HStack(alignment: .top, spacing: AppTokens.Spacing.lg) {
                sidebarPreview(condensed: false, label: "FULL WIDTH")
                sidebarPreview(condensed: true, label: "CONDENSED WIDTH")
            }

            legend
        }
    }

    private func sidebarPreview(condensed: Bool, label: String) -> some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
            Text(label).appLabel()
            GlassSectionCard {
                MiniAppPreview(condensed: condensed)
                    .frame(height: 280)
            }
        }
    }

    private var legend: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
            Text("ANCHOR ELEMENTS").appLabel()
            GlassSectionCard {
                VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
                    LegendRow(number: 1, label: "Window Controls (traffic lights)")
                    LegendRow(number: 2, label: "SideBar Toggle glyph")
                    LegendRow(number: 3, label: "App Title")
                    LegendRow(number: 4, label: "Search field")
                    LegendRow(number: 5, label: "Menu items")
                    LegendRow(number: 6, label: "Canvas / main interaction area")
                    LegendRow(number: 7, label: "Inspector panel (optional)")
                }
            }
        }
    }
}

private struct LegendRow: View {
    let number: Int
    let label: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: AppTokens.Spacing.sm) {
            PinBadge(number: number)
            Text(label)
                .font(AppTokens.Font.bodySmall)
                .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
        }
    }
}

private struct PinBadge: View {
    let number: Int
    var body: some View {
        ZStack {
            Circle().fill(AppTokens.Color.accent)
            Text("\(number)")
                .font(AppTokens.Font.caption)
                .foregroundStyle(.white)
        }
        .frame(width: 16, height: 16)
    }
}

private struct MiniAppPreview: View {
    let condensed: Bool
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Canvas background
            RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                .fill(AppTokens.Color.background(for: colorScheme))

            HStack(spacing: 0) {
                // Sidebar column
                VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
                    HStack(spacing: 4) {
                        TrafficLight(color: .red)
                        TrafficLight(color: .yellow)
                        TrafficLight(color: .green)
                        if !condensed {
                            Spacer()
                            Image(systemName: "sidebar.left")
                                .font(.system(size: 9))
                                .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
                                .overlay(PinBadge(number: 2).offset(x: 10, y: -8))
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 8)
                    .overlay(alignment: .topLeading) {
                        PinBadge(number: 1).offset(x: -4, y: -4)
                    }

                    if !condensed {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(AppTokens.Color.surface(for: colorScheme))
                            .frame(height: 14)
                            .overlay(
                                HStack(spacing: 2) {
                                    Image(systemName: "magnifyingglass")
                                        .font(.system(size: 7))
                                    Text("Search")
                                        .font(.system(size: 7))
                                    Spacer()
                                }
                                .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
                                .padding(.horizontal, 4)
                            )
                            .padding(.horizontal, 8)
                            .overlay(alignment: .trailing) {
                                PinBadge(number: 4).offset(x: -2)
                            }
                    }

                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(0..<5) { i in
                            miniRow(index: i)
                        }
                    }
                    .padding(.horizontal, condensed ? 4 : 8)
                    .padding(.top, 4)
                    .overlay(alignment: .trailing) {
                        if !condensed {
                            PinBadge(number: 5).offset(x: 4)
                        }
                    }

                    Spacer()
                }
                .frame(width: condensed ? 36 : 100)
                .background(AppTokens.Color.surface(for: colorScheme).opacity(0.6))

                // Canvas column
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("App")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(AppTokens.Color.textDisplay(for: colorScheme))
                            .overlay(alignment: .topTrailing) {
                                PinBadge(number: 3).offset(x: 4, y: -6)
                            }
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 8)

                    RoundedRectangle(cornerRadius: AppTokens.Radius.sm)
                        .strokeBorder(
                            AppTokens.Color.border(for: colorScheme),
                            lineWidth: 0.5
                        )
                        .padding(8)
                        .overlay(
                            Text("Canvas")
                                .font(.system(size: 9))
                                .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
                        )
                        .overlay(alignment: .topLeading) {
                            PinBadge(number: 6).padding(12)
                        }
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: AppTokens.Radius.md))
    }

    private func miniRow(index: Int) -> some View {
        HStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 1)
                .fill(
                    index == 0
                        ? AppTokens.Color.accent
                        : AppTokens.Color.textTertiary(for: colorScheme)
                )
                .frame(width: 6, height: 6)
            if !condensed {
                RoundedRectangle(cornerRadius: 1)
                    .fill(
                        index == 0
                            ? AppTokens.Color.textDisplay(for: colorScheme)
                            : AppTokens.Color.textTertiary(for: colorScheme).opacity(0.5)
                    )
                    .frame(width: 40, height: 5)
                Spacer()
            }
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 2)
        .background(
            RoundedRectangle(cornerRadius: 3)
                .fill(
                    index == 0
                        ? AppTokens.Color.accent.opacity(0.18)
                        : .clear
                )
        )
    }
}

private struct TrafficLight: View {
    let color: Color
    var body: some View {
        Circle().fill(color).frame(width: 7, height: 7)
    }
}
