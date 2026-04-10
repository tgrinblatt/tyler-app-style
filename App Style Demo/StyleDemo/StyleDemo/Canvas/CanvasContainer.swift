import SwiftUI

struct CanvasContainer<Content: View>: View {
    @ViewBuilder let content: () -> Content
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            CanvasActionBar()
            Divider().opacity(0.3)
            ScrollView {
                content()
                    .padding(.horizontal, AppTokens.Spacing.xl)
                    .padding(.vertical, AppTokens.Spacing.lg)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
        .background(AppTokens.Color.background(for: colorScheme))
    }
}

private struct CanvasActionBar: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: AppTokens.Spacing.md) {
            GlassEffectContainer {
                HStack(spacing: AppTokens.Spacing.sm) {
                    StatPill(value: "\(Showcase.allCases.count)", label: "SHOWCASES")
                    StatPill(value: "2", label: "SCHEMES")
                    StatPill(value: "1", label: "ACCENT")
                }
            }
            Spacer()
            GlassEffectContainer {
                GlassButton(label: "Export Mock", icon: "square.and.arrow.up") { }
            }
        }
        .padding(.horizontal, AppTokens.Spacing.xl)
        .padding(.vertical, AppTokens.Spacing.md)
    }
}
