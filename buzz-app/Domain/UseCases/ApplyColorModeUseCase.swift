import Foundation
import AppKit

struct ApplyColorModeUseCase {
    private var colorApplier = TextColorApplier()

    mutating func execute(text: NSAttributedString, segmentColorMode: SegmentColoringMode, coloringStyle: ColoringStyle, containerWidth: CGFloat) -> NSAttributedString {
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

        colorApplier.colorIndex = 1
        return coloredText
    }

    private mutating func removeColoringStyle(in attributedString: NSMutableAttributedString, coloringStyle: ColoringStyle) {
            attributedString.removeAttribute(.backgroundColor, range: NSRange(location: 0, length: attributedString.length))
            attributedString.removeAttribute(.foregroundColor, range: NSRange(location: 0, length: attributedString.length))
        
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
    
    private mutating func applyColorByLines(in attributedString: NSMutableAttributedString, from text: String, coloringStyle: ColoringStyle) {
        let lines = text.components(separatedBy: .newlines)
        var location = 0
        for line in lines {
            if !line.isEmpty {
                let range = NSRange(location: location, length: line.count)
                colorApplier.applyColor(text: attributedString, range: range, coloringStyle: coloringStyle)
            }
            location += line.count + 1 // Move to next line (including newline character)
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
        let sentenceDelimiters = CharacterSet(charactersIn: ".!?")
        let sentences = text.components(separatedBy: sentenceDelimiters)

        var location = 0
        for (index, sentence) in sentences.enumerated() {
            if !sentence.isEmpty {
                let range = NSRange(location: location, length: sentence.count)
                colorApplier.applyColor(text: attributedString, range: range, coloringStyle: coloringStyle)

                // Apply to punctuation
                if index < sentences.count - 1 {
                    let punctuationRange = NSRange(location: location + sentence.count, length: 1) // Punctuation
                    colorApplier.applyColor(text: attributedString, range: punctuationRange, coloringStyle: coloringStyle)
                }
            }
            location += sentence.count + 1
        }
    }
}
