//
//  PDFRepository.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 17/10/24.
//

import Foundation
import PDFKit

class PDFRepository: PDFRepositoryProtocol {
    func extractText(from url: URL) -> PDFDocumentEntity? {
        guard let pdfDocument = PDFDocument(url: url) else {
            print("Cannot load PDF file.")
            return nil
        }

        let fullText = NSMutableAttributedString()
        var rawTextBuffer = ""

        for pageIndex in 0 ..< pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex),
               let pageText = page.string
            {
                let paragraphs = pageText.components(separatedBy: "\n\n")
                for paragraph in paragraphs {
                    if !paragraph.isEmpty {
                        let attributedParagraphText = NSMutableAttributedString(string: paragraph + "\n\n")
                        fullText.append(attributedParagraphText)
                        rawTextBuffer += paragraph + "\n\n"
                    }
                }
            }
        }
        let rawText = rawTextBuffer.trimmingCharacters(in: .whitespacesAndNewlines)
        return PDFDocumentEntity(rawText: rawText, attributedText: fullText)
    }
}
