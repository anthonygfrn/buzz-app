import Foundation
import PDFKit
import RichTextKit

class PDFViewModel: ObservableObject {
    @Published var extractedText = NSAttributedString("")
    @Published var rawText = ""
    @Published var segmentColoringMode: SegmentColoringMode = .line
    @Published var coloringStyle: ColoringStyle = .highlight

    @Published var selectedFontSize: FontSizePicker = .normal
    @Published var selectedFontWeight: FontWeightPicker = .regular
    @Published var selectedFontFamily: FontFamilyPicker = .SFPro

    @Published private(set) var fontSize: CGFloat = 18
    @Published private(set) var fontWeight: NSFont.Weight = .regular
    @Published private(set) var fontFamily: String = "SF Pro"
    @Published private(set) var lineSpacing: CGFloat = 0
    @Published private(set) var letterSpacing: CGFloat = 1
    @Published private(set) var paragraphSpacing: CGFloat = 2

    @Published var selectedLineSpacing: LineSpacing = .normal
    @Published var selectedLetterSpacing: LetterSpacing = .normal
    @Published var selectedParagraphSpacing: ParagraphSpacing = .normal

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
            extractedText = NSAttributedString(string: document.rawText)
            recolorText()
        }
    }

    func recolorText() {
        let coloredText = applyColorModeUseCase.execute(text: extractedText, segmentColorMode: segmentColoringMode, coloringStyle: coloringStyle)
        extractedText = coloredText
        context.setAttributedString(to: extractedText)
        modifyFontAttributes() // Ensure font attributes are applied after recoloring
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
            paragraphSpacing: paragraphSpacing
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
        case .normal:
            fontSize = 18
        case .large:
            fontSize = 29
        case .extraLarge:
            fontSize = 47
        }
        modifyFontAttributes()
    }

    func setSelectedFontWeight(to newFontWeight: FontWeightPicker) {
        switch newFontWeight {
        case .regular:
            fontWeight = .regular
        case .bold:
            fontWeight = .bold
        }
        modifyFontAttributes()
    }

    func setSelectedFontFamily(to newFontFamily: FontFamilyPicker) {
        fontFamily = newFontFamily.rawValue

        modifyFontAttributes()
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
        case .normal:
            lineSpacing = 1
        case .large:
            lineSpacing = 1.5
        case .extraLarge:
            lineSpacing = 2
        }

        modifyFontAttributes()
    }

    func setLetterSpacing(to newLetterSpacing: LetterSpacing) {
        switch newLetterSpacing {
        case .normal:
            letterSpacing = 1
        case .large:
            letterSpacing = 1.5
        case .extraLarge:
            letterSpacing = 2
        }

        modifyFontAttributes()
    }

    func setParagraphSpacing(to newParagraphSpacing: ParagraphSpacing) {
        switch newParagraphSpacing {
        case .normal:
            paragraphSpacing = 2
        case .large:
            paragraphSpacing = 2.5
        case .extraLarge:
            paragraphSpacing = 3
        }

        modifyFontAttributes()
    }
}
