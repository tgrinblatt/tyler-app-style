import SwiftUI

struct MenuItemsShowcase: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var pickerValue: String = "Option A"
    @State private var toggleA: Bool = true
    @State private var toggleB: Bool = false
    @State private var segmented: Int = 0

    private let pickerOptions = ["Option A", "Option B", "Option C", "Option D"]

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xl) {
            section("SIDEBAR ROW STATES") {
                HStack(alignment: .top, spacing: AppTokens.Spacing.lg) {
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        Text("FULL WIDTH").appLabel()
                        VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
                            StaticSidebarRow(item: .buttons, isSelected: false, isHovered: false, condensed: false)
                            StaticSidebarRow(item: .buttons, isSelected: false, isHovered: true, condensed: false)
                            StaticSidebarRow(item: .buttons, isSelected: true, isHovered: false, condensed: false)
                            StaticSidebarRow(item: .buttons, isSelected: true, isHovered: true, condensed: false)
                        }
                        .frame(width: 220)
                    }
                    VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                        Text("CONDENSED").appLabel()
                        VStack(alignment: .leading, spacing: AppTokens.Spacing.xs) {
                            StaticSidebarRow(item: .buttons, isSelected: false, isHovered: false, condensed: true)
                            StaticSidebarRow(item: .buttons, isSelected: false, isHovered: true, condensed: true)
                            StaticSidebarRow(item: .buttons, isSelected: true, isHovered: false, condensed: true)
                            StaticSidebarRow(item: .buttons, isSelected: true, isHovered: true, condensed: true)
                        }
                        .frame(width: 48)
                    }
                    Spacer()
                }
            }

            section("CONTEXT MENU") {
                Text("Right-click this area")
                    .font(AppTokens.Font.bodySmall)
                    .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button("Rename") { }
                        Button("Duplicate") { }
                        Divider()
                        Button("Delete", role: .destructive) { }
                    }
            }

            section("DROPDOWN PICKER") {
                Picker("", selection: $pickerValue) {
                    ForEach(pickerOptions, id: \.self) { Text($0).tag($0) }
                }
                .pickerStyle(.menu)
                .labelsHidden()
                .tint(AppTokens.Color.accent)
            }

            section("TOGGLE GROUP") {
                VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
                    Toggle(isOn: $toggleA) {
                        Text("SHOW GRID").appLabel()
                    }
                    .tint(AppTokens.Color.accent)
                    Toggle(isOn: $toggleB) {
                        Text("SNAP TO EDGES").appLabel()
                    }
                    .tint(AppTokens.Color.accent)
                }
            }

            section("SEGMENTED CONTROL") {
                GlassEffectContainer {
                    Picker("", selection: $segmented) {
                        Text("One").tag(0)
                        Text("Two").tag(1)
                        Text("Three").tag(2)
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                }
            }
        }
    }

    @ViewBuilder
    private func section<Content: View>(_ title: String, @ViewBuilder _ content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.sm) {
            Text(title).appLabel()
            GlassSectionCard { content() }
        }
    }
}

private struct StaticSidebarRow: View {
    let item: Showcase
    let isSelected: Bool
    let isHovered: Bool
    let condensed: Bool
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Group {
            if condensed {
                Image(systemName: item.icon)
                    .font(.system(size: 15, weight: .medium))
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                HStack(spacing: AppTokens.Spacing.sm) {
                    Image(systemName: item.icon)
                        .font(.system(size: 13, weight: .medium))
                        .frame(width: 20)
                    Text(stateLabel)
                        .font(AppTokens.Font.headingSmall)
                    Spacer(minLength: 0)
                }
            }
        }
        .foregroundStyle(
            isSelected
                ? AppTokens.Color.textDisplay(for: colorScheme)
                : AppTokens.Color.textSecondary(for: colorScheme)
        )
        .padding(.horizontal, AppTokens.Spacing.md)
        .padding(.vertical, AppTokens.Spacing.sm)
        .background(
            RoundedRectangle(cornerRadius: AppTokens.Radius.md)
                .fill(fillColor)
        )
    }

    private var fillColor: Color {
        if isSelected && isHovered {
            return AppTokens.Color.accent.opacity(0.28)
        } else if isSelected {
            return AppTokens.Color.accent.opacity(0.18)
        } else if isHovered {
            return AppTokens.Color.surface(for: colorScheme).opacity(0.6)
        } else {
            return .clear
        }
    }

    private var stateLabel: String {
        switch (isSelected, isHovered) {
        case (false, false): return "Default"
        case (false, true):  return "Hovered"
        case (true, false):  return "Selected"
        case (true, true):   return "Selected + Hovered"
        }
    }
}
