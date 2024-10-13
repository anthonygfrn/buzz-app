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
    @State private var forceRefresh = false

    var body: some View {
        VStack {
            Button("Open PDF") {
                openPDFPicker()
            }
            .padding()

            Button("Increase font size") {
                context.trigger(.stepFontSize(points: 1))
            }

            // Trigger force-refresh using an additional boolean
            RichTextEditor(
                text: $extractedText,
                context: context
            )
            .id(forceRefresh) // This forces SwiftUI to recreate the view when forceRefresh changes
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
                    forceRefresh.toggle() // Force a refresh of the RichTextEditor
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
}

#Preview {
    ContentView()
}
