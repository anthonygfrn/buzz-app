import AppKit
import Foundation

struct ApplyColorModeUseCase {
    private var colorApplier = TextColorApplier()

    private let sectionTitles = [
        "KESIMPULAN", "REFERENSI", "ABSTRAK", "ABSTRACT", "PENDAHULUAN",
        "METODE", "HASIL DAN PEMBAHASAN", "Introduction", "Survey Methodology", "References",
        "1. Introduction", "2. Literature Review", "3. Research Methodology", "4. Data Analysis",
        "5. Discussion", "6. Implications", "7. Limitations and future work", "8. Conclusion"
    ]

    mutating func execute(text: NSAttributedString, fontSize: CGFloat, segmentColorMode: SegmentColoringMode, coloringStyle: ColoringStyle, containerWidth: CGFloat) -> NSAttributedString {
        // Start with a mutable copy of the existing attributed string
        let coloredText = NSMutableAttributedString(attributedString: text)

        removeColoringStyle(in: coloredText, coloringStyle: coloringStyle)

        switch segmentColorMode {
        case .line:
            applyColorByLinesUsingLayoutManager(in: coloredText, coloringStyle: coloringStyle, containerWidth: containerWidth)
        case .sentence:
            applyColorBySentences(in: coloredText, from: text.string, coloringStyle: coloringStyle)
        case .paragraph:
            applyColorByParagraphs(in: coloredText, from: text.string, coloringStyle: coloringStyle)
        case .punctuation:
            applyColorByPunctuation(in: coloredText, from: text.string, coloringStyle: coloringStyle)
        }

        applySectionTitleStyles(in: coloredText, fontSize: fontSize)

        colorApplier.colorIndex = 1
        return coloredText
    }

    private mutating func removeColoringStyle(in attributedString: NSMutableAttributedString, coloringStyle: ColoringStyle) {
        attributedString.removeAttribute(.backgroundColor, range: NSRange(location: 0, length: attributedString.length))
        attributedString.removeAttribute(.foregroundColor, range: NSRange(location: 0, length: attributedString.length))
    }

    private func applySectionTitleStyles(in attributedString: NSMutableAttributedString, fontSize: CGFloat) {
        let fullText = attributedString.string.lowercased() // Convert full text to lowercase

        for title in sectionTitles {
            let lowercaseTitle = title.lowercased() // Convert each section title to lowercase
            var searchRange = NSRange(location: 0, length: attributedString.length)

            while let foundRange = (fullText as NSString).range(of: lowercaseTitle, options: [], range: searchRange).toOptional(), foundRange.location != NSNotFound {
                // Find the start and end of the line containing the found range
                let lineRange = (fullText as NSString).lineRange(for: foundRange)

                // Remove background and foreground colors for the entire line
                attributedString.removeAttribute(.backgroundColor, range: lineRange)
                attributedString.removeAttribute(.foregroundColor, range: lineRange)

                // Apply default text color to the section title within the line
                let textColorAttribute: [NSAttributedString.Key: Any] = [
                    .foregroundColor: NSColor(named: NSColor.Name("Default")) ?? NSColor.black // Default to black if color not found
                ]
                attributedString.addAttributes(textColorAttribute, range: foundRange)

                // Apply bold font to the section title
                attributedString.addAttributes([
                    .font: NSFont.boldSystemFont(ofSize: ceil(fontSize * 1.618))
                ], range: foundRange)

                // Update searchRange to look for the next occurrence after foundRange
                searchRange = NSRange(location: NSMaxRange(foundRange), length: attributedString.length - NSMaxRange(foundRange))
            }
        }
    }

    private mutating func applyColorByLinesUsingLayoutManager(in attributedString: NSMutableAttributedString, coloringStyle: ColoringStyle, containerWidth: CGFloat) {
        let textStorage = NSTextStorage(attributedString: attributedString)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        // Set up text container with the specified width
        let textContainer = NSTextContainer(size: CGSize(width: containerWidth, height: CGFloat.greatestFiniteMagnitude))
        textContainer.lineFragmentPadding = 0
        textContainer.widthTracksTextView = true
        layoutManager.addTextContainer(textContainer)

        var lineIndex = 0
        var glyphIndex = 0

        while glyphIndex < layoutManager.numberOfGlyphs {
            // Get the bounding rectangle for the current line and determine the glyph range for that line
            let lineRect = layoutManager.lineFragmentRect(forGlyphAt: glyphIndex, effectiveRange: nil)
            let lineGlyphRange = layoutManager.glyphRange(forBoundingRect: lineRect, in: textContainer)

            // Convert glyph range to character range for text extraction and coloring
            let characterRange = layoutManager.characterRange(forGlyphRange: lineGlyphRange, actualGlyphRange: nil)
            let lineText = (attributedString.string as NSString).substring(with: characterRange)

            // Trim the line text to check for non-whitespace content
            let trimmedLineText = lineText.trimmingCharacters(in: .whitespacesAndNewlines)

            // Apply color only if there is visible content
            if !trimmedLineText.isEmpty {
                colorApplier.applyColor(text: attributedString, range: characterRange, coloringStyle: coloringStyle)
            }

            // Move to the next line
            glyphIndex = NSMaxRange(lineGlyphRange)
            lineIndex += 1
        }
    }

