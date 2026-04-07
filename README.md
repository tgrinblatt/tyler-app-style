# Tyler App Style

A Claude Code skill that teaches Claude how to build macOS SwiftUI apps using **Tyler App Style** — a hybrid design system combining [Nothing Design](https://nothing.tech) dark aesthetics with Apple's [Liquid Glass](https://developer.apple.com/design/human-interface-guidelines/materials#Glass) (macOS 26+). Supports both **dark and light** color schemes.

## Design Philosophy

| Nothing Design | Apple Liquid Glass | Tyler App Style |
|---|---|---|
| Dark `#0A0A0A` background | System materials | Dark/light adaptive background + glass on chrome |
| Monochrome + orange accent | System semantic colors | Custom monochrome palette + `#E5600A` orange |
| All-caps labels, monospace data | SF Pro, system text styles | Geist/GeistMono (system monospace fallback) |
| Sharp corners, hairline borders | Rounded, blurred materials | Soft corners (4-16pt) + glass effects |
| No animations | Spring animations | Spring-only animations (snappy/smooth/bouncy) |
| Flat surfaces | Translucent depth | Glass on navigation, flat on content |

## What's Included

```
plugins/tyler-app-style/skills/tyler-app-style/
├── SKILL.md                           # Core skill definition
├── references/
│   ├── design-tokens.md               # Full AppTokens.swift with dark/light ColorScheme
│   ├── glass-patterns.md              # Liquid Glass + frosted sidebar patterns
│   ├── layout-patterns.md             # NavigationSplitView, title bar fix, toolbars, panels
│   └── anti-patterns.md               # What NOT to do
└── examples/
    └── comparison-app.md              # Complete comparison app example (v2 architecture)
```

## Installation

Add this skill to your Claude Code project:

```bash
claude mcp add-skill https://github.com/tgrinblatt/tyler-app-style
```

Or clone and reference locally:

```bash
git clone https://github.com/tgrinblatt/tyler-app-style.git
```

## Key Design Tokens (Dark / Light)

| Token | Dark | Light | Usage |
|---|---|---|---|
| Background | `#0A0A0A` | `#FFFFFF` | App background |
| Surface | `#111111` | `#F5F5F5` | Cards, panels |
| Accent | `#E5600A` | `#E5600A` | Selected states, active filters |
| Text Primary | `#E8E8E8` | `#1A1A1A` | Body text |
| Text Display | `white` | `black` | Headings, selected labels |
| Destructive | `#CC1018` | `#CC1018` | Errors, removals |
| Success | `#2D8A3E` | `#2D8A3E` | Additions, confirmed |
| Warning | `#B8912E` | `#B8912E` | Flags, caution |
| Info | `#2E6FBA` | `#2E6FBA` | Informational |

## Key Patterns

- **Glass on chrome**: Toolbars, sidebars, buttons, badges, filters
- **Title bar fix**: `.toolbarBackgroundVisibility(.hidden, for: .windowToolbar)` + `titlebarAppearsTransparent`
- **Frosted glass sidebar**: `.ultraThinMaterial` background on sidebar content
- **Collapsible inspector panel**: Right-side notes/inspector with HStack toggle
- **ColorScheme-adaptive colors**: `func color(for scheme: ColorScheme)` pattern

## Glass Rules

- Glass on **navigation** (toolbars, sidebars, buttons, badges, filters)
- Never glass on **content** (images, text, charts, annotations)
- Always wrap adjacent glass in `GlassEffectContainer`
- Tint opacity never exceeds 0.3
- Use `.buttonStyle(.glass)` for all toolbar buttons

## Requirements

- macOS 26+ (Tahoe)
- Xcode 26+
- Swift 6.0+

## License

MIT
