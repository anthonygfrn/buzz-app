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
        paragraphSpacing: CGFloat,
        textAlignment: String 
    ) -> NSAttributedString {
        // Create a mutable attributed string
        let mutableText = NSMutableAttributedString(attributedString: text)

        let fontDescriptor = NSFontDescriptor(name: fontFamily, size: fontSize)
            .addingAttributes([.traits: [NSFontDescriptor.TraitKey.weight: fontWeight]])

        let font = NSFont(descriptor: fontDescriptor, size: fontSize) ??
            NSFont.systemFont(ofSize: fontSize, weight: fontWeight)

        let fullRange = NSRange(location: 0, length: text.length)
        mutableText.addAttribute(.font, value: font, range: fullRange)
        mutableText.addAttribute(.kern, value: letterSpacing, range: fullRange)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing

        // Set alignment based on textAlignment value
        switch textAlignment {
        case "center":
            paragraphStyle.alignment = .center
        case "right":
            paragraphStyle.alignment = .right
        case "justified":
            paragraphStyle.alignment = .justified
        default:
            paragraphStyle.alignment = .left
        }

        mutableText.addAttribute(.paragraphStyle, value: paragraphStyle, range: fullRange)

        return mutableText
    }
}

