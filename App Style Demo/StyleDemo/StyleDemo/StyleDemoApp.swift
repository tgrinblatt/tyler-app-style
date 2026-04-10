import SwiftUI
import AppKit

@main
struct StyleDemoApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var settings = AppSettings()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settings)
                .preferredColorScheme(settings.appearance.preferredColorScheme)
                .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
                .frame(minWidth: 1100, minHeight: 720)
        }
        .defaultSize(width: 1440, height: 900)
        .windowStyle(.hiddenTitleBar)

        // Adds the standard "Settings..." item (Cmd+,) to the StyleDemo
        // app menu in the menu bar.
        Settings {
            SettingsPanel(settings: settings)
                .preferredColorScheme(settings.appearance.preferredColorScheme)
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        guard let window = NSApp.windows.first else { return }
        window.titlebarAppearsTransparent = true
        window.backgroundColor = NSColor(hex: "0A0A0A")
        window.isMovableByWindowBackground = true
    }
}
