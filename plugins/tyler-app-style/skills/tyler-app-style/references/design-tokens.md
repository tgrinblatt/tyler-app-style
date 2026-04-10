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
    //
    // Geist, Geist Mono, and Geist Pixel are the authoritative families. Bundle
    // them in Resources/Fonts/ and set `ATSApplicationFontsPath = "Fonts"` in
    // Info.plist (see "Font Bundling" below). SwiftUI silently falls back to
    // SF if a PostScript name is missing, so these tokens never hard-fail on a
    // machine without the fonts — but always ship them.

    enum Font {
        static let displayLarge: SwiftUI.Font  = .custom("Geist-Bold",        size: 42)
        static let displayMedium: SwiftUI.Font = .custom("Geist-Bold",        size: 28)
        static let displaySmall: SwiftUI.Font  = .custom("Geist-SemiBold",    size: 20)
        static let headingLarge: SwiftUI.Font  = .custom("Geist-Medium",      size: 17)
        static let headingSmall: SwiftUI.Font  = .custom("Geist-Medium",      size: 13)
        static let bodyLarge: SwiftUI.Font     = .custom("GeistMono-Regular", size: 15)
        static let bodySmall: SwiftUI.Font     = .custom("GeistMono-Regular", size: 12)
        static let caption: SwiftUI.Font       = .custom("GeistMono-Regular", size: 10)
        static let label: SwiftUI.Font         = .custom("Geist-Medium",      size: 11)
        static let numeric: SwiftUI.Font       = .custom("GeistMono-Bold",    size: 24)
        static let numericSmall: SwiftUI.Font  = .custom("GeistMono-Bold",    size: 14)
    }

    /// Free-form Geist access for views that don't use a semantic token
    /// (e.g. a large numeric display in GeistPixel-Circle at 140pt).
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
            case circle   = "Circle"
            case square   = "Square"
            case triangle = "Triangle"
            case line     = "Line"
            case grid     = "Grid"
            var id: String { rawValue }
        }
    }

    // MARK: - NSFont Equivalents (for AppKit / NSViewRepresentable)

    // Use these when building NSViewRepresentable wrappers or custom AppKit drawing.
    // They mirror the SwiftUI Font tokens above.
}

// IMPORTANT (Swift 6): NSFont is not Sendable, so global static NSFont
// constants must be marked `nonisolated(unsafe)` under strict concurrency.
// Without it, every token below fails to compile with
// "static property is not concurrency-safe because non-'Sendable' type
// 'NSFont' may have shared mutable state".
extension NSFont {
    nonisolated(unsafe) static let appBodyLarge     = NSFont.monospacedSystemFont(ofSize: 15, weight: .regular)
    nonisolated(unsafe) static let appBodySmall     = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
    nonisolated(unsafe) static let appCaption       = NSFont.monospacedSystemFont(ofSize: 10, weight: .regular)
    nonisolated(unsafe) static let appLabel         = NSFont.systemFont(ofSize: 11, weight: .medium)
    nonisolated(unsafe) static let appHeadingLarge  = NSFont.systemFont(ofSize: 17, weight: .medium)
    nonisolated(unsafe) static let appHeadingSmall  = NSFont.systemFont(ofSize: 13, weight: .medium)
    nonisolated(unsafe) static let appNumeric       = NSFont.monospacedSystemFont(ofSize: 24, weight: .bold)
    nonisolated(unsafe) static let appNumericSmall  = NSFont.monospacedSystemFont(ofSize: 14, weight: .bold)
    nonisolated(unsafe) static let appDisplaySmall  = NSFont.systemFont(ofSize: 20, weight: .semibold)
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

## Font Bundling

Every Tyler App Style app must ship the Geist family bundled in the app
binary — never rely on the fonts being installed on the user's machine.

**Required files in `Resources/Fonts/`:**

| File | PostScript instances |
|---|---|
| `Geist[wght].ttf` | `Geist-Thin/ExtraLight/Light/Regular/Medium/SemiBold/Bold/ExtraBold/Black` |
| `Geist-Italic[wght].ttf` | italic counterparts |
| `GeistMono[wght].ttf` | `GeistMono-*` (same weights) |
| `GeistMono-Italic[wght].ttf` | italic counterparts |
| `GeistPixel-Circle.otf` | `GeistPixel-Circle` |
| `GeistPixel-Square.otf` | `GeistPixel-Square` |
| `GeistPixel-Triangle.otf` | `GeistPixel-Triangle` |
| `GeistPixel-Line.otf` | `GeistPixel-Line` |
| `GeistPixel-Grid.otf` | `GeistPixel-Grid` |

**Info.plist key** (non-negotiable — without it the bundled files don't register):

```xml
<key>ATSApplicationFontsPath</key>
<string>Fonts</string>
```

**pbxproj setup:** add `Fonts/` as a **folder reference** (blue folder,
`lastKnownFileType = folder`) inside the Resources group, and include it
in the target's `PBXResourcesBuildPhase`. A folder reference picks up
every file in the directory automatically — no need to register each
`.ttf` / `.otf` individually.

At launch, AppKit reads `ATSApplicationFontsPath`, walks
`MyApp.app/Contents/Resources/Fonts/`, and registers every font file
with CoreText. The PostScript names above then resolve through
`.custom("Geist-Bold", size:)` etc.

## Fonts are OFL

Geist and Geist Pixel ship under the SIL Open Font License. Bundling is
explicitly permitted; no attribution needed in UI, but include the
license text in any open-source release.

