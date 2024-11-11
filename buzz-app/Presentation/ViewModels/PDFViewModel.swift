import Foundation
import PDFKit
import RichTextKit

class PDFViewModel: ObservableObject {
    @Published var extractedText = NSAttributedString("")
    @Published var rawText = ""
    @Published var segmentColoringMode: SegmentColoringMode = .line
    @Published var coloringStyle: ColoringStyle = .highlight
    @Published var containerWidth: CGFloat = 1331
    @Published var shouldShowPDFPicker: Bool = true

    @Published var selectedFontSize: FontSizePicker = .standard
    @Published var selectedFontWeight: FontWeightPicker = .regular
    @Published var selectedFontFamily: FontFamily = .SFPro
    @Published var selectedLineSpacing: LineSpacing = .standard
    @Published var selectedLetterSpacing: LetterSpacing = .standard
    @Published var selectedParagraphSpacing: ParagraphSpacing = .standard
    @Published var selectedTextAlignment: AlignmentText = .left

    @Published private(set) var fontSize: CGFloat = 18
    @Published private(set) var fontWeight: NSFont.Weight = .regular
    @Published private(set) var fontFamily: String = "SF Pro"
    @Published private(set) var lineSpacing: CGFloat = 0
    @Published private(set) var letterSpacing: CGFloat = 1
    @Published private(set) var paragraphSpacing: CGFloat = 2
    @Published private(set) var textAlignment: String = "left"

    @Published var context = RichTextContext()

//    Use Case
    private let extractPDFTextUseCase: ExtractPDFTextUseCase
    private var applyColorModeUseCase: ApplyColorModeUseCase
    private let applyFontAttributesUseCase: ApplyFontAttributesUseCase

    init(extractPDFTextUseCase: ExtractPDFTextUseCase, applyColorModeUseCase: ApplyColorModeUseCase, applyFontAttributesUseCase: ApplyFontAttributesUseCase) {
        self.extractPDFTextUseCase = extractPDFTextUseCase
        self.applyColorModeUseCase = applyColorModeUseCase
        self.applyFontAttributesUseCase = applyFontAttributesUseCase
    }

    func openPDF(url: URL) {
        if let document = extractPDFTextUseCase.execute(url: url) {
            rawText = document.rawText
            extractedText = document.attributedText
            recolorText()
        }
    }

    func recolorText() {
        modifyFontAttributes()
        let coloredText = applyColorModeUseCase.execute(text: extractedText, segmentColorMode: segmentColoringMode, coloringStyle: coloringStyle, containerWidth: containerWidth)
        extractedText = coloredText
        context.setAttributedString(to: extractedText)
    }

    // Apply both font size and weight
    func modifyFontAttributes() {
        extractedText = applyFontAttributesUseCase.execute(
            text: extractedText,
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontFamily: fontFamily,
            lineSpacing: lineSpacing,
            letterSpacing: letterSpacing,
            paragraphSpacing: paragraphSpacing,
            textAlignment: textAlignment
        )
        context.setAttributedString(to: extractedText)
    }

    func setColoringStyle(to newValue: ColoringStyle) {
        if coloringStyle != newValue {
            coloringStyle = newValue
            recolorText()
        }
    }

    func setSelectedFontSize(to newFontSize: FontSizePicker) {
        switch newFontSize {
        case .standard:
            fontSize = 18
        case .large:
            fontSize = 29
        case .extraLarge:
            fontSize = 47
        }
        recolorText()
    }

    func setSelectedFontWeight(to newFontWeight: FontWeightPicker) {
        switch newFontWeight {
        case .regular:
            fontWeight = .regular
        case .bold:
            fontWeight = .bold
        }
        recolorText()
    }

    func setSelectedFontFamily(to newFontFamily: FontFamily) {
        fontFamily = newFontFamily.rawValue

        recolorText()
    }

    func setSegmentedControlValue(to newValue: SegmentColoringMode) {
        switch newValue {
        case .line:
            segmentColoringMode = .line
        case .sentence:
            segmentColoringMode = .sentence
        case .paragraph:
            segmentColoringMode = .paragraph
        case .punctuation:
            segmentColoringMode = .punctuation
        }

        recolorText()
    }

    func setLineSpacing(to newLineSpacing: LineSpacing) {
        switch newLineSpacing {
        case .standard:
            lineSpacing = 1
        case .large:
            lineSpacing = 2.5
        case .extraLarge:
            lineSpacing = 5
        }

        recolorText()
    }

    func setLetterSpacing(to newLetterSpacing: LetterSpacing) {
        switch newLetterSpacing {
        case .standard:
            letterSpacing = 1 * lineSpacing
        case .large:
            letterSpacing = 1.5 * lineSpacing
        case .extraLarge:
            letterSpacing = 2 * lineSpacing
        }

        recolorText()
    }

    func setParagraphSpacing(to newParagraphSpacing: ParagraphSpacing) {
        switch newParagraphSpacing {
        case .standard:
            paragraphSpacing = 2 * lineSpacing
        case .large:
            paragraphSpacing = 2.5 * lineSpacing
        case .extraLarge:
            paragraphSpacing = 3 * lineSpacing
        }

        recolorText()
    }

    func setSelectedTextAlignment(to newTextAlignment: AlignmentText) {
        selectedTextAlignment = newTextAlignment
        switch newTextAlignment {
        case .left:
            textAlignment = "left"
        case .center:
            textAlignment = "center"
        case .right:
            textAlignment = "right"
        case .justified:
            textAlignment = "justified"
        }
        recolorText()
    }

    func resetAllStyling() {
        fontSize = 18
        fontWeight = .regular
        fontFamily = "SF Pro"
        lineSpacing = 0
        letterSpacing = 1
        paragraphSpacing = 2
        textAlignment = "left"

        selectedFontSize = .standard
        selectedFontWeight = .regular
        selectedFontFamily = .SFPro
        selectedLineSpacing = .standard
        selectedLetterSpacing = .standard
        selectedParagraphSpacing = .standard
        selectedTextAlignment = .left

        recolorText()
    }
}
