# Anti-Patterns — What NOT to Do

## Color

- **Never hardcode hex strings in views** — always use `AppTokens.Color.*`
- **Never use system semantic colors** (`.primary`, `.secondary`, `Color(.systemBackground)`) — the palette is custom
- **Never use bright/saturated backgrounds** — even status colors are used as text color only, with dark tinted backgrounds (`diffAddedBg`, etc.)
- **Never apply color to large surface areas** — color is for text, borders, and small indicators

## Glass

- **Never apply `.glassEffect()` to content** — slide images, text diffs, charts, annotation overlays are content, not chrome
- **Never put glass elements outside `GlassEffectContainer`** when they're adjacent — causes visual artifacts
- **Never use glass tint opacity > 0.3** — glass should be barely visible, not colored
- **Never use `.background(.regularMaterial)` or `.background(.ultraThinMaterial)`** on content areas — materials are for chrome only (sidebar is chrome, so `.ultraThinMaterial` is correct there)
- **Never use `rotationEffect` on glass views** — causes shape morphing bugs (use UIKit bridge if needed)

## Title Bar

- **Never use `.windowToolbarStyle(.unified)` without `.toolbarBackgroundVisibility(.hidden, for: .windowToolbar)`** — causes a grey/black title bar that clashes with the custom background
- **Never forget `window.titlebarAppearsTransparent = true`** — without it the title bar area will have a visible seam
- **Never forget to set `window.backgroundColor`** to match your background token — otherwise the title bar area will flash the wrong color

## Sidebar

- **Never override sidebar background with opaque colors** when using `.ultraThinMaterial` — defeats the frosted glass effect. Child views inside the sidebar should use `.clear` or no background
- **Never use solid `.background(AppTokens.Color.background)` on sidebar child views** — the material needs to show through

## Animation

- **Never use `withAnimation(.easeIn)` or `.animation(.linear)`** — always use spring
- **Never animate without `withAnimation`** — state changes that affect layout should always be animated
- **Never use `DispatchQueue.main.asyncAfter` for animation delays** — use `.delay()` on the animation

## Layout

- **Never use `HSplitView`** when `NavigationSplitView` is available — the floating sidebar is a core design element
- **Never use per-item `GeometryReader` in scroll views** — causes 60fps state update loops
- **Never put `NSImage(contentsOf:)` in view bodies** — load asynchronously
- **Never use corners > 16pt** — keeps things geometric, not bubbly

## Typography

- **Never use `.font(.body)` or `.font(.headline)`** — always use `AppTokens.Font.*`
- **Never use lowercase for labels/section headers** — always ALL-CAPS with 0.88 tracking via `.appLabel()`
- **Never use sans-serif for data/numbers** — always monospace (`bodySmall`, `numericSmall`, etc.)
- **Never use monospace for headings** — always sans-serif (`displaySmall`, `headingSmall`, etc.)

## Spacing

- **Never use arbitrary spacing values** — always use `AppTokens.Spacing.*` (multiples of 8)
- **Never use `.padding()` without a specific value** — the default 16pt padding may not match the grid

## Interactions

- **Never skip `.help()` tooltips on buttons** — all toolbar and glass buttons need tooltips
- **Never forget `.contentShape(Rectangle())`** on tappable rows — ensures the full area is tappable
- **Never skip hover states** — interactive elements should have `.onHover` with visual feedback
