import SwiftUI

struct AppLabelStyle: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .font(AppTokens.Font.label)
            .tracking(0.88)
            .textCase(.uppercase)
            .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
    }
}

extension View {
    func appLabel() -> some View { modifier(AppLabelStyle()) }
}

struct SegmentedProgressBar: View {
    let progress: Double
    let segments: Int
    @Environment(\.colorScheme) private var colorScheme

    init(progress: Double, segments: Int = 24) {
        self.progress = progress
        self.segments = segments
    }

    var body: some View {
        HStack(spacing: 2) {
            let filled = Int(progress * Double(segments))
            ForEach(0..<segments, id: \.self) { i in
                RoundedRectangle(cornerRadius: 1)
                    .fill(i < filled ? AppTokens.Color.accent : AppTokens.Color.borderStrong(for: colorScheme))
                    .frame(height: 6)
            }
        }
    }
}
