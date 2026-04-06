# Tyler App Style

A Claude Code skill that teaches Claude how to build macOS SwiftUI apps using **Tyler App Style** — a hybrid design system combining [Nothing Design](https://nothing.tech) dark aesthetics with Apple's [Liquid Glass](https://developer.apple.com/design/human-interface-guidelines/materials#Glass) (macOS 26+).

## Design Philosophy

| Nothing Design | Apple Liquid Glass | Tyler App Style |
|---|---|---|
| Dark `#0A0A0A` background | System materials | Dark background + glass on chrome |
| Monochrome + orange accent | System semantic colors | Custom monochrome palette + `#F47421` orange |
| All-caps labels, monospace data | SF Pro, system text styles | Geist/GeistMono (system monospace fallback) |
| Sharp corners, hairline borders | Rounded, blurred materials | Soft corners (4-16pt) + glass effects |
| No animations | Spring animations | Spring-only animations (snappy/smooth/bouncy) |
| Flat surfaces | Translucent depth | Glass on navigation, flat on content |

## What's Included

```
plugins/tyler-app-style/skills/tyler-app-style/
├── SKILL.md                           # Core skill definition
├── references/
│   ├── design-tokens.md               # Full NothingTokens.swift
│   ├── glass-patterns.md              # Liquid Glass component patterns
│   ├── layout-patterns.md             # NavigationSplitView, toolbars, panels
│   └── anti-patterns.md               # What NOT to do
└── examples/
    └── comparison-app.md              # Complete comparison app example
```

## Installation

Add this skill to your Claude Code project:

```bash
claude mcp add-skill https://github.com/tyler-m3-kc/tyler-app-style
```

Or clone and reference locally:

```bash
git clone https://github.com/tyler-m3-kc/tyler-app-style.git
```

## Key Design Tokens

| Token | Value | Usage |
|---|---|---|
| Background | `#0A0A0A` | App background |
| Surface | `#111111` | Cards, panels |
| Accent | `#F47421` | Selected states, active filters |
| Text Primary | `#E8E8E8` | Body text |
| Text Display | `white` | Headings, selected labels |
| Destructive | `#D71921` | Errors, removals |
| Success | `#4A9E5C` | Additions, confirmed |
| Warning | `#D4A843` | Flags, caution |

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
