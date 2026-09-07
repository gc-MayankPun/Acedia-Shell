import QtQuick
import "../../config" as Config

// Draws a popup background that "melts" into whichever edge(s) it's attached to.
Canvas {
    id: root

    property string attachedEdge: "top"
    property color color: Config.Theme.background
    
    // Normal corner radius for the edges away from the notch
    property int radius: Config.Theme.cornerRadius
    
    // Custom dimensions for the outward "melt" (concave corners)
    // Increase flareHeight to make the corners "higher" / stretch further
    property int flareWidth: Config.Theme.cornerRadius
    property int flareHeight: Config.Theme.cornerRadius

    onWidthChanged:        requestPaint()
    onHeightChanged:       requestPaint()
    onAttachedEdgeChanged: requestPaint()
    onColorChanged:        requestPaint()
    onFlareWidthChanged:   requestPaint()
    onFlareHeightChanged:  requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()

        var w = width
        var h = height
        var r = radius
        var fw = flareWidth
        var fh = flareHeight

        ctx.beginPath()
        ctx.fillStyle = root.color

        // We use quadraticCurveTo(cpx, cpy, x, y) for the flares to allow
        // asymmetric stretching (making them higher/wider than a perfect circle).
        switch (root.attachedEdge) {

        case "left":
            // Body inset by fw on the Left. Flare stretches vertically by fh.
            ctx.moveTo(0, 0)
            ctx.quadraticCurveTo(0, fh, fw, fh)       // outward flare top-left
            ctx.lineTo(w - r, fh)
            ctx.arcTo(w, fh, w, fh + r, r)            // normal top-right
            ctx.lineTo(w, h - fh - r)
            ctx.arcTo(w, h - fh, w - r, h - fh, r)    // normal bottom-right
            ctx.lineTo(fw, h - fh)
            ctx.quadraticCurveTo(0, h - fh, 0, h)     // outward flare bottom-left
            ctx.closePath()
            break

        case "right":
            // Body inset by fw on the Right. Flare stretches vertically by fh.
            ctx.moveTo(w, 0)
            ctx.quadraticCurveTo(w, fh, w - fw, fh)   // outward flare top-right
            ctx.lineTo(r, fh)
            ctx.arcTo(0, fh, 0, fh + r, r)            // normal top-left
            ctx.lineTo(0, h - fh - r)
            ctx.arcTo(0, h - fh, r, h - fh, r)        // normal bottom-left
            ctx.lineTo(w - fw, h - fh)
            ctx.quadraticCurveTo(w, h - fh, w, h)     // outward flare bottom-right
            ctx.closePath()
            break

        case "top":
            // Body inset by fw on Left/Right. Flare stretches horizontally by fw, vertically by fh.
            ctx.moveTo(0, 0)
            ctx.quadraticCurveTo(fw, 0, fw, fh)       // outward flare top-left
            ctx.lineTo(fw, h - r)
            ctx.arcTo(fw, h, fw + r, h, r)            // normal bottom-left
            ctx.lineTo(w - fw - r, h)
            ctx.arcTo(w - fw, h, w - fw, h - r, r)    // normal bottom-right
            ctx.lineTo(w - fw, fh)
            ctx.quadraticCurveTo(w - fw, 0, w, 0)     // outward flare top-right
            ctx.closePath()
            break

        case "bottom":
            // Body inset by fw on Left/Right. Flare stretches horizontally by fw, vertically by fh.
            ctx.moveTo(0, h)
            ctx.quadraticCurveTo(fw, h, fw, h - fh)   // outward flare bottom-left
            ctx.lineTo(fw, r)
            ctx.arcTo(fw, 0, fw + r, 0, r)            // normal top-left
            ctx.lineTo(w - fw - r, 0)
            ctx.arcTo(w - fw, 0, w - fw, r, r)        // normal top-right
            ctx.lineTo(w - fw, h - fh)
            ctx.quadraticCurveTo(w - fw, h, w, h)     // outward flare bottom-right
            ctx.closePath()
            break

        case "bottom-right":
            // Popup sits in the bottom-right screen corner.
            // Canvas: (popupWidth + fw) × (popupHeight + fh)
            //
            // Body top edge at y=fh, body left edge at x=fw.
            // Right and bottom edges are flush with screen borders.
            //
            // fw pixels on LEFT  → bottom-left flare zone
            // fh pixels on TOP   → top-right flare zone
            //
            // Flares:
            //   top-right:   concave melt into right border
            //   bottom-left: concave melt into bottom border
            //   top-left:    normal convex rounded corner
            //   bottom-right: square — both border strips physically cover it
            //
            // Content safe zone: x ≥ fw, y ≥ fh  (margins handle both flare corners)

            // 1. Start top edge just after top-left radius
            ctx.moveTo(fw + r, fh)
            // 2. Top edge rightward to the flare start
            ctx.lineTo(w - fw, fh)
            // 3. Top-right flare: concave melt into the right border
            ctx.quadraticCurveTo(w, fh, w, 0)
            // 4. Right edge straight down (flush with right screen border)
            ctx.lineTo(w, h)
            // 5. Bottom edge straight left (flush with bottom screen border)
            ctx.lineTo(0, h)
            // 6. Bottom-left flare: concave melt into the bottom border
            ctx.quadraticCurveTo(fw, h, fw, h - fh)
            // 7. Left edge straight up to the top-left corner
            ctx.lineTo(fw, fh + r)
            // 8. Top-left: standard convex rounded corner
            ctx.arcTo(fw, fh, fw + r, fh, r)
            ctx.closePath()
            break

        case "top-left":
            // Exact 180° opposite of "bottom-right".
            //
            // Normal corner:
            //   top-right
            //
            // Melted corners:
            //   top-left
            //   bottom-right
            //
            // Attached to:
            //   top + left

            // 1. Start after the normal top-right corner
            ctx.moveTo(w - fw - r, h - fh)

            // 2. Bottom edge toward the bottom-left melt
            ctx.lineTo(fw, h - fh)

            // 3. Bottom-left melt
            ctx.quadraticCurveTo(0, h - fh, 0, h)

            // 4. Left edge, flush with screen
            ctx.lineTo(0, 0)

            // 5. Top edge, flush with screen
            ctx.lineTo(w, 0)

            // 6. Top-right melt
            ctx.quadraticCurveTo(w - fw, 0, w - fw, fh)

            // 7. Right edge toward normal top-right corner
            ctx.lineTo(w - fw, h - fh - r)

            // 8. Normal top-right rounded corner
            ctx.arcTo(w - fw, h - fh, w - fw - r, h - fh, r)

            ctx.closePath()
            break

        case "top-right":
            // Top + Right attached.
            //
            // Square corner (flush, hidden by both border strips): top-right
            // Melts:
            //   top-left     — top is attached, left isn't
            //   bottom-right — right is attached, bottom isn't
            // Normal corner:
            //   bottom-left

            // 1. Start after top-right square corner, along the flush top edge
            ctx.moveTo(fw + r, fh)
            // Wait — see note below; actually starts at bottom, mirroring bottom-right's moveTo
            ctx.moveTo(fw + r, h - fh)

            // 2. Bottom edge (inset by fh) toward bottom-right melt
            ctx.lineTo(w - fw, h - fh)

            // 3. Bottom-right melt
            ctx.quadraticCurveTo(w, h - fh, w, h)

            // 4. Right edge straight up, flush with screen
            ctx.lineTo(w, 0)

            // 5. Top edge straight left, flush with screen
            ctx.lineTo(0, 0)

            // 6. Top-left melt
            ctx.quadraticCurveTo(fw, 0, fw, fh)

            // 7. Left edge (inset by fw) down toward normal bottom-left corner
            ctx.lineTo(fw, h - fh - r)

            // 8. Normal bottom-left corner
            ctx.arcTo(fw, h - fh, fw + r, h - fh, r)

            ctx.closePath()
            break

        case "bottom-left":
            // Bottom + Left attached.
            //
            // Square corner (flush, hidden by both border strips): bottom-left
            // Melts:
            //   top-left     — left is attached, top isn't
            //   bottom-right — bottom is attached, right isn't
            // Normal corner:
            //   top-right

            // 1. Start before normal top-right corner
            ctx.moveTo(w - fw - r, fh)

            // 2. Top edge (inset by fh — top not attached) toward top-left melt
            ctx.lineTo(fw, fh)

            // 3. Top-left melt
            ctx.quadraticCurveTo(0, fh, 0, 0)

            // 4. Left edge, flush with screen (left attached)
            ctx.lineTo(0, h)

            // 5. Bottom edge, flush with screen (bottom attached)
            ctx.lineTo(w, h)

            // 6. Bottom-right melt
            ctx.quadraticCurveTo(w - fw, h, w - fw, h - fh)

            // 7. Right edge (inset by fw) up toward normal top-right corner
            ctx.lineTo(w - fw, fh + r)

            // 8. Normal top-right corner
            ctx.arcTo(w - fw, fh, w - fw - r, fh, r)

            ctx.closePath()
            break
        }

        ctx.fill()
    }
}