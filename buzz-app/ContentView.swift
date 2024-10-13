//
//  ContentView.swift
//  buzz-app
//
//  Created by Anthony on 07/10/24.
//

import PDFKit
import RichTextKit
import SwiftUI

struct ContentView: View {
    @State private var extractedText = NSAttributedString(string: "")
    @StateObject var context = RichTextContext()

    let a4Width: CGFloat = 595
    let a4Height: CGFloat = 842

    var body: some View {
        VStack {
            Button("Open PDF") {
                openPDFPicker()
            }
            .padding()

            ScrollView {
                VStack {
                    let pages = splitTextIntoPages(text: extractedText, pageSize: CGSize(width: a4Width, height: a4Height))

                    ForEach(pages.indices, id: \.self) { index in
                        ZStack {
                            Color(.white)
                            
                            RichTextEditor(
                                text: .constant(pages[index]),
                                context: context
                            )
                            .frame(width: a4Width, height: a4Height)
                            .border(Color.black, width: 1)
                            .disabled(true) // Disable editing and internal scrolling
                        }
                        .frame(width: a4Width, height: a4Height) // Keep the frame size consistent with A4
                        .padding()
                    }
                }
            }
            .padding()

            RichTextFormat.Toolbar(context: context)
        }
    }

    // Function to open PDF from Finder (macOS)
    func openPDFPicker() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["pdf"]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        if panel.runModal() == .OK {
            if let url = panel.url {
                if let text = convertPDFToAttributedString(from: url) {
                    extractedText = text
                } else {
                    extractedText = NSAttributedString(string: "Failed to extract text from PDF.")
                }
            }
        }
    }

    // Function to convert PDF to NSAttributedString
    func convertPDFToAttributedString(from url: URL) -> NSAttributedString? {
        guard let pdfDocument = PDFDocument(url: url) else {
            print("Cannot load PDF file.")
            return nil
        }

        let fullText = NSMutableAttributedString()
        for pageIndex in 0 ..< pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex),
               let pageText = page.string
            {
                let attributedPageText = NSAttributedString(string: pageText + "\n")
                fullText.append(attributedPageText)
            }
        }

        return fullText
    }

    // Function to split NSAttributedString into multiple pages based on the page size
    func splitTextIntoPages(text: NSAttributedString, pageSize: CGSize) -> [NSAttributedString] {
        var pages: [NSAttributedString] = []

        let fullTextStorage = NSTextStorage(attributedString: text)
        let textLayoutManager = NSLayoutManager()
        fullTextStorage.addLayoutManager(textLayoutManager)

        var startIndex = 0

        while startIndex < text.length {
            // Create a text container for each page
            let textContainer = NSTextContainer(size: pageSize)
            textContainer.lineFragmentPadding = 0
            textLayoutManager.addTextContainer(textContainer)

            // Get the glyph range that fits within this page
            let glyphRange = textLayoutManager.glyphRange(for: textContainer)

            // Extract the corresponding character range
            let characterRange = textLayoutManager.characterRange(forGlyphRange: glyphRange, actualGlyphRange: nil)

            // Extract the text for this page
            let pageText = fullTextStorage.attributedSubstring(from: characterRange)

            // Append the extracted text as a new page
            pages.append(pageText)

            // Move the start index to the end of the current page
            startIndex = NSMaxRange(characterRange)
        }

        return pages
    }
}

#Preview {
    ContentView()
}
