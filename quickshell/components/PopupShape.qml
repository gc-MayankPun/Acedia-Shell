import QtQuick
import "../../config" as Config

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

    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
    onAttachedEdgeChanged: requestPaint()
    onColorChanged: requestPaint()
    onFlareWidthChanged: requestPaint()
    onFlareHeightChanged: requestPaint()

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
 
        switch (root.attachedEdge) {
            case "left": {
                ctx.moveTo(0, 0)
                ctx.quadraticCurveTo(0, fh, fw, fh)    
                ctx.lineTo(w - r, fh)
                ctx.arcTo(w, fh, w, fh + r, r)    
                ctx.lineTo(w, h - fh - r)
                ctx.arcTo(w, h - fh, w - r, h - fh, r)    
                ctx.lineTo(fw, h - fh)
                ctx.quadraticCurveTo(0, h - fh, 0, h)     
                ctx.closePath()
                break
            }

            case "right": {
                ctx.moveTo(w, 0)
                ctx.quadraticCurveTo(w, fh, w - fw, fh)   
                ctx.lineTo(r, fh)
                ctx.arcTo(0, fh, 0, fh + r, r)          
                ctx.lineTo(0, h - fh - r)
                ctx.arcTo(0, h - fh, r, h - fh, r)     
                ctx.lineTo(w - fw, h - fh)
                ctx.quadraticCurveTo(w, h - fh, w, h)    
                ctx.closePath()
                break
            }

            case "top": {
                ctx.moveTo(0, 0)
                ctx.quadraticCurveTo(fw, 0, fw, fh)      
                ctx.lineTo(fw, h - r)
                ctx.arcTo(fw, h, fw + r, h, r)          
                ctx.lineTo(w - fw - r, h)
                ctx.arcTo(w - fw, h, w - fw, h - r, r)    
                ctx.lineTo(w - fw, fh)
                ctx.quadraticCurveTo(w - fw, 0, w, 0)     
                ctx.closePath()
                break
            }

            case "bottom": {
                ctx.moveTo(0, h)
                ctx.quadraticCurveTo(fw, h, fw, h - fh)    
                ctx.lineTo(fw, r)
                ctx.arcTo(fw, 0, fw + r, 0, r)  
                ctx.lineTo(w - fw - r, 0)
                ctx.arcTo(w - fw, 0, w - fw, r, r)      
                ctx.lineTo(w - fw, h - fh)
                ctx.quadraticCurveTo(w - fw, h, w, h)    
                ctx.closePath()
                break
            }

            case "bottom-right": {
                ctx.moveTo(fw + r, fh) 
                ctx.lineTo(w - fw, fh) 
                ctx.quadraticCurveTo(w, fh, w, 0) 
                ctx.lineTo(w, h) 
                ctx.lineTo(0, h) 
                ctx.quadraticCurveTo(fw, h, fw, h - fh) 
                ctx.lineTo(fw, fh + r) 
                ctx.arcTo(fw, fh, fw + r, fh, r)
                ctx.closePath()
                break
            }

            case "top-left": {
                ctx.moveTo(w - fw - r, h - fh)
                ctx.lineTo(fw, h - fh)
                ctx.quadraticCurveTo(0, h - fh, 0, h)
                ctx.lineTo(0, 0)
                ctx.lineTo(w, 0)
                ctx.quadraticCurveTo(w - fw, 0, w - fw, fh)
                ctx.lineTo(w - fw, h - fh - r)
                ctx.arcTo(w - fw, h - fh, w - fw - r, h - fh, r)
                ctx.closePath()
                break
            }

            case "top-right": {
                ctx.moveTo(fw + r, fh)
                ctx.moveTo(fw + r, h - fh)
                ctx.lineTo(w - fw, h - fh)
                ctx.quadraticCurveTo(w, h - fh, w, h)
                ctx.lineTo(w, 0)
                ctx.lineTo(0, 0)
                ctx.quadraticCurveTo(fw, 0, fw, fh)
                ctx.lineTo(fw, h - fh - r)
                ctx.arcTo(fw, h - fh, fw + r, h - fh, r)
                ctx.closePath()
                break
            }

            case "bottom-left": {
                ctx.moveTo(w - fw - r, fh)
                ctx.lineTo(fw, fh)
                ctx.quadraticCurveTo(0, fh, 0, 0)
                ctx.lineTo(0, h)
                ctx.lineTo(w, h)
                ctx.quadraticCurveTo(w - fw, h, w - fw, h - fh)
                ctx.lineTo(w - fw, fh + r)
                ctx.arcTo(w - fw, fh, w - fw - r, fh, r)
                ctx.closePath()
                break
            }
        }

        ctx.fill()
    }
}