import SwiftUI
import AppKit

@Observable
final class AppSettings {
    enum AppearanceMode: String, CaseIterable, Identifiable, Hashable {
        case system, light, dark

        var id: String { rawValue }

        var label: String {
            switch self {
            case .system: return "SYSTEM"
            case .light:  return "LIGHT"
            case .dark:   return "DARK"
            }
        }

        var icon: String {
            switch self {
            case .system: return "circle.lefthalf.filled"
            case .light:  return "sun.max"
            case .dark:   return "moon"
            }
        }

        var preferredColorScheme: ColorScheme? {
            switch self {
            case .system: return nil
            case .light:  return .light
            case .dark:   return .dark
            }
        }
    }

    private static let appearanceKey = "styledemo.appearance"

    var appearance: AppearanceMode {
        didSet {
            UserDefaults.standard.set(appearance.rawValue, forKey: Self.appearanceKey)
        }
    }

    init() {
        let raw = UserDefaults.standard.string(forKey: Self.appearanceKey) ?? AppearanceMode.system.rawValue
        self.appearance = AppearanceMode(rawValue: raw) ?? .system
    }

    /// Resolves `.system` against NSApp's effective appearance so the window
    /// background can flip without waiting for a colorScheme environment update.
    func effectiveIsDark() -> Bool {
        switch appearance {
        case .dark:   return true
        case .light:  return false
        case .system:
            let match = NSApp.effectiveAppearance.bestMatch(from: [.darkAqua, .aqua])
            return match == .darkAqua
        }
    }
}
