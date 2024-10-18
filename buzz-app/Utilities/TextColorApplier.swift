import Foundation
import PDFKit

struct TextColorApplier {
    var colorIndex = 1
    var maxColorIndex = 5

    mutating func applyColor(text: NSMutableAttributedString, range: NSRange, coloringStyle: ColoringStyle) {
        if coloringStyle == .text {
            let textColorAttribute: [NSAttributedString.Key: Any] = [
                .foregroundColor: NSColor(named: NSColor.Name("Text\(colorIndex)")) ?? NSColor.black // Default to black if color not found
            ]
            text.addAttributes(textColorAttribute, range: range)
            
            // Remove existing highlight attribute if switching to text style
            text.removeAttribute(.backgroundColor, range: range)
        } else if coloringStyle == .highlight {
            // Apply highlight attribute
            let highlightAttribute: [NSAttributedString.Key: Any] = [
                .backgroundColor: NSColor(named: NSColor.Name("Highlight\(colorIndex)")) ?? NSColor.clear // Default to clear if color not found
            ]
            text.addAttributes(highlightAttribute, range: range)
            text.addAttribute(.foregroundColor, value: NSColor.black, range: range)
        }

        nextColor()
    }

    private mutating func nextColor() {
        if colorIndex == maxColorIndex {
            colorIndex = 1
        } else {
            colorIndex += 1
        }
    }
}