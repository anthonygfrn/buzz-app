//
//  PDFDocumentEntitiy.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 29/10/24.
//

import Foundation

struct PDFDocumentEntity {
    let rawText: String
    let attributedText: NSAttributedString
}

enum SegmentColoringMode {
    case line
    case paragraph
    case punctuation
    case sentence
}

enum ColoringStyle {
    case text
    case highlight
}

enum FontSizePicker: String, CaseIterable {
    case normal = "Normal"
    case large = "Large"
    case extraLarge = "Extra Large"
}

enum FontWeightPicker: String, CaseIterable {
    case regular = "Regular"
    case bold = "Bold"
}

enum FontFamilyPicker: String, CaseIterable {
    case sfPro = "SF Pro"
    case tahoma = "Tahoma"
    case sansSerif = "Sans Serif"
}

enum LineSpacing: String, CaseIterable {
    case normal = "Normal"
    case large = "Large"
    case extraLarge = "Extra Large"
}

enum LetterSpacing: String, CaseIterable {
    case normal = "Normal"
    case large = "Large"
    case extraLarge = "Extra Large"
}

enum ParagraphSpacing: String, CaseIterable {
    case normal = "Normal"
    case large = "Large"
    case extraLarge = "Extra Large"
}

enum AlignmentText: String, CaseIterable {
    case left
    case center
    case right
    case justified
}

enum FontFamily: String, CaseIterable {
    case SFPro = "SF Pro"
    case tahoma = "Tahoma"
    case sansSerif = "Sans Serif"
    case Arial
    case openDyslexic = "OpenDyslexic"
}
