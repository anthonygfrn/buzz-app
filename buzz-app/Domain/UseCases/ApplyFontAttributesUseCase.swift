
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

        // Check if the font is "Calibri" and the weight is bold, then use "Calibri-Bold"
        let fontName: String
        if fontFamily.lowercased() == "calibri" && fontWeight == .bold {
            fontName = "Calibri-Bold"
        } else {
            fontName = fontFamily
        }

        // Create the font descriptor and font
        let fontDescriptor = NSFontDescriptor(name: fontName, size: fontSize)
            .addingAttributes([.traits: [NSFontDescriptor.TraitKey.weight: fontWeight]])

        let font = NSFont(descriptor: fontDescriptor, size: fontSize) ??
            NSFont(name: fontName, size: fontSize) ?? // Fallback to custom font name
            NSFont.systemFont(ofSize: fontSize, weight: fontWeight) // System font fallback

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
