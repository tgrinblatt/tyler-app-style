# Annotation & Review System Patterns

## Unified Annotation Types

Use an enum that wraps multiple annotation types (draw boxes, pins, text edits) with shared properties. This keeps the model simple while supporting diverse annotation behaviors.

```swift
enum AnnotationType: Codable, Hashable {
    case drawBox(DrawBoxAnnotation)
    case pin(PinAnnotation)
    case textEdit(TextEditAnnotation)
}

struct Annotation: Identifiable, Codable, Hashable {
    let id: UUID
    var type: AnnotationType
    var colorIndex: Int          // Index into preset color array (0-7) or 8 for custom
    var customColorHex: String?  // Only used when colorIndex == 8
    var noteText: String
    var createdAt: Date
}
```

## Unified Numbering

All annotation types share one number sequence per item, sorted by creation time. This gives users a single, predictable numbering scheme regardless of annotation type.

```swift
var sortedAnnotations: [Annotation] {
    annotations.sorted { $0.createdAt < $1.createdAt }
}

// Display number is just the 1-based index in sorted order
func displayNumber(for annotation: Annotation) -> Int {
    (sortedAnnotations.firstIndex(where: { $0.id == annotation.id }) ?? 0) + 1
}
```

## Manual Reordering

Store annotation order as `[contextID: [annotationID]]` per context (e.g., per slide). Fall back to creation order when no manual order exists.

```swift
// Stored in the model
var annotationOrder: [UUID: [UUID]] = [:]  // slideID -> [annotationID]

func orderedAnnotations(for slideID: UUID) -> [Annotation] {
    if let order = annotationOrder[slideID] {
        return order.compactMap { id in annotations.first(where: { $0.id == id }) }
    }
    return annotations
        .filter { /* belongs to slideID */ }
        .sorted { $0.createdAt < $1.createdAt }
}
```

## Pin Markers (Draggable Numbered Circles)

Pins use `NormalizedPoint` (0-1 range) so positions are resolution-independent. Use `DragGesture` with a local `@State` offset for smooth dragging without model churn during the gesture.

```swift
struct NormalizedPoint: Codable, Hashable {
    var x: Double  // 0.0 = left edge, 1.0 = right edge
    var y: Double  // 0.0 = top edge, 1.0 = bottom edge
}

struct PinMarkerView: View {
    let annotation: Annotation
    let displayNumber: Int
    let isSelected: Bool
    let containerSize: CGSize
    let onDragEnd: (NormalizedPoint) -> Void
    let onTap: () -> Void

    @State private var dragOffset: CGSize = .zero

    var body: some View {
        let pinData = annotation.pinData!
        let baseX = pinData.position.x * containerSize.width
        let baseY = pinData.position.y * containerSize.height

        Circle()
            .fill(resolvedColor(for: annotation.colorIndex, customHex: annotation.customColorHex))
            .frame(width: 28, height: 28)
            .overlay(
                Text("\(displayNumber)")
                    .font(AppTokens.Font.numericSmall)
                    .foregroundStyle(.white)
            )
            .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
            .scaleEffect(isSelected ? 1.15 : 1.0)
            .position(x: baseX + dragOffset.width, y: baseY + dragOffset.height)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation  // Local @State — no model updates during drag
                    }
                    .onEnded { value in
                        let newX = (baseX + value.translation.width) / containerSize.width
                        let newY = (baseY + value.translation.height) / containerSize.height
                        dragOffset = .zero
                        onDragEnd(NormalizedPoint(
                            x: max(0, min(1, newX)),
                            y: max(0, min(1, newY))
                        ))
                    }
            )
            .onTapGesture { onTap() }
            .animation(AppTokens.Motion.snappy, value: isSelected)
    }
}
```

## Properties Popover

Click an annotation in the list to show a popover with note editor, color picker, and delete. Use explicit save buttons (not auto-save bindings) to avoid value-type binding race conditions.

```swift
struct AnnotationPropertiesPopover: View {
    let annotation: Annotation
    let onSave: (String) -> Void
    let onDelete: () -> Void
    let onRecolor: (Int, String?) -> Void
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme

    @State private var localNoteText: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: AppTokens.Spacing.md) {
            // Color picker row
            HStack(spacing: AppTokens.Spacing.xs) {
                ForEach(0..<8, id: \.self) { index in
                    Circle()
                        .fill(presetColor(index))
                        .frame(width: 20, height: 20)
                        .overlay(
                            Circle().strokeBorder(.white.opacity(0.5), lineWidth: annotation.colorIndex == index ? 2 : 0)
                        )
                        .onTapGesture { onRecolor(index, nil) }
                }
                ColorPicker("", selection: customColorBinding)
                    .labelsHidden()
                    .frame(width: 20, height: 20)
            }

            // Note editor
            TextEditor(text: $localNoteText)
                .font(AppTokens.Font.bodySmall)
                .frame(height: 80)
                .scrollContentBackground(.hidden)
                .background(AppTokens.Color.surface(for: colorScheme))
                .clipShape(RoundedRectangle(cornerRadius: AppTokens.Radius.sm))

            // Explicit save buttons
            HStack {
                Button("Cancel") { dismiss() }
                    .buttonStyle(.plain)
                    .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
                Spacer()
                Button("Delete") { onDelete(); dismiss() }
                    .buttonStyle(.plain)
                    .foregroundStyle(AppTokens.Color.destructive)
                Button(annotation.noteText.isEmpty ? "Add Note" : "Save") {
                    onSave(localNoteText)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTokens.Color.accent)
            }
        }
        .padding(AppTokens.Spacing.md)
        .frame(width: 280)
        .onAppear { localNoteText = annotation.noteText }
    }
}
```

