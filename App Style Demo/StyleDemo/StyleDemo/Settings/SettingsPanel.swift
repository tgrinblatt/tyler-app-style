import SwiftUI

struct SettingsPanel: View {
    @Bindable var settings: AppSettings
    @State private var selectedPage: SettingsPage = .appearance
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss

    enum SettingsPage: String, CaseIterable, Identifiable, Hashable {
        case appearance, general, about, credits

        var id: String { rawValue }

        var title: String {
            switch self {
            case .appearance: return "Appearance"
            case .general:    return "General"
            case .about:      return "About"
            case .credits:    return "Credits"
            }
        }

        var icon: String {
            switch self {
            case .appearance: return "paintbrush"
            case .general:    return "slider.horizontal.3"
            case .about:      return "info.circle"
            case .credits:    return "heart"
            }
        }
    }

    var body: some View {
        HStack(spacing: 0) {
            // Left: page list (frosted — mirrors the app sidebar pattern)
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("DEMO SETTINGS").appLabel()
                    Spacer()
                }
                .padding(.horizontal, AppTokens.Spacing.md)
                .padding(.top, AppTokens.Spacing.md)
                .padding(.bottom, AppTokens.Spacing.sm)

                Divider().opacity(0.3)

                VStack(alignment: .leading, spacing: AppTokens.Spacing.xxs) {
                    ForEach(SettingsPage.allCases) { page in
                        pageRow(page)
                    }
                }
                .padding(.horizontal, AppTokens.Spacing.xs)
                .padding(.vertical, AppTokens.Spacing.sm)

                Spacer(minLength: 0)

                Divider().opacity(0.3)

                HStack {
                    Spacer()
                    GlassButton(label: "Done", icon: "checkmark") {
                        dismiss()
                    }
                }
                .padding(AppTokens.Spacing.md)
            }
            .frame(width: 200)
            .background(.ultraThinMaterial)

            Divider()

            // Right: active page
            ScrollView {
                Group {
                    switch selectedPage {
                    case .appearance: AppearancePage(settings: settings)
                    case .general:    GeneralPage()
                    case .about:      AboutPage()
                    case .credits:    CreditsPage()
                    }
                }
                .padding(.horizontal, AppTokens.Spacing.xl)
                .padding(.vertical, AppTokens.Spacing.lg)
                .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity)
            .background(AppTokens.Color.background(for: colorScheme))
        }
        .frame(width: 760, height: 520)
    }

    private func pageRow(_ page: SettingsPage) -> some View {
        let isSelected = selectedPage == page
        return Button {
            withAnimation(AppTokens.Motion.snappy) { selectedPage = page }
        } label: {
            HStack(spacing: AppTokens.Spacing.sm) {
                Image(systemName: page.icon)
                    .font(.system(size: 13, weight: .medium))
                    .frame(width: 20)
                Text(page.title)
                    .font(AppTokens.Font.headingSmall)
                Spacer(minLength: 0)
            }
            .foregroundStyle(
                isSelected
                    ? AppTokens.Color.textDisplay(for: colorScheme)
                    : AppTokens.Color.textSecondary(for: colorScheme)
            )
            .padding(.horizontal, AppTokens.Spacing.md)
            .padding(.vertical, AppTokens.Spacing.sm)
            .background(
                RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                    .fill(isSelected ? AppTokens.Color.accent.opacity(0.18) : .clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .help(page.title)
    }
}

// MARK: - Pages

private struct AppearancePage: View {
    @Bindable var settings: AppSettings
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xl) {
            PageHeader(
                title: "APPEARANCE",
                description: "Choose how StyleDemo matches your system appearance. System follows macOS; Light and Dark override for this window only."
            )

            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("COLOR SCHEME").appLabel()
                GlassSectionCard {
                    GlassEffectContainer {
                        HStack(spacing: AppTokens.Spacing.xs) {
                            ForEach(AppSettings.AppearanceMode.allCases) { mode in
                                appearanceButton(mode)
                            }
                        }
                    }
                    .padding(AppTokens.Spacing.xs)
                }
            }

            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("PREVIEW").appLabel()
                GlassSectionCard {
                    HStack(spacing: AppTokens.Spacing.md) {
                        previewSwatch("BACKGROUND", AppTokens.Color.background(for: colorScheme))
                        previewSwatch("SURFACE", AppTokens.Color.surface(for: colorScheme))
                        previewSwatch("TEXT", AppTokens.Color.textPrimary(for: colorScheme))
                        previewSwatch("ACCENT", AppTokens.Color.accent)
                    }
                    .padding(AppTokens.Spacing.xs)
                }
            }
        }
    }

    private func appearanceButton(_ mode: AppSettings.AppearanceMode) -> some View {
        Button {
            withAnimation(AppTokens.Motion.smooth) {
                settings.appearance = mode
            }
        } label: {
            HStack(spacing: AppTokens.Spacing.xs) {
                Image(systemName: mode.icon)
                    .font(.system(size: 11, weight: .medium))
                Text(mode.label)
                    .font(AppTokens.Font.caption)
                    .tracking(0.88)
                    .textCase(.uppercase)
            }
            .foregroundStyle(
                settings.appearance == mode
                    ? AppTokens.Color.textDisplay(for: colorScheme)
                    : AppTokens.Color.textTertiary(for: colorScheme)
            )
            .padding(.horizontal, AppTokens.Spacing.md)
            .padding(.vertical, AppTokens.Spacing.sm)
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .glassEffect(
            settings.appearance == mode
                ? .regular.tint(AppTokens.Color.accent.opacity(0.25)).interactive()
                : .clear,
            in: .capsule
        )
        .help(mode.label.capitalized)
    }

    private func previewSwatch(_ label: String, _ color: Color) -> some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
            RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                .fill(color)
                .frame(height: 56)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                        .strokeBorder(
                            AppTokens.Color.border(for: colorScheme).opacity(0.5),
                            lineWidth: AppTokens.Border.hairline
                        )
                )
            Text(label).appLabel()
        }
        .frame(maxWidth: .infinity)
    }
}

