//
//  PDFDocumentEntity1.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 17/10/24.
//

import Foundation

struct PDFDocumentEntity {
    let rawText: String
    let attributedText: NSAttributedString
}

enum TextColorMode {
    case line
    case paragraph
    case punctuation
    case sentence
}
