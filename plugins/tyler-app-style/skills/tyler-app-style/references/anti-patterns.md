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
- **Never expect a plain-text `ToolbarItem` to render without a glass pill on macOS 26** — toolbar items get auto-glassed. To render the app name as plain text in the toolbar, wrap it in a `ToolbarItemGroup` with `.sharedBackgroundVisibility(.hidden)`. See `glass-patterns.md → Toolbar Auto-Glass`.

## Toolbar

- **Never put the app name and the page name in the same `ToolbarItem`** — they end up in a single combined glass pill, which reads as one title. Split into `.navigation` (app name, no pill) and `.principal` (page name, pill).
- **Never put stat pills, Export buttons, or mode toggles in the window toolbar** — those live in the `CanvasActionBar` below the toolbar. The window toolbar is reserved for identity (app name + page name) and system icons (inspector toggle, etc.).
- **Never build a custom settings button** — no gear in the toolbar, no gear in the sidebar footer. Use the SwiftUI `Settings { }` scene so the standard `AppName → Settings…` (⌘,) item appears in the macOS menu bar automatically. See `layout-patterns.md → Settings`.

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
- **Never rely on Geist being installed system-wide** — always bundle it in `Resources/Fonts/` with `ATSApplicationFontsPath = "Fonts"` in Info.plist. See `design-tokens.md → Font Bundling`.
- **Never declare `static let` NSFont constants without `nonisolated(unsafe)` under Swift 6** — NSFont is not Sendable, so strict concurrency rejects them with *"static property is not concurrency-safe"*. The `nonisolated(unsafe)` prefix is the approved escape for immutable AppKit singletons.

## Spacing

- **Never use arbitrary spacing values** — always use `AppTokens.Spacing.*` (multiples of 8)
- **Never use `.padding()` without a specific value** — the default 16pt padding may not match the grid

## Interactions

- **Never skip `.help()` tooltips on buttons** — all toolbar and glass buttons need tooltips
- **Never forget `.contentShape(Rectangle())`** on tappable rows — ensures the full area is tappable
- **Never skip hover states** — interactive elements should have `.onHover` with visual feedback

## Value-Type Binding (Critical)

- **Never use auto-saving `Binding` derived from value-type parameters in `ForEach`** — when `annotation` is a struct, `Binding<String>(get: { annotation.noteText }, set: { ... updateAnnotation ... })` causes a single-character input bug. Each keystroke triggers a re-render which recreates the binding, resetting the cursor and dropping characters.

  **FIX**: Extract to a separate View struct with `@State` local text + `.onAppear` / `.onChange` sync, or use explicit save buttons (cancel / add note / save) instead of auto-save. The explicit save pattern is preferred because it also prevents accidental edits.

  ```swift
  // WRONG — auto-save binding on value type
  ForEach(annotations) { annotation in
      TextField("Note", text: Binding(
          get: { annotation.noteText },
          set: { model.updateAnnotation(id: annotation.id, noteText: $0) }
      ))
  }

  // CORRECT — extracted view with local @State
  struct NoteEditor: View {
      let annotation: Annotation
      let onSave: (String) -> Void
      @State private var localText = ""
      @Environment(\.dismiss) private var dismiss

      var body: some View {
          VStack {
              TextEditor(text: $localText)
              HStack {
                  Button("Cancel") { dismiss() }
                  Button(annotation.noteText.isEmpty ? "Add Note" : "Save") {
                      onSave(localText)
                      dismiss()
                  }
              }
          }
          .onAppear { localText = annotation.noteText }
      }
  }
  ```
