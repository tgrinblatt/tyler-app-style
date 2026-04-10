// AppTokens.swift — Tyler App Style Design System
// Nothing palette + Apple Liquid Glass hybrid.
// All views MUST reference these tokens — no hardcoded colors, fonts, or spacing.

import SwiftUI
import AppKit

enum AppTokens {

    // MARK: - Colors (ColorScheme-adaptive)

    enum Color {
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

        static let accent = SwiftUI.Color(nsColor: NSColor(hex: "E5600A")!)
        static func accentDim(for scheme: ColorScheme) -> SwiftUI.Color {
            scheme == .dark
                ? SwiftUI.Color(nsColor: NSColor(hex: "3D2510")!)
                : SwiftUI.Color(nsColor: NSColor(hex: "FFF0E6")!)
        }
        static let interactive = SwiftUI.Color(nsColor: NSColor(hex: "E5600A")!)

        static let destructive = SwiftUI.Color(nsColor: NSColor(hex: "CC1018")!)
        static let warning = SwiftUI.Color(nsColor: NSColor(hex: "B8912E")!)
        static let success = SwiftUI.Color(nsColor: NSColor(hex: "2D8A3E")!)
        static let info = SwiftUI.Color(nsColor: NSColor(hex: "2E6FBA")!)

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
    //
    // Geist / Geist Mono / Geist Pixel are expected to be available — either
    // bundled via Resources/Fonts or installed system-wide. SwiftUI silently
    // falls back to SF when a PostScript name is missing, so these never
    // hard-fail.

    enum Font {
        static let displayLarge: SwiftUI.Font  = .custom("Geist-Bold",       size: 42)
        static let displayMedium: SwiftUI.Font = .custom("Geist-Bold",       size: 28)
        static let displaySmall: SwiftUI.Font  = .custom("Geist-SemiBold",   size: 20)
        static let headingLarge: SwiftUI.Font  = .custom("Geist-Medium",     size: 17)
        static let headingSmall: SwiftUI.Font  = .custom("Geist-Medium",     size: 13)
        static let bodyLarge: SwiftUI.Font     = .custom("GeistMono-Regular", size: 15)
        static let bodySmall: SwiftUI.Font     = .custom("GeistMono-Regular", size: 12)
        static let caption: SwiftUI.Font       = .custom("GeistMono-Regular", size: 10)
        static let label: SwiftUI.Font         = .custom("Geist-Medium",     size: 11)
        static let numeric: SwiftUI.Font       = .custom("GeistMono-Bold",    size: 24)
        static let numericSmall: SwiftUI.Font  = .custom("GeistMono-Bold",    size: 14)
    }

    /// Free-form Geist access for showcases that don't use semantic tokens
    /// (e.g. the Stopwatch display uses GeistPixel-Circle at 140pt).
    enum FontFamily {
        static func geist(_ weight: String = "Regular", size: CGFloat) -> SwiftUI.Font {
            .custom("Geist-\(weight)", size: size)
        }
        static func geistMono(_ weight: String = "Regular", size: CGFloat) -> SwiftUI.Font {
            .custom("GeistMono-\(weight)", size: size)
        }
        static func geistPixel(_ variant: PixelVariant, size: CGFloat) -> SwiftUI.Font {
            .custom("GeistPixel-\(variant.rawValue)", size: size)
        }

        enum PixelVariant: String, CaseIterable, Identifiable {
            case circle = "Circle"
            case square = "Square"
            case triangle = "Triangle"
            case line = "Line"
            case grid = "Grid"
            var id: String { rawValue }
            var label: String { rawValue.uppercased() }
        }
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

    enum Radius {
        static let sm: CGFloat = 4
        static let md: CGFloat = 8
        static let lg: CGFloat = 12
        static let xl: CGFloat = 16
    }

    enum Border {
        static let hairline: CGFloat = 0.5
        static let thin: CGFloat = 1
        static let medium: CGFloat = 2
    }

    enum Motion {
        static let snappy: Animation = .spring(duration: 0.25, bounce: 0.0)
        static let smooth: Animation = .spring(duration: 0.35, bounce: 0.0)
        static let bouncy: Animation = .spring(duration: 0.4, bounce: 0.15)
    }
}

// MARK: - NSFont Equivalents (for AppKit / NSViewRepresentable)

extension NSFont {
    nonisolated(unsafe) static let appBodyLarge = NSFont.monospacedSystemFont(ofSize: 15, weight: .regular)
    nonisolated(unsafe) static let appBodySmall = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
    nonisolated(unsafe) static let appCaption = NSFont.monospacedSystemFont(ofSize: 10, weight: .regular)
    nonisolated(unsafe) static let appLabel = NSFont.systemFont(ofSize: 11, weight: .medium)
    nonisolated(unsafe) static let appHeadingLarge = NSFont.systemFont(ofSize: 17, weight: .medium)
    nonisolated(unsafe) static let appHeadingSmall = NSFont.systemFont(ofSize: 13, weight: .medium)
    nonisolated(unsafe) static let appNumeric = NSFont.monospacedSystemFont(ofSize: 24, weight: .bold)
    nonisolated(unsafe) static let appNumericSmall = NSFont.monospacedSystemFont(ofSize: 14, weight: .bold)
    nonisolated(unsafe) static let appDisplaySmall = NSFont.systemFont(ofSize: 20, weight: .semibold)
}
