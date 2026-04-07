# Design Tokens — Complete Reference

The full `AppTokens.swift` file that should be included in every Tyler App Style project. Colors use the `func X(for scheme: ColorScheme)` pattern to support both dark and light modes.

```swift
// AppTokens.swift — Tyler App Style Design System
// Nothing palette + Apple Liquid Glass hybrid.
// All views MUST reference these tokens — no hardcoded colors, fonts, or spacing.

import SwiftUI
import AppKit

enum AppTokens {

    // MARK: - Colors (ColorScheme-adaptive)

    enum Color {
        // Core palette
        static func background(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "0A0A0A")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "FFFFFF")!)
        }
        static func surface(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "111111")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "F5F5F5")!)
        }
        static func surfaceElevated(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "1A1A1A")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "EBEBEB")!)
        }
        static func border(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "222222")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "DDDDDD")!)
        }
        static func borderStrong(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "333333")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "CCCCCC")!)
        }

        // Text hierarchy
        static func textPrimary(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "E8E8E8")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "1A1A1A")!)
        }
        static func textDisplay(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark ? .white : .black
        }
        static func textSecondary(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "999999")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "666666")!)
        }
        static func textTertiary(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "666666")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "999999")!)
        }

        // Accent — used sparingly for selected/focused/interactive states
        static let accent = SwiftUI.Color(nsColor: NSColor(hex: "E5600A")!)
        static func accentDim(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "3D2510")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "FFF0E6")!)
        }
        static let interactive = SwiftUI.Color(nsColor: NSColor(hex: "E5600A")!)

        // Status — same in both schemes
        static let destructive = SwiftUI.Color(nsColor: NSColor(hex: "CC1018")!)
        static let warning = SwiftUI.Color(nsColor: NSColor(hex: "B8912E")!)
        static let success = SwiftUI.Color(nsColor: NSColor(hex: "2D8A3E")!)
        static let info = SwiftUI.Color(nsColor: NSColor(hex: "2E6FBA")!)

        // Diff backgrounds
        static func diffAddedBg(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "1A2E1A")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "E6F5E6")!)
        }
        static func diffRemovedBg(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "2E1A1A")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "F5E6E6")!)
        }
        static func diffChangedBg(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "1A1A2E")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "E6E6F5")!)
        }
    }

    // MARK: - Typography

    enum Font {
        static let displayLarge: SwiftUI.Font = .system(size: 42, weight: .bold)
        static let displayMedium: SwiftUI.Font = .system(size: 28, weight: .bold)
        static let displaySmall: SwiftUI.Font = .system(size: 20, weight: .semibold)
        static let headingLarge: SwiftUI.Font = .system(size: 17, weight: .medium)
        static let headingSmall: SwiftUI.Font = .system(size: 13, weight: .medium)
        static let bodyLarge: SwiftUI.Font = .system(size: 15, weight: .regular, design: .monospaced)
        static let bodySmall: SwiftUI.Font = .system(size: 12, weight: .regular, design: .monospaced)
        static let caption: SwiftUI.Font = .system(size: 10, weight: .regular, design: .monospaced)
        static let label: SwiftUI.Font = .system(size: 11, weight: .medium)
        static let numeric: SwiftUI.Font = .system(size: 24, weight: .bold, design: .monospaced)
        static let numericSmall: SwiftUI.Font = .system(size: 14, weight: .bold, design: .monospaced)
    }

    // MARK: - NSFont Equivalents (for AppKit / NSViewRepresentable)

    // Use these when building NSViewRepresentable wrappers or custom AppKit drawing.
    // They mirror the SwiftUI Font tokens above.
}

extension NSFont {
    static let appBodyLarge = NSFont.monospacedSystemFont(ofSize: 15, weight: .regular)
    static let appBodySmall = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
    static let appCaption = NSFont.monospacedSystemFont(ofSize: 10, weight: .regular)
    static let appLabel = NSFont.systemFont(ofSize: 11, weight: .medium)
    static let appHeadingLarge = NSFont.systemFont(ofSize: 17, weight: .medium)
    static let appHeadingSmall = NSFont.systemFont(ofSize: 13, weight: .medium)
    static let appNumeric = NSFont.monospacedSystemFont(ofSize: 24, weight: .bold)
    static let appNumericSmall = NSFont.monospacedSystemFont(ofSize: 14, weight: .bold)
    static let appDisplaySmall = NSFont.systemFont(ofSize: 20, weight: .semibold)
}

enum AppTokens_continued {

    // MARK: - Spacing (8pt grid)

    enum Spacing {
        static let xxs: CGFloat = 2
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        static let md: CGFloat = 16
        static let lg: CGFloat = 24
        static let xl: CGFloat = 32
        static let xxl: CGFloat = 48
        static let xxxl: CGFloat = 64
    }

    // MARK: - Corner Radius

    enum Radius {
        static let sm: CGFloat = 4
        static let md: CGFloat = 8
        static let lg: CGFloat = 12
        static let xl: CGFloat = 16
    }

    // MARK: - Border Width

    enum Border {
        static let hairline: CGFloat = 0.5
        static let thin: CGFloat = 1
        static let medium: CGFloat = 2
    }

    // MARK: - Motion (springs only)

    enum Motion {
        static let snappy: Animation = .spring(duration: 0.25, bounce: 0.0)
        static let smooth: Animation = .spring(duration: 0.35, bounce: 0.0)
        static let bouncy: Animation = .spring(duration: 0.4, bounce: 0.15)
    }
}

// MARK: - View Modifiers

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

// MARK: - Segmented Progress Bar

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

// MARK: - NSColor hex

extension NSColor {
    convenience init?(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        guard hex.count == 6 else { return nil }
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(
            srgbRed: CGFloat((int >> 16) & 0xFF) / 255.0,
            green: CGFloat((int >> 8) & 0xFF) / 255.0,
            blue: CGFloat(int & 0xFF) / 255.0,
            alpha: 1.0
        )
    }
}
```
