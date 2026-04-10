# App Style Demo — Project Context

This folder contains a SwiftUI macOS demo app used to visually refine and stress-test the **Tyler App Style** design system. The demo is a living style guide — it has no real functionality. Every view exists purely to showcase a UI primitive (button, sidebar state, glass pill, color token, font weight) so Tyler can see it rendered on the actual platform and tweak the underlying tokens.

## Purpose

- **Visualize the design system** — every component, state, and token gets a dedicated showcase view.
- **Stress-test Liquid Glass** — see exactly where glass is applied (navigation/chrome) and where it is not (content).
- **Compare sidebar states** — Full Width and Condensed Width, both with frosted glass and traffic-light alignment.
- **Calibrate typography** — Geist, Geist Mono, and Geist Pixel at all weights, against dark and light backgrounds.
- **Provide a reference surface** — when Tyler asks "what does the X button look like?", this app should be the answer.

The demo is deliberately **non-functional**. Menu items navigate between showcase pages, buttons respond visually (hover, press, active state) but perform no work, and "Save" / "Export" buttons just animate. Do not add real data models, persistence, or business logic unless explicitly asked.

## Parent Repo — Tyler App Style

This demo lives inside the [tyler-app-style](https://github.com/tgrinblatt/tyler-app-style) repo. The authoritative design system lives in the parent repo's skill plugin. **Always defer to it** when there is a conflict between this demo and the skill definitions.

Key reference files (relative to this folder's parent):

| Path | Purpose |
|---|---|
| `../plugins/tyler-app-style/skills/tyler-app-style/SKILL.md` | Core skill definition, tokens, view patterns, rules |
| `../plugins/tyler-app-style/skills/tyler-app-style/references/design-tokens.md` | Full `AppTokens.swift` — colors, fonts, spacing, radius, motion |
| `../plugins/tyler-app-style/skills/tyler-app-style/references/glass-patterns.md` | Liquid Glass component patterns |
| `../plugins/tyler-app-style/skills/tyler-app-style/references/layout-patterns.md` | NavigationSplitView, toolbar, sidebar, inspector layouts |
| `../plugins/tyler-app-style/skills/tyler-app-style/references/anti-patterns.md` | What NOT to do — read before adding anything new |
| `../plugins/tyler-app-style/skills/tyler-app-style/references/annotation-patterns.md` | Annotation/review system patterns (only relevant if the demo grows an annotation showcase) |
| `../Design Documents/UI Basics-Tyler-App-Style.pdf` | Tyler's hand-drawn anatomy diagram — the source of truth for sidebar/canvas/inspector structure and sidebar states |

## Design System Quick Reference

If you are about to write code without reading the files above, at minimum know this:

- **Dark-first, light-ready** — `#0A0A0A` (dark) / `#FFFFFF` (light) background. Always pair with `@Environment(\.colorScheme)` and use the `func X(for: ColorScheme)` token pattern.
- **Single accent** — `#E5600A` orange. Only for selected, active, interactive states. Never decorative.
- **Glass on chrome, flat on content** — toolbars, sidebars, buttons, badges, filter pills get `.glassEffect(...)`. Slide images, text, charts, annotations do not.
- **`GlassEffectContainer`** wraps every group of adjacent glass elements. Non-negotiable.
- **Tint opacity ≤ 0.3** on glass, always.
- **Typography** — Geist (sans) for headings/labels, Geist Mono for data/numbers/body, Geist Pixel for decorative moments. All-caps + 0.88 tracking for labels.
- **8pt grid** — `AppTokens.Spacing.xxs/xs/sm/md/lg/xl/xxl/xxxl` (2, 4, 8, 16, 24, 32, 48, 64).
- **Spring animations only** — `Motion.snappy`, `Motion.smooth`, `Motion.bouncy`. No linear, no easeInOut.
- **Corner radius ≤ 16pt** — keep shapes geometric. Use `Radius.sm/md/lg/xl` (4, 8, 12, 16).
- **Title bar fix** — `.toolbarBackgroundVisibility(.hidden, for: .windowToolbar)` + `window.titlebarAppearsTransparent = true` + `window.backgroundColor = <bg token>`.
- **Frosted sidebar** — `.ultraThinMaterial` on sidebar background. No opaque child backgrounds inside the sidebar.

## App Anatomy (from the PDF design document)

Every Tyler App Style app must follow this structural skeleton. The demo should make this anatomy explicit and visible:

```
┌─────────────────────────────────────────────────────────┐
│  ●●●  ⊟   AppName                           [Inspector] │  ← Title bar (transparent)
├──────────┬────────────────────────────────────┬─────────┤
│ [Search] │                                    │         │
│          │                                    │         │
│ ○ Item 1 │         THE CANVAS                 │   THE   │
│ ○ Item 2 │     (main interaction area)        │INSPECTOR│
│ ○ Item 3 │                                    │(optional│
│ ○ Item 4 │                                    │  panel) │
│          │                                    │         │
│ SIDEBAR  │                                    │         │
│(frosted) │                                    │         │
└──────────┴────────────────────────────────────┴─────────┘
```

**Anchor elements** (must appear in every app built with this system):

1. **Window Controls** (traffic lights) — top-left of the sidebar column.
2. **SideBar Toggle glyph** — expands / collapses the sidebar. Positioned in the sidebar column header, right of the traffic lights.
3. **App Title** — displayed prominently in the canvas column header.
4. **Search field** — inside the sidebar, top of the item list.
5. **Menu items** — the primary navigation surface, living in the sidebar body.
6. **Inspector panel** — optional right-side column. Appears for views that need contextual detail.

**Sidebar states** — the sidebar has exactly two valid widths:

- **Full Width** — shows icon + full label + optional secondary metadata.
- **Condensed Width** — icon-only, with labels removed and less-important items potentially dropped.

No other widths. No continuous resize. Transitions between states use `Motion.smooth`.

## Working Style

- **Read before editing.** Before changing a view, read the relevant reference file in the parent repo. The tokens and patterns are the spec — the demo is downstream.
- **Don't invent tokens.** If a value isn't in `AppTokens`, the correct answer is almost always to add it to the parent skill first, then use it here. Flag this to Tyler rather than hardcoding.
- **Ship one showcase at a time.** The demo is organized by showcase view (Buttons, Glass, Typography, Colors, …). Add or refine one view per request unless Tyler asks for a bigger pass.
- **Never add functionality beyond visual feedback.** If a button looks like it should do something, it's enough to animate a state change, show a toast, or log to the console. No file I/O, no network, no persistence.
- **Match dark and light.** Every showcase view must be tested in both color schemes. Use `@Environment(\.colorScheme)` throughout — no hardcoded hex.
- **Preserve the anatomy.** Every top-level layout must include the five anchor elements (traffic lights, sidebar toggle, app title, search, menu). Don't remove them to "simplify" a showcase — the anatomy is the point.
- **Geist fonts.** If the Geist font files are bundled, register them in `Info.plist` and reference them by exact PostScript name. If they are not bundled, use the system monospaced/system fonts as a fallback. Either way, never hardcode `.system(size: 14)` without going through `AppTokens.Font`.

## How to Start

See `Claude Instructions/DemoAppStart.md` for a step-by-step walkthrough of building the demo app from scratch, including project setup, folder structure, AppTokens integration, and implementation of each showcase view.

## Target Platform

- **macOS 26+ (Tahoe)** — Liquid Glass APIs require this.
- **Xcode 26+**
- **Swift 6.0+**
- **SwiftUI only** — no AppKit views except the minimal `NSApplicationDelegateAdaptor` used for the title bar fix.
