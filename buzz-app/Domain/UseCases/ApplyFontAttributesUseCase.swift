import Foundation
import PDFKit

class ApplyFontAttributesUseCase {
    func execute(
        text: NSAttributedString,
        fontSize: CGFloat,
        fontWeight: NSFont.Weight,
        lineSpacing: CGFloat,
        letterSpacing: CGFloat,
        paragraphSpacing: CGFloat
    ) -> NSAttributedString {
        // Create a mutable attributed string
        let mutableText = NSMutableAttributedString(attributedString: text)

        // Create a UIFont with the given size and weight
        let font = NSFont.systemFont(ofSize: fontSize, weight: fontWeight)

        // Apply font attributes to the entire text
        let fullRange = NSRange(location: 0, length: text.length)
        mutableText.addAttribute(.font, value: font, range: fullRange)

        // Apply letter spacing (kerning)
        mutableText.addAttribute(.kern, value: letterSpacing, range: fullRange)

        // Apply paragraph style for line spacing and paragraph spacing
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing

        // Apply paragraph style to the entire text
        mutableText.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)

        return mutableText
    }
}