## Custom Color Pattern

8 preset colors + 1 custom via `ColorPicker`, stored as a hex string. Resolve via a shared function:

```swift
let presetColors: [Color] = [
    .red, .orange, .yellow, .green, .blue, .purple, .pink, .brown
]

func resolvedColor(for colorIndex: Int, customHex: String?) -> Color {
    if colorIndex == 8, let hex = customHex {
        return Color(nsColor: NSColor(hex: hex) ?? .orange)
    }
    return presetColors[min(colorIndex, presetColors.count - 1)]
}
```

## Recolor After Placement

The color picker serves dual purpose: it sets the color for the **next** annotation AND updates the **currently selected** annotation's color. This reduces clicks and feels natural.

```swift
func selectColor(_ index: Int, customHex: String? = nil) {
    nextColorIndex = index
    nextCustomHex = customHex

    // Also recolor the selected annotation if one exists
    if let selectedID = selectedAnnotationID {
        updateAnnotationColor(id: selectedID, colorIndex: index, customHex: customHex)
    }
}
```

## Tool Mode Mutual Exclusivity

Use boolean flags for tool modes, clearing all others when one activates:

```swift
@State private var isDrawMode = false
@State private var isTextEditMode = false
@State private var isPinMode = false

func activateMode(_ mode: ToolMode) {
    withAnimation(AppTokens.Motion.snappy) {
        isDrawMode = mode == .draw
        isTextEditMode = mode == .textEdit
        isPinMode = mode == .pin
    }
}

enum ToolMode { case draw, textEdit, pin }
```

Tool mode buttons live in the side panel header, keeping the main content area clean:

```swift
// Inside the side panel header
HStack(spacing: AppTokens.Spacing.xs) {
    Text("ANNOTATIONS").appLabel()
    Spacer()
    GlassEffectContainer {
        HStack(spacing: AppTokens.Spacing.xxs) {
            toolButton("rectangle.dashed", mode: .draw, isActive: isDrawMode)
            toolButton("mappin", mode: .pin, isActive: isPinMode)
            toolButton("character.cursor.ibeam", mode: .textEdit, isActive: isTextEditMode)
        }
    }
}
```

## Verdict / Disposition Tags

Enum-based status tags with typed context for each verdict type:

```swift
enum Verdict: String, Codable, CaseIterable {
    case approve = "APPROVE"
    case revise = "REVISE"
    case cut = "CUT"
    case merge = "MERGE"
    case split = "SPLIT"
    case reorder = "REORDER"
}

enum VerdictContext: Codable, Hashable {
    case none
    case freeText(String)           // For REVISE — revision instructions
    case slidePicker(UUID)          // For MERGE — which slide to merge with
    case slideRange(Int, Int)       // For SPLIT — suggested split point
    case positionChange(Int, Int)   // For REORDER — from position, to position
}

struct SlideVerdict: Codable {
    var verdict: Verdict
    var context: VerdictContext
    var noteText: String
}
```

Display verdict tags as colored glass capsules:

```swift
func verdictColor(_ verdict: Verdict) -> Color {
    switch verdict {
    case .approve: return AppTokens.Color.success
    case .revise:  return AppTokens.Color.warning
    case .cut:     return AppTokens.Color.destructive
    case .merge:   return AppTokens.Color.info
    case .split:   return AppTokens.Color.info
    case .reorder: return AppTokens.Color.accent
    }
}

// Verdict tag pill
Text(verdict.rawValue)
    .font(AppTokens.Font.caption)
    .tracking(0.88)
    .foregroundStyle(verdictColor(verdict))
    .padding(.horizontal, AppTokens.Spacing.sm)
    .padding(.vertical, AppTokens.Spacing.xxs)
    .glassEffect(.regular.tint(verdictColor(verdict).opacity(0.15)), in: .capsule)
```

## Visual Hint Overlay for Tool Modes

When a tool mode is active, show a dimmed overlay with centered instruction text. Use `.allowsHitTesting(false)` so taps pass through to the content. Show the hint only when no items of that type exist yet (progressive disclosure).

```swift
// Overlay on the main content area
if isPinMode && pinAnnotations.isEmpty {
    VStack {
        Image(systemName: "mappin.and.ellipse")
            .font(.system(size: 32))
            .foregroundStyle(AppTokens.Color.textTertiary(for: colorScheme))
        Text("Click to place a pin")
            .font(AppTokens.Font.headingSmall)
            .foregroundStyle(AppTokens.Color.textSecondary(for: colorScheme))
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(AppTokens.Color.background(for: colorScheme).opacity(0.5))
    .allowsHitTesting(false)  // Taps pass through to content
}
```
