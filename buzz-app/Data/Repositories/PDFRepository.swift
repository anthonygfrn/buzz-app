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
                let lines = pageText.components(separatedBy: .newlines)
                var currentParagraph = ""

                for line in lines {
                    if line.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        if !currentParagraph.isEmpty {
                            let attributedParagraphText = NSMutableAttributedString(string: currentParagraph + "\n\n")
                            fullText.append(attributedParagraphText)
                            rawTextBuffer += currentParagraph + "\n\n"
                            currentParagraph = ""
                        }
                    } else {
                        if !currentParagraph.isEmpty {
                            currentParagraph += " "
                        }
                        currentParagraph += line
                    }
                }

                // Append the last paragraph if not already appended
                if !currentParagraph.isEmpty {
                    let attributedParagraphText = NSMutableAttributedString(string: currentParagraph + "\n\n")
                    fullText.append(attributedParagraphText)
                    rawTextBuffer += currentParagraph + "\n\n"
                }
            }
        }
        
        let rawText = rawTextBuffer.trimmingCharacters(in: .whitespacesAndNewlines)
        return PDFDocumentEntity(rawText: rawText, attributedText: fullText)
    }
}
