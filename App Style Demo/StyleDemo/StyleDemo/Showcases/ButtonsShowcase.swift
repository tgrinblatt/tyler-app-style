import SwiftUI

struct ButtonsShowcase: View {
    @Environment(\.colorScheme) private var colorScheme
    @State private var filterSelection: DemoFilter = .all
    @State private var symbolSlashed: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.xl) {
            section("PRIMARY GLASS BUTTONS") {
                GlassEffectContainer {
                    HStack(spacing: AppTokens.Spacing.sm) {
                        GlassButton(label: "Default", icon: "sparkles") { }
                        GlassButton(
                            label: "Active",
                            icon: "checkmark",
                            isActive: true,
                            tint: AppTokens.Color.accent.opacity(0.25)
                        ) { }
                        GlassButton(label: "Disabled", icon: "xmark") { }
                            .disabled(true)
                            .opacity(0.5)
                    }
                }
            }

            section("ICON-ONLY GLASS BUTTONS") {
                GlassEffectContainer {
                    HStack(spacing: AppTokens.Spacing.sm) {
                        iconButton("plus")
                        iconButton("pencil")
                        iconButton("trash")
                        iconButton("square.and.arrow.up")
                    }
                }
            }

            section("DESTRUCTIVE") {
                GlassEffectContainer {
                    HStack(spacing: AppTokens.Spacing.sm) {
                        GlassButton(
                            label: "Delete",
                            icon: "trash",
                            isActive: true,
                            tint: AppTokens.Color.destructive.opacity(0.2)
                        ) { }
                    }
                }
            }

            section("FILTER PILLS") {
                GlassFilterBar(
                    options: DemoFilter.allCases,
                    selection: $filterSelection
                )
            }

            section("STAT PILLS") {
                GlassEffectContainer {
                    HStack(spacing: AppTokens.Spacing.sm) {
                        StatPill(value: "12", label: "SLIDES")
                        StatPill(value: "3", label: "FLAGGED")
                        StatPill(value: "8/12", label: "REVIEWED")
                    }
                }
            }

            section("CONNECTION BADGES") {
                GlassEffectContainer {
                    HStack(spacing: AppTokens.Spacing.sm) {
                        ConnectionBadge(label: "Connected", color: AppTokens.Color.success)
                        ConnectionBadge(label: "Pending", color: AppTokens.Color.warning)
                        ConnectionBadge(label: "Failed", color: AppTokens.Color.destructive)
                        ConnectionBadge(label: "Info", color: AppTokens.Color.info)
                    }
                }
            }

            section("TOOLBAR ICON") {
                HStack(spacing: AppTokens.Spacing.lg) {
                    VStack(spacing: AppTokens.Spacing.xs) {
                        Image(systemName: "sidebar.trailing")
                            .font(.system(size: 18))
                            .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
                        Text("default").font(AppTokens.Font.caption)
                            .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
                    }
                    VStack(spacing: AppTokens.Spacing.xs) {
                        Image(systemName: "sidebar.trailing")
                            .symbolVariant(.slash)
                            .font(.system(size: 18))
                            .foregroundStyle(AppTokens.Color.textPrimary(for: colorScheme))
                        Text(".slash").font(AppTokens.Font.caption)
                            .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
                    }
                    Button {
                        withAnimation(AppTokens.Motion.snappy) { symbolSlashed.toggle() }
                    } label: {
                        Image(systemName: "sidebar.trailing")
                            .symbolVariant(symbolSlashed ? .slash : .none)
                            .font(.system(size: 18))
                    }
                    .buttonStyle(.glass)
                    .help("Toggle slash")
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

    private func iconButton(_ name: String) -> some View {
        Button { } label: {
            Image(systemName: name)
                .font(.system(size: 13, weight: .medium))
                .frame(width: 28, height: 28)
        }
        .buttonStyle(.glass)
        .help(name)
    }
}

enum DemoFilter: String, CaseIterable, Hashable, CustomStringConvertible {
    case all, added, removed, changed
    var description: String { rawValue }
}
