
//
//  ApplyColorModeUseCase.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 17/10/24.
//

import Foundation
import PDFKit

struct ApplyColorModeUseCase {
    func execute(text: String, colorMode: TextColorMode) -> NSAttributedString {
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
            let sentenceDelimiters = CharacterSet(charactersIn: ".!?")
            let sentences = text.components(separatedBy: sentenceDelimiters)

            var location = 0
            for (index, sentence) in sentences.enumerated() {
                if !sentence.isEmpty {
                    let range = NSRange(location: location, length: sentence.count)
                    coloredText.addAttribute(.foregroundColor, value: randomColor(), range: range)

                    if index < sentences.count - 1 {
                        let punctuationRange = NSRange(location: location + sentence.count, length: 1) // Punctuation
                        coloredText.addAttribute(.foregroundColor, value: randomColor(), range: punctuationRange)
                    }
                }
                location += sentence.count + 1
            }
        }

        return coloredText
    }
}
