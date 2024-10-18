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
            recolorText()
        }
    }

    func recolorText() {
        extractedText = applyColorModeUseCase.execute(text: rawText, segmentColorMode: segmentColoringMode, coloringStyle: coloringStyle)
        context.setAttributedString(to: extractedText)
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

    // Set font size and apply both size and weight
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

    // Set font weight and apply both size and weight
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
}
