import Foundation

struct ApplyColorModeUseCase {
    private var colorApplier = TextColorApplier()

    mutating func execute(text: NSAttributedString, segmentColorMode: SegmentColoringMode, coloringStyle: ColoringStyle) -> NSAttributedString {
        // Start with a mutable copy of the existing attributed string
        let coloredText = NSMutableAttributedString(attributedString: text)

        removeColoringStyle(in: coloredText, coloringStyle: coloringStyle)

        switch segmentColorMode {
        case .line:
            applyColorByLines(in: coloredText, from: text.string, coloringStyle: coloringStyle)
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
        if coloringStyle == .text {
            attributedString.removeAttribute(.backgroundColor, range: NSRange(location: 0, length: attributedString.length))
        } else if coloringStyle == .highlight {
            attributedString.removeAttribute(.foregroundColor, range: NSRange(location: 0, length: attributedString.length))
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
        
        // Iterate over all sentence ranges
        var currentLocation = 0
        for range in sentenceRanges {
            // Convert the range to an NSRange for use in NSMutableAttributedString
            var nsRange = NSRange(range, in: text)

            // Adjust nsRange location to the currentLocation
            nsRange.location = max(nsRange.location, currentLocation)

            // Extract the sentence from the range
            let sentence = (text as NSString).substring(with: nsRange)

            // Check if the sentence contains a newline character
            if let newlineRange = sentence.range(of: "\n") {
                // Adjust the NSRange to stop before the newline
                let locationOfNewline = sentence.distance(from: sentence.startIndex, to: newlineRange.lowerBound)
                nsRange.length = locationOfNewline

                // Apply color to the sentence before the newline
                let trimmedSentence = (text as NSString).substring(with: nsRange).trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmedSentence.isEmpty {
                    colorApplier.applyColor(text: attributedString, range: nsRange, coloringStyle: coloringStyle)
                }

                // Move the current location to just after the newline
                currentLocation = nsRange.location + nsRange.length + 1
            } else {
                // Apply color to the full sentence if no newline is found
                let trimmedSentence = (text as NSString).substring(with: nsRange).trimmingCharacters(in: .whitespacesAndNewlines)
                if !trimmedSentence.isEmpty {
                    colorApplier.applyColor(text: attributedString, range: nsRange, coloringStyle: coloringStyle)
                }
                currentLocation = nsRange.location + nsRange.length
            }
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
