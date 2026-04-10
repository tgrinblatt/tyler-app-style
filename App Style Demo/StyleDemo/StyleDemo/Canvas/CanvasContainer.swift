import SwiftUI

struct CanvasContainer<Content: View>: View {
    let title: String
    let subtitle: String
    @ViewBuilder let content: () -> Content
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VStack(spacing: 0) {
            CanvasHeader(title: title, subtitle: subtitle)
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
