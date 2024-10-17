import PDFKit
import RichTextKit
import SwiftUI

enum ColorMode {
    case line
    case paragraph
    case punctuation
    case sentence
}

struct ContentView: View {
    @State private var extractedText = NSAttributedString(string: "")
    @State private var rawText = "" // Store the raw PDF text for reprocessing
    @StateObject var context = RichTextContext()
    @State private var colorMode: ColorMode = .line // State to control color mode

    var body: some View {
        VStack {
            HStack {
                Button("Open PDF") {
                    openPDFPicker()
                }
            }
            ScrollView {
                VStack {
                    // Bind RichTextEditor directly to extractedText
                    RichTextEditor(text: $extractedText, context: context)
                        .frame(height: 594)
                }
            }
            .padding()

            CustomToolbar()
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
                if let attributedText = convertPDFToAttributedString(from: url) {
                    extractedText = attributedText
                    rawText = extractedText.string // Update raw text with paragraph breaks
                    context.setAttributedString(to: extractedText) // Reflect changes in context
                } else {
                    extractedText = NSAttributedString(string: "Failed to extract text from PDF.")
                }
            }
        }
    }

    // Function to recolor the text based on the selected color mode
    func recolorText() {
        extractedText = applyColorMode(to: rawText)
        context.setAttributedString(to: extractedText) // Reflect changes in context
    }

    // Function to generate a random color for macOS (NSColor)
    func randomColor() -> NSColor {
        let red = CGFloat(arc4random_uniform(256)) / 255.0
        let green = CGFloat(arc4random_uniform(256)) / 255.0
        let blue = CGFloat(arc4random_uniform(256)) / 255.0
        return NSColor(red: red, green: green, blue: blue, alpha: 1.0)
    }

    // Function to convert PDF to NSAttributedString with automatic paragraph detection
    func convertPDFToAttributedString(from url: URL) -> NSAttributedString? {
        guard let pdfDocument = PDFDocument(url: url) else {
            print("Cannot load PDF file.")
            return nil
        }

        let fullText = NSMutableAttributedString()
        var rawTextBuffer = "" // To accumulate raw text for processing

        for pageIndex in 0 ..< pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex),
               let pageText = page.string
            {
                // Split text by paragraph
                let paragraphs = pageText.components(separatedBy: "\n\n")

                for paragraph in paragraphs {
                    if !paragraph.isEmpty {
//                        Add \n
                        let attributedParagraphText = NSMutableAttributedString(string: paragraph + "\n\n")

//                        Add auto color
                        attributedParagraphText.addAttribute(.foregroundColor, value: randomColor(), range: NSRange(location: 0, length: attributedParagraphText.length))
                        fullText.append(attributedParagraphText)

                        // Append to rawTextBuffer with paragraph breaks
                        rawTextBuffer += paragraph + "\n\n"
                    }
                }
            }
        }

        // Update rawText state
        rawText = rawTextBuffer.trimmingCharacters(in: .whitespacesAndNewlines)

        return fullText
    }

    // Function to apply color based on the selected color mode
    func applyColorMode(to text: String) -> NSAttributedString {
        let coloredText = NSMutableAttributedString(string: text)

        switch colorMode {
        case .line:
            let lines = text.components(separatedBy: .newlines)
            var location = 0
            for line in lines {
                if !line.isEmpty {
                    let range = NSRange(location: location, length: line.count)
                    coloredText.addAttribute(.foregroundColor, value: randomColor(), range: range)
                }
                location += line.count + 1 // Move to next line (including newline character)
            }
            
        case .sentence:
            let sentenceDelimiters = CharacterSet(charactersIn: ".!?")
            let sentences = text.components(separatedBy: sentenceDelimiters)

            var location = 0
            for (index, sentence) in sentences.enumerated() {
                if !sentence.isEmpty {
                    // Color the sentence
                    let range = NSRange(location: location, length: sentence.count)
                    coloredText.addAttribute(.foregroundColor, value: randomColor(), range: range)

                    // Color the punctuation after the sentence (if applicable)
                    if index < sentences.count - 1 {
                        let punctuationRange = NSRange(location: location + sentence.count, length: 1) // Punctuation
                        coloredText.addAttribute(.foregroundColor, value: randomColor(), range: punctuationRange)
                    }
                }

                // Move the location by the length of the sentence and punctuation
                location += sentence.count + 1
            }

    
        case .paragraph:
            let paragraphs = text.components(separatedBy: "\n\n")
            var location = 0
            for paragraph in paragraphs {
                if !paragraph.isEmpty {
                    let range = NSRange(location: location, length: paragraph.count)
                    coloredText.addAttribute(.foregroundColor, value: randomColor(), range: range)
                }
                location += paragraph.count + 2 // Move to next paragraph
            }

        case .punctuation:
            // Split text by sentence-ending punctuation (. ! ?)
            let sentenceDelimiters = CharacterSet(charactersIn: ".!?")
            let sentences = text.components(separatedBy: sentenceDelimiters)

            var location = 0
            for (index, sentence) in sentences.enumerated() {
                if !sentence.isEmpty {
                    // Color the sentence
                    let range = NSRange(location: location, length: sentence.count)
                    coloredText.addAttribute(.foregroundColor, value: randomColor(), range: range)

                    // Add the punctuation after the sentence
                    if index < sentences.count - 1 {
                        let punctuationRange = NSRange(location: location + sentence.count, length: 1) // For the punctuation itself
                        coloredText.addAttribute(.foregroundColor, value: randomColor(), range: punctuationRange)
                    }
                }

                // Move the location by the length of the sentence and the punctuation (1 character)
                location += sentence.count + 1
            }
        }

        return coloredText
    }
}

#Preview {
    ContentView()
}
