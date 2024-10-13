import PDFKit
import RichTextKit
import SwiftUI

struct ContentView: View {
    @State private var extractedText = NSAttributedString(string: "")
    @StateObject var context = RichTextContext()

    @State private var isTwoColumnLayout = false // State to control layout format

    let a4Width: CGFloat = 595
    let a4Height: CGFloat = 842

    var body: some View {
        VStack {
            HStack {
                Button("Open PDF") {
                    openPDFPicker()
                }
                .padding()

                Toggle("Two Column Layout", isOn: $isTwoColumnLayout)
                    .padding()
            }

            ScrollView {
                VStack {
                    let pages = splitTextIntoPages(text: extractedText, pageSize: CGSize(width: a4Width, height: a4Height), isTwoColumn: isTwoColumnLayout)

                    ForEach(pages.indices, id: \.self) { index in
                        ZStack {
                            Color(.white)

                            HStack {
                                RichTextEditor(
                                    text: .constant(pages[index].leftColumn),
                                    context: context
                                )
                                .frame(width: isTwoColumnLayout ? (a4Width / 2 - 10) : a4Width, height: a4Height)
                                .border(Color.black, width: 1)
                                .disabled(true)

                                if isTwoColumnLayout {
                                    RichTextEditor(
                                        text: .constant(pages[index].rightColumn),
                                        context: context
                                    )
                                    .frame(width: a4Width / 2 - 10, height: a4Height)
                                    .border(Color.black, width: 1)
                                    .disabled(true)
                                }
                            }
                        }
                        .frame(width: a4Width, height: a4Height)
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

    // Function to generate a random color for macOS (NSColor)
    func randomColor() -> NSColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        return NSColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    // Function to convert PDF to NSAttributedString with random colors per line
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
                let lines = pageText.components(separatedBy: .newlines)
                for line in lines {
                    // Apply random color to each line
                    let attributedLineText = NSMutableAttributedString(string: line + "\n")
                    attributedLineText.addAttribute(.foregroundColor, value: randomColor(), range: NSRange(location: 0, length: attributedLineText.length))
                    fullText.append(attributedLineText)
                }
            }
        }

        return fullText
    }

    // Structure to hold the text of both columns
    struct PageColumns {
        let leftColumn: NSAttributedString
        let rightColumn: NSAttributedString
    }

    // Function to split NSAttributedString into multiple pages with two columns
    func splitTextIntoPages(text: NSAttributedString, pageSize: CGSize, isTwoColumn: Bool) -> [PageColumns] {
        var pages: [PageColumns] = []

        let fullTextStorage = NSTextStorage(attributedString: text)
        let textLayoutManager = NSLayoutManager()
        fullTextStorage.addLayoutManager(textLayoutManager)

        var startIndex = 0

        while startIndex < text.length {
            // Adjust text container size for two-column layout
            let columnWidth = isTwoColumn ? (pageSize.width / 2 - 10) : pageSize.width

            // Left column container
            let leftTextContainer = NSTextContainer(size: CGSize(width: columnWidth, height: pageSize.height))
            leftTextContainer.lineFragmentPadding = 0
            textLayoutManager.addTextContainer(leftTextContainer)

            // Right column container (only if it's a two-column layout)
            let rightTextContainer = NSTextContainer(size: CGSize(width: columnWidth, height: pageSize.height))
            rightTextContainer.lineFragmentPadding = 0
            textLayoutManager.addTextContainer(rightTextContainer)

            // Extract text for left column
            let leftGlyphRange = textLayoutManager.glyphRange(for: leftTextContainer)
            let leftCharacterRange = textLayoutManager.characterRange(forGlyphRange: leftGlyphRange, actualGlyphRange: nil)
            let leftPageText = fullTextStorage.attributedSubstring(from: leftCharacterRange)

            // Extract text for right column (only if two-column layout)
            let rightPageText: NSAttributedString
            if isTwoColumn {
                let rightGlyphRange = textLayoutManager.glyphRange(for: rightTextContainer)
                let rightCharacterRange = textLayoutManager.characterRange(forGlyphRange: rightGlyphRange, actualGlyphRange: nil)
                rightPageText = fullTextStorage.attributedSubstring(from: rightCharacterRange)

                // Move the start index to the end of the right column
                startIndex = NSMaxRange(rightCharacterRange)
            } else {
                // Move the start index to the end of the left column if single column
                rightPageText = NSAttributedString(string: "")
                startIndex = NSMaxRange(leftCharacterRange)
            }

            // Add the page with both columns (or just one if single-column mode)
            pages.append(PageColumns(leftColumn: leftPageText, rightColumn: rightPageText))
        }

        return pages
    }
}

#Preview {
    ContentView()
}
