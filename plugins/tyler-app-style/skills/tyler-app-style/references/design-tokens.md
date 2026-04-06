# Design Tokens — Complete Reference

The full `NothingTokens.swift` file that should be included in every Tyler App Style project.

```swift
// NothingTokens.swift — Tyler App Style Design System
// Nothing palette + Apple Liquid Glass hybrid.
// All views MUST reference these tokens — no hardcoded colors, fonts, or spacing.

import SwiftUI
import AppKit

enum NothingTokens {

    // MARK: - Colors

    enum Color {
        // Core palette
        static let background = SwiftUI.Color(nsColor: NSColor(hex: "0A0A0A")!)
        static let surface = SwiftUI.Color(nsColor: NSColor(hex: "111111")!)
        static let surfaceElevated = SwiftUI.Color(nsColor: NSColor(hex: "1A1A1A")!)
        static let border = SwiftUI.Color(nsColor: NSColor(hex: "222222")!)
        static let borderStrong = SwiftUI.Color(nsColor: NSColor(hex: "333333")!)

        // Text hierarchy
        static let textPrimary = SwiftUI.Color(nsColor: NSColor(hex: "E8E8E8")!)
        static let textDisplay = SwiftUI.Color.white
        static let textSecondary = SwiftUI.Color(nsColor: NSColor(hex: "999999")!)
        static let textTertiary = SwiftUI.Color(nsColor: NSColor(hex: "666666")!)

        // Accent
        static let accent = SwiftUI.Color(nsColor: NSColor(hex: "F47421")!)
        static let accentDim = SwiftUI.Color(nsColor: NSColor(hex: "3D2510")!)
        static let interactive = SwiftUI.Color(nsColor: NSColor(hex: "F47421")!)

        // Status
        static let destructive = SwiftUI.Color(nsColor: NSColor(hex: "D71921")!)
        static let warning = SwiftUI.Color(nsColor: NSColor(hex: "D4A843")!)
        static let success = SwiftUI.Color(nsColor: NSColor(hex: "4A9E5C")!)
        static let redesigned = SwiftUI.Color(nsColor: NSColor(hex: "4A8ED4")!)

        // Diff backgrounds
        static let diffAddedBg = SwiftUI.Color(nsColor: NSColor(hex: "1A2E1A")!)
        static let diffRemovedBg = SwiftUI.Color(nsColor: NSColor(hex: "2E1A1A")!)
        static let diffChangedBg = SwiftUI.Color(nsColor: NSColor(hex: "1A1A2E")!)
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

struct NothingLabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(NothingTokens.Font.label)
            .tracking(0.88)
            .textCase(.uppercase)
            .foregroundStyle(NothingTokens.Color.textSecondary)
    }
}

extension View {
    func nothingLabel() -> some View { modifier(NothingLabelStyle()) }
}

// MARK: - Segmented Progress Bar

struct NothingProgressBar: View {
    let progress: Double
    let segments: Int
    init(progress: Double, segments: Int = 24) {
        self.progress = progress
        self.segments = segments
    }
    var body: some View {
        HStack(spacing: 2) {
            let filled = Int(progress * Double(segments))
            ForEach(0..<segments, id: \.self) { i in
                RoundedRectangle(cornerRadius: 1)
                    .fill(i < filled ? NothingTokens.Color.accent : NothingTokens.Color.borderStrong)
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