    private mutating func applyColorBySentences(in attributedString: NSMutableAttributedString, from text: String, coloringStyle: ColoringStyle) {
        // Regular expression to capture sentences, including punctuation
        let sentenceRanges = text.ranges(of: "[^.!?]+[.!?]?")

        var currentLocation = 0
        for range in sentenceRanges {
            // Convert the range to an NSRange for use in NSMutableAttributedString
            var nsRange = NSRange(range, in: text)

            // Adjust nsRange location to the currentLocation
            nsRange.location = max(nsRange.location, currentLocation)

            // Extract the sentence from the range
            let sentence = (text as NSString).substring(with: nsRange)

            // Split sentence by newlines to apply color to each part separately
            let sentenceParts = sentence.components(separatedBy: "\n")
            var partLocation = nsRange.location

            for part in sentenceParts {
                // Calculate the range of the current part
                let partRange = NSRange(location: partLocation, length: part.count)

                // Apply color only if there's visible content
                let trimmedPart = part.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmedPart.isEmpty {
                    colorApplier.applyColor(text: attributedString, range: partRange, coloringStyle: coloringStyle)
                }

                // Move to the next part, accounting for the newline character
                partLocation += part.count + 1 // +1 to skip over the newline
            }

            // Update currentLocation to move past the entire sentence, including any newlines within it
            currentLocation = nsRange.location + nsRange.length
        }
    }

    private mutating func applyColorByParagraphs(in attributedString: NSMutableAttributedString, from text: String, coloringStyle: ColoringStyle) {
        let paragraphs = text.components(separatedBy: "\n\n")
        var location = 0
        for paragraph in paragraphs {
            if !paragraph.isEmpty {
                let range = NSRange(location: location, length: paragraph.count)
                colorApplier.applyColor(text: attributedString, range: range, coloringStyle: coloringStyle)
            }
            location += paragraph.count + 2 // Move to next paragraph
        }
    }

    private mutating func applyColorByPunctuation(in attributedString: NSMutableAttributedString, from text: String, coloringStyle: ColoringStyle) {
        // Regular expression to capture segments ending with punctuation
        let punctuationRanges = text.ranges(of: "[^.!?]+[.!?]")

        var currentLocation = 0
        for range in punctuationRanges {
            // Convert the range to an NSRange for use in NSMutableAttributedString
            var nsRange = NSRange(range, in: text)

            // Adjust nsRange location to the currentLocation
            nsRange.location = max(nsRange.location, currentLocation)

            // Extract the text segment from the range
            let segmentText = (text as NSString).substring(with: nsRange)

            // Split segment by newline characters to handle each part separately
            let segmentParts = segmentText.components(separatedBy: "\n")
            var partLocation = nsRange.location

            for part in segmentParts {
                // Calculate the range of the current part
                let partRange = NSRange(location: partLocation, length: part.count)

                // Apply color only if there's visible content
                let trimmedPart = part.trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmedPart.isEmpty {
                    colorApplier.applyColor(text: attributedString, range: partRange, coloringStyle: coloringStyle)
                }

                // Move to the next part, accounting for the newline character
                partLocation += part.count + 1 // +1 to skip over the newline
            }

            // Apply color to the punctuation at the end, if present
            if let lastCharacter = segmentText.last, ".!?".contains(lastCharacter) {
                let punctuationRange = NSRange(location: nsRange.location + nsRange.length - 1, length: 1)
                colorApplier.applyColor(text: attributedString, range: punctuationRange, coloringStyle: coloringStyle)
            }

            // Update currentLocation to move past the entire segment, including any newlines within it
            currentLocation = nsRange.location + nsRange.length
        }
    }
}

// Helper untuk NSRange agar menjadi Optional
private extension NSRange {
    func toOptional() -> NSRange? {
        return location != NSNotFound ? self : nil
    }
}
