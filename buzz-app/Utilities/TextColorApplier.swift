//
//  RandomColor.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 17/10/24.
//

import Foundation
import PDFKit

struct TextColorApplier {
    var colorIndex = 1
    var maxColorIndex = 5

    mutating func applyColor(text: NSMutableAttributedString, range: NSRange, coloringStyle: ColoringStyle) {
        switch coloringStyle {
        case .highlight:
            let highlightAttribute: [NSAttributedString.Key: Any] = [
                .backgroundColor: NSColor(named: NSColor.Name("Highlight\(colorIndex)"))
            ]

            text.addAttributes(highlightAttribute, range: range)
        case .text:
            text.addAttribute(.foregroundColor, value: NSColor(named: NSColor.Name("Text\(colorIndex)")), range: range)
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
