import Foundation
import PDFKit
import RichTextKit

class PDFViewModel: ObservableObject {
    @Published var extractedText = NSAttributedString("")
    @Published var rawText = ""
    @Published var extractedImages: [NSImage] = []
    @Published var isLoading = true
    
    @Published var segmentColoringMode: SegmentColoringMode = .line
    @Published var coloringStyle: ColoringStyle = .highlight

    @Published var selectedFontSize: FontSizePicker = .normal
    @Published var selectedFontWeight: FontWeightPicker = .regular
    @Published var selectedFontFamily: FontFamily = .SFPro
    @Published var selectedLineSpacing: LineSpacing = .normal
    @Published var selectedLetterSpacing: LetterSpacing = .normal
    @Published var selectedParagraphSpacing: ParagraphSpacing = .normal
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
    private let pdfUploadService = PDFUploadService()

    init(extractPDFTextUseCase: ExtractPDFTextUseCase, applyColorModeUseCase: ApplyColorModeUseCase, applyFontAttributesUseCase: ApplyFontAttributesUseCase) {
        self.extractPDFTextUseCase = extractPDFTextUseCase
        self.applyColorModeUseCase = applyColorModeUseCase
        self.applyFontAttributesUseCase = applyFontAttributesUseCase
    }

    func openPDF(url: URL) {
        isLoading = true  // Mulai loading
        
        // Ekstraksi teks secara lokal
        DispatchQueue.global(qos: .userInitiated).async {
            if let document = self.extractPDFTextUseCase.execute(url: url) {
                DispatchQueue.main.async {
                    self.rawText = document.rawText
                    self.extractedText = NSAttributedString(string: document.rawText)
                    self.recolorText()
                }
            }
        }
        
        // Panggil API untuk ekstraksi gambar secara paralel
        uploadPDFForImageExtraction(pdfURL: url)
    }
    
    // Fungsi untuk mengunggah PDF ke API dan mengekstrak gambar
    private func uploadPDFForImageExtraction(pdfURL: URL) {
        pdfUploadService.uploadPDFToAPI(pdfURL: pdfURL) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let images):
                    self?.extractedImages = images
                case .failure(let error):
                    print("Error uploading PDF for image extraction: \(error)")
                }
                
                self?.isLoading = false
            }
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

    func setSelectedFontFamily(to newFontFamily: FontFamily) {
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
            lineSpacing = 2.5
        case .extraLarge:
            lineSpacing = 4
        }

        modifyFontAttributes()
    }

    func setLetterSpacing(to newLetterSpacing: LetterSpacing) {
        switch newLetterSpacing {
        case .normal:
            letterSpacing = 1 * lineSpacing
        case .large:
            letterSpacing = 1.5 * lineSpacing
        case .extraLarge:
            letterSpacing = 2 * lineSpacing
        }

        modifyFontAttributes()
    }

    func setParagraphSpacing(to newParagraphSpacing: ParagraphSpacing) {
        switch newParagraphSpacing {
        case .normal:
            paragraphSpacing = 2 * lineSpacing
        case .large:
            paragraphSpacing = 2.5 * lineSpacing
        case .extraLarge:
            paragraphSpacing = 3 * lineSpacing
        }

        modifyFontAttributes()
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
        modifyFontAttributes()
    }

    func resetAllStyling() {
        fontSize = 18
        fontWeight = .regular
        fontFamily = "SF Pro"
        lineSpacing = 0
        letterSpacing = 1
        paragraphSpacing = 2
        textAlignment = "left"

        selectedFontSize = .normal
        selectedFontWeight = .regular
        selectedFontFamily = .SFPro
        selectedLineSpacing = .normal
        selectedLetterSpacing = .normal
        selectedParagraphSpacing = .normal
        selectedTextAlignment = .left

        modifyFontAttributes()
    }
}
