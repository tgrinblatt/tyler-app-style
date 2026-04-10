import SwiftUI

struct StopwatchShowcase: View {
    @State private var isRunning: Bool = false
    @State private var accumulated: TimeInterval = 0
    @State private var runStart: Date?
    @Environment(\.colorScheme) private var colorScheme

    private func elapsed(at now: Date) -> TimeInterval {
        if isRunning, let runStart {
            return accumulated + now.timeIntervalSince(runStart)
        }
        return accumulated
    }

    private func format(_ interval: TimeInterval) -> String {
        let cs = max(0, Int((interval * 100).rounded(.down)))
        let minutes = cs / 6000
        let seconds = (cs % 6000) / 100
        let centis = cs % 100
        return String(format: "%02d:%02d.%02d", minutes, seconds, centis)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xl) {
            VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
                Text("STOPWATCH").appLabel()
                Text("Rendered in Geist Pixel Circle. The display updates every frame via TimelineView(.animation) while running and freezes on pause.")
                    .font(AppTokens.Font.bodySmall)
                    .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
                    .fixedSize(horizontal: false, vertical: true)
            }

            // Big Geist Pixel Circle display
            GlassSectionCard {
                TimelineView(.animation(minimumInterval: 1.0 / 60.0, paused: !isRunning)) { context in
                    Text(format(elapsed(at: context.date)))
                        .font(AppTokens.FontFamily.geistPixel(.circle, size: 140))
                        .foregroundStyle(AppTokens.Color.textDisplay(for: colorScheme))
                        .monospacedDigit()
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(maxWidth: .infinity, minHeight: 200, alignment: .center)
                        .padding(.vertical, AppTokens.Spacing.lg)
                }
            }

            // Controls
            HStack(spacing: AppTokens.Spacing.md) {
                startPauseButton
                resetButton
                Spacer()
            }

            // Reference info
            VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                Text("FONT").appLabel()
                GlassSectionCard {
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
                        infoRow("FAMILY", "Geist Pixel")
                        infoRow("VARIANT", "Circle")
                        infoRow("POSTSCRIPT", "GeistPixel-Circle")
                        infoRow("SIZE", "140 pt")
                        infoRow("FORMAT", "MM:SS.cc")
                    }
                }
            }
        }
    }

    private var startPauseButton: some View {
        Button(action: toggle) {
            HStack(spacing: AppTokens.Spacing.xs) {
                Image(systemName: isRunning ? "pause.fill" : "play.fill")
                    .font(.system(size: 12, weight: .semibold))
                Text(isRunning ? "PAUSE" : "START")
                    .font(AppTokens.Font.label)
                    .tracking(0.88)
                    .textCase(.uppercase)
            }
            .padding(.horizontal, AppTokens.Spacing.lg)
            .padding(.vertical, AppTokens.Spacing.sm)
        }
        .buttonStyle(.glass)
        .tint(isRunning ? .clear : AppTokens.Color.accent.opacity(0.25))
        .help(isRunning ? "Pause" : "Start")
    }

    private var resetButton: some View {
        Button(action: reset) {
            HStack(spacing: AppTokens.Spacing.xs) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 12, weight: .semibold))
                Text("RESET")
                    .font(AppTokens.Font.label)
                    .tracking(0.88)
                    .textCase(.uppercase)
            }
            .padding(.horizontal, AppTokens.Spacing.lg)
            .padding(.vertical, AppTokens.Spacing.sm)
        }
        .buttonStyle(.glass)
        .disabled(accumulated == 0 && !isRunning && runStart == nil)
        .help("Reset")
    }

    private func toggle() {
        withAnimation(AppTokens.Motion.snappy) {
            if isRunning {
                if let runStart {
                    accumulated += Date().timeIntervalSince(runStart)
                }
                runStart = nil
                isRunning = false
            } else {
                runStart = Date()
                isRunning = true
            }
        }
    }

    private func reset() {
        withAnimation(AppTokens.Motion.smooth) {
            accumulated = 0
            runStart = isRunning ? Date() : nil
        }
    }

    private func infoRow(_ key: String, _ value: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(key).appLabel().frame(width: 110, alignment: .leading)
            Text(value)
                .font(AppTokens.Font.bodySmall)
                .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
        }
    }
}
