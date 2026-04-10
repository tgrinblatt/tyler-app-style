import SwiftUI

struct InspectorShowcase: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xl) {
            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("INSPECTOR PANEL").appLabel()
                Text("The Inspector panel is visible on the right side of the canvas whenever this showcase is selected. It can also be toggled from the toolbar.")
                    .font(AppTokens.Font.bodySmall)
                    .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
            }

            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("WHAT IT'S FOR").appLabel()
                GlassSectionCard {
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        bullet("Contextual detail for the current selection")
                        bullet("Secondary controls that don't belong in the toolbar")
                        bullet("Notes, metadata, annotations")
                        bullet("Never primary navigation — that lives in the sidebar")
                    }
                }
            }

            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("BEHAVIOR").appLabel()
                GlassSectionCard {
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        bullet("Collapses with .move(edge: .trailing) + .opacity transition")
                        bullet("Animates with AppTokens.Motion.smooth")
                        bullet("Fixed 300pt width — never resizes continuously")
                        bullet("Background: AppTokens.Color.background — flat, not glass")
                    }
                }
            }
        }
    }

    private func bullet(_ text: String) -> some View {
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
