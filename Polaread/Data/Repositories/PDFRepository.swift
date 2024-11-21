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
                    let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)

                    if trimmedLine.isEmpty {
                        // Handle end of paragraph
                        if !currentParagraph.isEmpty {
                            let attributedParagraphText = NSMutableAttributedString(string: currentParagraph + "\n\n")
                            fullText.append(attributedParagraphText)
                            rawTextBuffer += currentParagraph + "\n\n"
                            currentParagraph = ""
                        }
                    } else if isSectionTitle(trimmedLine) {
                        // Handle section titles separately with double line breaks
                        if !currentParagraph.isEmpty {
                            let attributedParagraphText = NSMutableAttributedString(string: currentParagraph + "\n\n")
                            fullText.append(attributedParagraphText)
                            rawTextBuffer += currentParagraph + "\n\n"
                            currentParagraph = ""
                        }
                        // Add section title with extra line break before
                        let attributedTitleText = NSMutableAttributedString(string: "\n\n" + trimmedLine + "\n\n")
                        fullText.append(attributedTitleText)
                        rawTextBuffer += "\n\n" + trimmedLine + "\n\n"
                    } else {
                        // Continue current paragraph
                        if !currentParagraph.isEmpty {
                            currentParagraph += " "
                        }
                        currentParagraph += trimmedLine
                    }
                }

                // Append any remaining paragraph at the end of the page
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

    private func isSectionTitle(_ line: String) -> Bool {
        // List of section titles to match as standalone words
        let sectionTitles = [
            "KESIMPULAN",
            "REFERENSI",
            "ABSTRAK",
            "ABSTRACT",
            "PENDAHULUAN",
            "METODE",
            "HASIL DAN PEMBAHASAN",
            "Introduction",
            "Survey Methodology",
            "References"
        ]

        // Create a pattern that matches any of the section titles exactly as standalone words, ignoring case
        let titlePattern = sectionTitles.joined(separator: "|")
        let regexPattern = #"(?i)^(?:\#(titlePattern))$"#

        // Check if the line matches the section title pattern exactly
        return line.range(of: regexPattern, options: .regularExpression) != nil
    }
}
