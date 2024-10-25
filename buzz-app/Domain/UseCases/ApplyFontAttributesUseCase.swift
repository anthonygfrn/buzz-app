import Foundation
import PDFKit

class ApplyFontAttributesUseCase {
    func execute(
        text: NSAttributedString,
        fontSize: CGFloat,
        fontWeight: NSFont.Weight,
        fontFamily: String,
        lineSpacing: CGFloat,
        letterSpacing: CGFloat,
        paragraphSpacing: CGFloat
    ) -> NSAttributedString {
        // Create a mutable attributed string
        let mutableText = NSMutableAttributedString(attributedString: text)

        let fontDescriptor = NSFontDescriptor(name: fontFamily, size: fontSize)
            .addingAttributes([.traits: [NSFontDescriptor.TraitKey.weight: fontWeight]])

        // Attempt to create the custom font with the specified weight
        let font = NSFont(descriptor: fontDescriptor, size: fontSize) ??
            NSFont.systemFont(ofSize: fontSize, weight: fontWeight) // Fallback to system font

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
