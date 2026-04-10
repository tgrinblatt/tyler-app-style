import SwiftUI

struct GlassFilterBar<Option: Hashable & CustomStringConvertible>: View {
    let options: [Option]
    @Binding var selection: Option
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        GlassEffectContainer {
            HStack(spacing: AppTokens.Spacing.xxs) {
                ForEach(options, id: \.self) { option in
                    Button {
                        withAnimation(AppTokens.Motion.snappy) { selection = option }
                    } label: {
                        Text(String(describing: option))
                            .font(AppTokens.Font.caption)
                            .tracking(0.88)
                            .textCase(.uppercase)
                            .foregroundStyle(
                                selection == option
                                    ? AppTokens.Color.textDisplay(for: colorScheme)
                                    : AppTokens.Color.textTertiary(for: colorScheme)
                            )
                            .padding(.horizontal, AppTokens.Spacing.sm)
                            .padding(.vertical, AppTokens.Spacing.xs)
                    }
                    .buttonStyle(.plain)
                    .glassEffect(
                        selection == option
                            ? .regular.tint(AppTokens.Color.accent.opacity(0.2)).interactive()
                            : .clear,
                        in: .capsule
                    )
                }
            }
        }
    }
}
