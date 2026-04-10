import SwiftUI

struct SettingsPanel: View {
    @Bindable var settings: AppSettings
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            HStack {
                Text("DEMO SETTINGS").appLabel()
                Spacer()
            }

            Divider().opacity(0.3)

            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("APPEARANCE").appLabel()
                GlassEffectContainer {
                    HStack(spacing: AppTokens.Spacing.xxs) {
                        ForEach(AppSettings.AppearanceMode.allCases) { mode in
                            appearanceButton(mode)
                        }
                    }
                }
                Text("System follows your macOS Appearance setting. Light and Dark override for this window only.")
                    .font(AppTokens.Font.caption)
                    .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(AppTokens.Spacing.md)
        .frame(width: 300)
        .background(
            RoundedRectangle(cornerRadius: AppTokens.Radius.lg)
                .fill(.ultraThinMaterial)
        )
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
            .padding(.horizontal, AppTokens.Spacing.sm)
            .padding(.vertical, AppTokens.Spacing.xs + 2)
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
}
