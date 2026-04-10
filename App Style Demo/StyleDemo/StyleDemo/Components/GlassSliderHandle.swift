import SwiftUI

struct GlassSliderHandle: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .frame(width: 32, height: 32)
            .overlay(
                Image(systemName: "arrow.left.and.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundStyle(AppTokens.Color.textDisplay(for: colorScheme))
            )
            .glassEffect(.regular.interactive(), in: .circle)
    }
}
