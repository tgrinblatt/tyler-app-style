# Tyler App Style — Live Reference Demo

This branch (`style-demo`) is **not** part of the skill plugin on `main`. It's a standalone SwiftUI macOS app — `StyleDemo` — that renders every primitive in the design system as a live, interactive reference surface. Use it to visually refine tokens, components, and Liquid Glass usage before rolling changes back into the skill on `main`.

## What's here

- **`App Style Demo/StyleDemo/`** — the Xcode project. Open `StyleDemo.xcodeproj`, run on macOS 26+, and cycle through the sidebar showcases.
- **`App Style Demo/CLAUDE.md`** — project context and working rules for Claude when iterating on the demo.
- **`App Style Demo/Claude Instructions/DemoAppStart.md`** — the original build instructions.

## Showcases

Overview (live anatomy) · Buttons · Menu Items · Liquid Glass (glass-vs-content split) · Typography · Colors · Motion · Inspector

## Relationship to `main`

The authoritative design system lives on `main` under `plugins/tyler-app-style/skills/tyler-app-style/`. When the demo surfaces a gap or a token that needs to change, update the skill on `main` first, then propagate to the demo on this branch. The demo is downstream.

## Requirements

- macOS 26+ (Tahoe) — Liquid Glass APIs (`.glassEffect`, `GlassEffectContainer`, `.buttonStyle(.glass)`)
- Xcode 26+
- Swift 6.0+
