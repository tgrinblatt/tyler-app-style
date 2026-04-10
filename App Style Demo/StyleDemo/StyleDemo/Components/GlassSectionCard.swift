import SwiftUI

// Note: despite the name, GlassSectionCard does NOT use .glassEffect — it's a flat
// surface fill used on content (notes, annotations, inspector bodies). Glass goes
// on chrome; content stays flat. Keep this distinction visible in the demo.
struct GlassSectionCard<Content: View>: View {
    let content: Content
    @Environment(\.colorScheme) private var colorScheme

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(AppTokens.Spacing.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                    .fill(AppTokens.Color.surface(for: colorScheme).opacity(0.5))
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                    .strokeBorder(
                        AppTokens.Color.borderStrong(for: colorScheme).opacity(0.3),
                        lineWidth: AppTokens.Border.hairline
                    )
            )
    }
}
