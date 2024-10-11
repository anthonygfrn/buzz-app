import PDFKit
import RichTextKit
import SwiftUI

struct ContentView: View {
    @State
    private var extractedText = NSAttributedString(string: "")
    @State
    private var text = NSAttributedString(string: "")

    @StateObject
    var context = RichTextContext()

    var body: some View {
        VStack {
            Button("Increase font size") {
                context.trigger(.stepFontSize(points: 1))
            }
            RichTextEditor(
                text: $text,
                context: context
            )

            RichTextFormat.Toolbar(context: context)
        }
        .onChange(of: text) {
            print(text)
        }
    }

    // Function to open PDF from Finder
    func openPDFPicker() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["pdf"]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        if panel.runModal() == .OK {
            if let url = panel.url {
                if let text = convertPDFToAttributedString(from: url) {
                    extractedText = text
                    print(extractedText)
                } else {
                    extractedText = NSAttributedString(string: "Failed to extract text from PDF.")
                }
            } else {
                extractedText = NSAttributedString(string: "PDF file not found.")
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
