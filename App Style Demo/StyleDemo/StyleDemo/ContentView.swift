import SwiftUI

enum Showcase: String, CaseIterable, Identifiable, Hashable {
    case overview, buttons, menuItems, liquidGlass, typography, colors, motion, inspector

    var id: String { rawValue }

    var title: String {
        switch self {
        case .overview:    return "Overview"
        case .buttons:     return "Buttons"
        case .menuItems:   return "Menu Items"
        case .liquidGlass: return "Liquid Glass"
        case .typography:  return "Typography"
        case .colors:      return "Colors"
        case .motion:      return "Motion"
        case .inspector:   return "Inspector"
        }
    }

    var icon: String {
        switch self {
        case .overview:    return "square.grid.2x2"
        case .buttons:     return "rectangle.roundedtop"
        case .menuItems:   return "list.bullet"
        case .liquidGlass: return "circle.hexagongrid.fill"
        case .typography:  return "textformat"
        case .colors:      return "paintpalette"
        case .motion:      return "waveform.path"
        case .inspector:   return "sidebar.right"
        }
    }

    var section: String {
        switch self {
        case .overview:                              return "START"
        case .buttons, .menuItems, .liquidGlass:     return "COMPONENTS"
        case .typography, .colors, .motion:          return "STYLES"
        case .inspector:                             return "LAYOUT"
        }
    }
}

struct ContentView: View {
    @State private var selected: Showcase = .overview
    @State private var searchText: String = ""
    @State private var inspectorVisible: Bool = false
    @State private var settingsVisible: Bool = false
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    @Environment(\.colorScheme) private var colorScheme
    @Environment(AppSettings.self) private var settings

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView(
                selected: $selected,
                searchText: $searchText,
                onOpenSettings: { settingsVisible = true }
            )
            .navigationSplitViewColumnWidth(min: 72, ideal: 300, max: 360)
        } detail: {
            HStack(spacing: 0) {
                CanvasContainer(title: "StyleDemo", subtitle: selected.title) {
                    showcaseView(for: selected)
                }
                .frame(maxWidth: .infinity)

                if inspectorVisible || selected == .inspector {
                    Divider()
                    InspectorPanel()
                        .frame(width: 300)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .toolbar { canvasToolbar }
            .toolbarBackgroundVisibility(.hidden, for: .windowToolbar)
            .animation(AppTokens.Motion.smooth, value: inspectorVisible)
            .animation(AppTokens.Motion.smooth, value: selected)
        }
        .background(AppTokens.Color.background(for: colorScheme))
        .onAppear { syncWindowBackground() }
        .onChange(of: settings.appearance) { _, _ in syncWindowBackground() }
        .onChange(of: colorScheme) { _, _ in syncWindowBackground() }
        .sheet(isPresented: $settingsVisible) {
            @Bindable var bindable = settings
            SettingsPanel(settings: bindable)
        }
    }

    private func syncWindowBackground() {
        let hex = settings.effectiveIsDark() ? "0A0A0A" : "FFFFFF"
        NSApp.windows.forEach { $0.backgroundColor = NSColor(hex: hex) }
    }

    @ViewBuilder
    private func showcaseView(for showcase: Showcase) -> some View {
        switch showcase {
        case .overview:    OverviewShowcase()
        case .buttons:     ButtonsShowcase()
        case .menuItems:   MenuItemsShowcase()
        case .liquidGlass: LiquidGlassShowcase()
        case .typography:  TypographyShowcase()
        case .colors:      ColorsShowcase()
        case .motion:      MotionShowcase()
        case .inspector:   InspectorShowcase()
        }
    }

    @ToolbarContentBuilder
    private var canvasToolbar: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            GlassEffectContainer {
                HStack(spacing: AppTokens.Spacing.sm) {
                    StatPill(value: "\(Showcase.allCases.count)", label: "SHOWCASES")
                    StatPill(value: "2", label: "SCHEMES")
                    StatPill(value: "1", label: "ACCENT")
                }
            }
        }

        ToolbarItem(placement: .automatic) {
            GlassButton(label: "Export Mock", icon: "square.and.arrow.up") { }
        }

        ToolbarItem(placement: .automatic) {
            Button {
                withAnimation(AppTokens.Motion.smooth) { inspectorVisible.toggle() }
            } label: {
                Image(systemName: "sidebar.trailing")
                    .symbolVariant(inspectorVisible ? .none : .slash)
            }
            .help("Toggle Inspector")
        }
    }
}
