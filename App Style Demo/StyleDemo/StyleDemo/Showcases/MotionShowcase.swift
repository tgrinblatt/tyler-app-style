import SwiftUI

struct MotionShowcase: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var snappyOffset: CGFloat = 0
    @State private var smoothOffset: CGFloat = 0
    @State private var bouncyOffset: CGFloat = 0
    @State private var transitionVisible: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xl) {
            Text("Every animation uses a spring. Never linear, never easeInOut.")
                .font(AppTokens.Font.bodySmall)
                .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))

            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("SPRING PRESETS").appLabel()
                GlassSectionCard {
                    VStack(spacing: AppTokens.Spacing.lg) {
                        motionRow(
                            label: "SNAPPY",
                            subtitle: "spring(duration: 0.25, bounce: 0)",
                            offset: snappyOffset
                        ) {
                            withAnimation(AppTokens.Motion.snappy) {
                                snappyOffset = snappyOffset == 0 ? 140 : 0
                            }
                        }
                        motionRow(
                            label: "SMOOTH",
                            subtitle: "spring(duration: 0.35, bounce: 0)",
                            offset: smoothOffset
                        ) {
                            withAnimation(AppTokens.Motion.smooth) {
                                smoothOffset = smoothOffset == 0 ? 140 : 0
                            }
                        }
                        motionRow(
                            label: "BOUNCY",
                            subtitle: "spring(duration: 0.4, bounce: 0.15)",
                            offset: bouncyOffset
                        ) {
                            withAnimation(AppTokens.Motion.bouncy) {
                                bouncyOffset = bouncyOffset == 0 ? 140 : 0
                            }
                        }
                    }
                }
            }

            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("TRANSITION — MOVE + OPACITY").appLabel()
                GlassSectionCard {
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
                        Button {
                            withAnimation(AppTokens.Motion.smooth) {
                                transitionVisible.toggle()
                            }
                        } label: {
                            Text(transitionVisible ? "HIDE" : "SHOW")
                                .font(AppTokens.Font.label)
                                .tracking(0.88)
                                .padding(.horizontal, AppTokens.Spacing.md)
                                .padding(.vertical, AppTokens.Spacing.sm - 2)
                        }
                        .buttonStyle(.glass)
                        .help("Toggle transition demo")

                        HStack {
                            if transitionVisible {
                                RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                                    .fill(AppTokens.Color.accent)
                                    .frame(width: 200, height: 60)
                                    .overlay(
                                        Text("Inspector-like panel")
                                            .font(AppTokens.Font.caption)
                                            .foregroundStyle(.white)
                                    )
                                    .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                            Spacer()
                        }
                        .frame(height: 60)
                    }
                }
            }
        }
    }

    private func motionRow(label: String, subtitle: String, offset: CGFloat, action: @escaping () -> Void) -> some View {
        HStack(spacing: AppTokens.Spacing.lg) {
            VStack(alignment: .leading, spacing: AppTokens.Spacing.xxs) {
                Text(label).appLabel()
                Text(subtitle)
                    .font(AppTokens.Font.caption)
                    .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
            }
            .frame(width: 220, alignment: .leading)

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: AppTokens.Radius.sm)
                    .fill(AppTokens.Color.surface(for: colorScheme).opacity(0.4))
                    .frame(height: 48)
                RoundedRectangle(cornerRadius: AppTokens.Radius.sm)
                    .fill(AppTokens.Color.accent)
                    .frame(width: 48, height: 48)
                    .offset(x: offset)
            }
            .frame(maxWidth: .infinity)

            Button(action: action) {
                Text("RUN")
                    .font(AppTokens.Font.label)
                    .tracking(0.88)
                    .padding(.horizontal, AppTokens.Spacing.md)
                    .padding(.vertical, AppTokens.Spacing.sm - 2)
            }
            .buttonStyle(.glass)
            .help("Run \(label) animation")
        }
    }
}
