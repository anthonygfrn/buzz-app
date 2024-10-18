import Foundation

struct ApplyColorModeUseCase {
    private var colorApplier = TextColorApplier()

    mutating func execute(text: NSAttributedString, segmentColorMode: SegmentColoringMode, coloringStyle: ColoringStyle) -> NSAttributedString {
        // Start with a mutable copy of the existing attributed string
        let coloredText = NSMutableAttributedString(attributedString: text)

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
        let sentenceDelimiters = CharacterSet(charactersIn: ".!?")
        let sentences = text.components(separatedBy: sentenceDelimiters)

        var location = 0
        for (index, sentence) in sentences.enumerated() {
            // Trim whitespace around the sentence
            let trimmedSentence = sentence.trimmingCharacters(in: .whitespacesAndNewlines)

            if !trimmedSentence.isEmpty {
                let range = NSRange(location: location, length: trimmedSentence.count)
                colorApplier.applyColor(text: attributedString, range: range, coloringStyle: coloringStyle)

                // Apply to punctuation
                if index < sentences.count - 1 {
                    let punctuationRange = NSRange(location: location + sentence.count, length: 1) // Punctuation
                    colorApplier.applyColor(text: attributedString, range: punctuationRange, coloringStyle: coloringStyle)
                }
            }

            // Update the location by adding the length of the original sentence plus any punctuation
            location += sentence.count + 1 // Move to the next sentence (include the punctuation)
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
