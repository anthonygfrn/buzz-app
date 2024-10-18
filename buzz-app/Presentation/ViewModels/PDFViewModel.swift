//
//  PDFManagerViewModel.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 17/10/24.
//

import Foundation
import PDFKit
import RichTextKit

class PDFViewModel: ObservableObject {
    @Published var extractedText = NSAttributedString("")
    @Published var rawText = ""
    @Published var segmentColoringMode: SegmentColoringMode = .line
    @Published var coloringStyle: ColoringStyle = .highlight
    @Published var context = RichTextContext()
    @Published var fontSize: CGFloat = 16

    private let extractPDFTextUseCase: ExtractPDFTextUseCase
    private var applyColorModeUseCase: ApplyColorModeUseCase
    private let applyFontSizeUseCase: ApplyFontSizeUseCase

    init(extractPDFTextUseCase: ExtractPDFTextUseCase, applyColorModeUseCase: ApplyColorModeUseCase, applyFontSizeUseCase: ApplyFontSizeUseCase) {
        self.extractPDFTextUseCase = extractPDFTextUseCase
        self.applyColorModeUseCase = applyColorModeUseCase
        self.applyFontSizeUseCase = applyFontSizeUseCase
    }

    func openPDF(url: URL) {
        if let document = extractPDFTextUseCase.execute(url: url) {
            rawText = document.rawText
            recolorText()
        }
    }

    func recolorText() {
        var result = applyColorModeUseCase.execute(text: rawText, segmentColorMode: segmentColoringMode, coloringStyle: coloringStyle)
        extractedText = result
        context.setAttributedString(to: extractedText)
    }

    func modifyFontSize() {
        var result = applyFontSizeUseCase.execute(text: extractedText, fontSize: fontSize)
        extractedText = result
        context.setAttributedString(to: extractedText)
    }
}