private struct GeneralPage: View {
    @State private var showHints: Bool = true
    @State private var overlayGrid: Bool = false
    @State private var reduceMotion: Bool = false
    @State private var density: Int = 1
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xl) {
            PageHeader(
                title: "GENERAL",
                description: "Mock toggles that demonstrate the settings-row pattern. None of these affect the running demo."
            )

            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("BEHAVIOR").appLabel()
                GlassSectionCard {
                    VStack(spacing: AppTokens.Spacing.md) {
                        SettingRow(
                            title: "Show showcase hints",
                            caption: "Display helper captions under each example.",
                            isOn: $showHints
                        )
                        Divider().opacity(0.3)
                        SettingRow(
                            title: "Overlay 8pt grid",
                            caption: "Stress-test spacing tokens by overlaying a grid.",
                            isOn: $overlayGrid
                        )
                        Divider().opacity(0.3)
                        SettingRow(
                            title: "Reduce motion",
                            caption: "Use linear substitutes for spring animations.",
                            isOn: $reduceMotion
                        )
                    }
                }
            }

            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("DENSITY").appLabel()
                GlassSectionCard {
                    GlassEffectContainer {
                        Picker("", selection: $density) {
                            Text("Compact").tag(0)
                            Text("Default").tag(1)
                            Text("Spacious").tag(2)
                        }
                        .pickerStyle(.segmented)
                        .labelsHidden()
                    }
                    .padding(AppTokens.Spacing.xs)
                }
            }
        }
    }
}

private struct AboutPage: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xl) {
            PageHeader(
                title: "ABOUT",
                description: "Living reference for the Tyler App Style design system."
            )

            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("APPLICATION").appLabel()
                GlassSectionCard {
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        Text("StyleDemo")
                            .font(AppTokens.Font.displaySmall)
                            .foregroundStyle(AppTokens.Color.textDisplay(for: colorScheme))
                        Text("A SwiftUI macOS app that renders every primitive in the Tyler App Style design system as a live reference surface.")
                            .font(AppTokens.Font.bodySmall)
                            .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
                            .fixedSize(horizontal: false, vertical: true)
                        Divider().opacity(0.3).padding(.vertical, AppTokens.Spacing.xs)
                        infoRow("VERSION", "1.0.0 (demo)")
                        infoRow("PLATFORM", "macOS 26+")
                        infoRow("BUILT WITH", "SwiftUI · Swift 6")
                        infoRow("REPO", "tgrinblatt/tyler-app-style")
                        infoRow("BRANCH", "style-demo")
                    }
                }
            }
        }
    }

    private func infoRow(_ key: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(key).appLabel().frame(width: 110, alignment: .leading)
            Text(value)
                .font(AppTokens.Font.bodySmall)
                .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
        }
    }
}

private struct CreditsPage: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xl) {
            PageHeader(
                title: "CREDITS",
                description: "Design system authorship and inspirations."
            )

            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("DESIGN SYSTEM").appLabel()
                GlassSectionCard {
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
                        Text("Tyler Grinblatt")
                            .font(AppTokens.Font.headingSmall)
                            .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
                        Text("Tyler App Style — dark-first monochrome + Liquid Glass")
                            .font(AppTokens.Font.bodySmall)
                            .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
                    }
                }
            }

            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("INSPIRED BY").appLabel()
                GlassSectionCard {
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        bulletRow("Nothing palette (monochrome with single accent)")
                        bulletRow("Apple Liquid Glass (macOS 26)")
                        bulletRow("Geist typography")
                    }
                }
            }
        }
    }

    private func bulletRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: AppTokens.Spacing.sm) {
            Circle()
                .fill(AppTokens.Color.accent)
                .frame(width: 4, height: 4)
                .offset(y: 6)
            Text(text)
                .font(AppTokens.Font.bodySmall)
                .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
        }
    }
}

// MARK: - Shared page components

private struct PageHeader: View {
    let title: String
    let description: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
            Text(title).appLabel()
            Text(description)
                .font(AppTokens.Font.bodySmall)
                .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private struct SettingRow: View {
    let title: String
    let caption: String
    @Binding var isOn: Bool
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(alignment: .top, spacing: AppTokens.Spacing.md) {
            VStack(alignment: .leading, spacing: AppTokens.Spacing.xxs) {
                Text(title)
                    .font(AppTokens.Font.headingSmall)
                    .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
                Text(caption)
                    .font(AppTokens.Font.caption)
                    .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
            }
            Spacer()
            Toggle("", isOn: $isOn)
                .tint(AppTokens.Color.accent)
                .labelsHidden()
        }
    }
}
