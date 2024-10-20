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
    @Published var selectedFontFamily: FontFamilyPicker = .sansSerif

    @Published private(set) var fontSize: CGFloat = 18
    @Published private(set) var fontWeight: NSFont.Weight = .regular
    @Published private(set) var fontFamily: NSFont = .systemFont(ofSize: 18)
    
    @Published var selectedLineSpacing: LineSpacing = .normal
    @Published var selectedLetterSpacing: LetterSpacing = .normal
    @Published var selectedParagraphSpacing: ParagraphSpacing = .normal

    @Published var context = RichTextContext()

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
        extractedText = applyFontAttributesUseCase.execute(text: extractedText, fontSize: fontSize, fontWeight: fontWeight)
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
        switch newFontFamily {
        case .sfPro:
            fontFamily = NSFont(name: "SF Pro", size: fontSize) ?? NSFont.systemFont(ofSize: fontSize)
        case .tahoma:
            fontFamily = NSFont(name: "Tahoma", size: fontSize) ?? NSFont.systemFont(ofSize: fontSize)
        case .sansSerif:
            fontFamily = NSFont.systemFont(ofSize: fontSize)
        }
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
            segmentColoringMode = .line
        case .large:
            segmentColoringMode = .line
        case .extraLarge:
            segmentColoringMode = .line
        }
    }
    
    func setLetterSpacing(to newLetterSpacing: LetterSpacing) {
        switch newLetterSpacing {
        case .normal:
            segmentColoringMode = .line
        case .large:
            segmentColoringMode = .line
        case .extraLarge:
            segmentColoringMode = .line
        }
    }
    
    func setParagraphSpacing(to newParagraphSpacing: ParagraphSpacing) {
        switch newParagraphSpacing {
        case .normal:
            segmentColoringMode = .line
        case .large:
            segmentColoringMode = .line
        case .extraLarge:
            segmentColoringMode = .line
        }
    }
}
