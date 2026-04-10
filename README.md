# Tyler App Style

A Claude Code skill that teaches Claude how to build macOS SwiftUI apps using **Tyler App Style** — a dark-first, monochrome-with-orange design system built on Apple's [Liquid Glass](https://developer.apple.com/design/human-interface-guidelines/materials#Glass) (macOS 26+). Supports both **dark and light** color schemes.

## Design Philosophy

- **Adaptive surfaces** — dark/light background with glass on chrome
- **Monochrome palette** with a single `#E5600A` orange accent
- **Geist / GeistMono** typography (system monospace fallback)
- **Soft corners** (4–16pt) paired with Liquid Glass effects
- **Spring-only animations** (snappy / smooth / bouncy)
- **Glass on navigation, flat on content**

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
