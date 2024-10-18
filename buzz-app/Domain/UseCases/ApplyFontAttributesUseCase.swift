import Foundation
import PDFKit

class ApplyFontAttributesUseCase {
    func execute(text: NSAttributedString, fontSize: CGFloat, fontWeight: NSFont.Weight) -> NSAttributedString {
        // Create a mutable attributed string
        let mutableText = NSMutableAttributedString(attributedString: text)

        // Create a UIFont with the given size and weight
        let font = NSFont.systemFont(ofSize: fontSize, weight: fontWeight)

        // Apply the font to the entire text
        mutableText.addAttribute(.font, value: font, range: NSRange(location: 0, length: text.length))

        return mutableText
    }
}
