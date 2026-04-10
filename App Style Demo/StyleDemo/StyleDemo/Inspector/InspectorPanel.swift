import SwiftUI

struct InspectorPanel: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("INSPECTOR").appLabel()
                Spacer()
                Text("STYLE DEMO")
                    .font(AppTokens.Font.caption)
                    .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
            }
            .padding(.horizontal, AppTokens.Spacing.md)
            .frame(height: 44)
            .background(AppTokens.Color.surface(for: colorScheme).opacity(0.5))

            ScrollView {
                VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        Text("DETAILS").appLabel()
                        GlassSectionCard {
                            VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
                                InspectorRow(key: "SURFACE", value: "Liquid Glass")
                                InspectorRow(key: "ACCENT", value: "#E5600A")
                                InspectorRow(key: "RADIUS", value: "12pt")
                                InspectorRow(key: "MOTION", value: "smooth")
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        Text("NOTES").appLabel()
                        GlassSectionCard {
                            Text("The Inspector panel provides contextual detail for the selected showcase. It collapses with a spring animation and never contains primary navigation.")
                                .font(AppTokens.Font.bodySmall)
                                .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
                        }
                    }

                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        Text("ACTIONS").appLabel()
                        HStack(spacing: AppTokens.Spacing.sm) {
                            GlassButton(label: "Save", icon: "checkmark") { }
                            GlassButton(label: "Revert", icon: "arrow.uturn.backward") { }
                        }
                    }
                }
                .padding(AppTokens.Spacing.md)
            }
        }
        .background(AppTokens.Color.background(for: colorScheme))
    }
}

struct InspectorRow: View {
    let key: String
    let value: String
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack {
            Text(key).appLabel()
            Spacer()
            Text(value)
                .font(AppTokens.Font.bodySmall)
                .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
        }
    }
}
