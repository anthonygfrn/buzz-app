import Foundation
import PDFKit
import RichTextKit

class PDFViewModel: ObservableObject {
    @Published var extractedText = NSAttributedString("")
    @Published var rawText = ""
    @Published var figures: [Figure] = []
    @Published var segmentColoringMode: SegmentColoringMode = .line
    @Published var coloringStyle: ColoringStyle = .highlight
    @Published var containerWidth: CGFloat = 800
    @Published var shouldShowPDFPicker: Bool = true
    @Published var isLoading: Bool = true

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
    @Published var pdfUploadService = PDFUploadService()

//    Use Case
    private let extractPDFTextUseCase: ExtractPDFTextUseCase
    private var applyColorModeUseCase: ApplyColorModeUseCase
    private let applyFontAttributesUseCase: ApplyFontAttributesUseCase

    init(extractPDFTextUseCase: ExtractPDFTextUseCase, applyColorModeUseCase: ApplyColorModeUseCase, applyFontAttributesUseCase: ApplyFontAttributesUseCase) {
        self.extractPDFTextUseCase = extractPDFTextUseCase
        self.applyColorModeUseCase = applyColorModeUseCase
        self.applyFontAttributesUseCase = applyFontAttributesUseCase

        context.isEditable = false
    }

    func openPDF(url: URL) {
        isLoading = true // Mulai loading

        // Ekstraksi teks secara lokal
        DispatchQueue.global(qos: .userInitiated).async {
            if let document = self.extractPDFTextUseCase.execute(url: url) {
                DispatchQueue.main.async {
                    self.rawText = document.rawText
//                    self.extractedText = NSAttributedString(string: document.rawText)
                    self.recolorText()
                }
            }
        }

        // Panggil API untuk ekstraksi gambar secara paralel
        uploadPDFForImageExtraction(pdfURL: url)
    }

    private func uploadPDFForImageExtraction(pdfURL: URL) {
        let attributedString = NSMutableAttributedString(attributedString: extractedText)

        pdfUploadService.uploadPDFToAPI(pdfURL: pdfURL) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (fullText, figures)):
                    self?.rawText = fullText
                    self?.figures = figures.map { figure in
                        Figure(title: figure.title, position: figure.position, imageData: figure.imageData)
                    }

                    self?.buildAttributedText()

                case .failure(let error):
                    print("Error uploading PDF for image extraction: \(error)")
                }

                self?.isLoading = false
            }
        }
    }

    private func buildAttributedText() {
        // Format the text to ensure section titles and paragraphs are handled properly
        var formattedText = formatTextWithTitles(rawText)

        // Create an attributed string from the formatted text
        let attributedString = NSMutableAttributedString(string: formattedText)
        var offset = 0
        var figureCounter = 1 // Counter for figure labels (Figure 1, Figure 2, ...)

        for figure in figures {
            // Update the figure position based on current offset
            let updatedPosition = figure.position + offset

            // Insert an image with a newline before and a label after
            if let image = NSImage(data: figure.imageData) {
                let attachment = NSTextAttachment()
                attachment.image = image
                let imageString = NSAttributedString(attachment: attachment)

                // Insert newline before the image
                let newlineBeforeImage = NSAttributedString(string: "\n")
                attributedString.insert(newlineBeforeImage, at: updatedPosition)
                offset += newlineBeforeImage.length

                // Insert the image at the correct position
                if updatedPosition + newlineBeforeImage.length < attributedString.length {
                    attributedString.insert(imageString, at: updatedPosition + newlineBeforeImage.length)
                    offset += 1 // Increase offset for the length of the image attachment
                }

                // Add a label "Figure x" after the image
                let figureLabel = NSAttributedString(string: "\nFigure \(figureCounter)\n")
                attributedString.insert(figureLabel, at: updatedPosition + newlineBeforeImage.length + 1)
                offset += figureLabel.length

                // Increment the figure counter for the next figure
                figureCounter += 1
            }
        }

        // Update the extracted text to be used in the editor
        extractedText = attributedString
        context.setAttributedString(to: attributedString)
        recolorText()
    }

    private func formatTextWithTitles(_ text: String) -> String {
        let lines = text.components(separatedBy: .newlines)
        var formattedText = ""
        var currentParagraph = ""

        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)

            if trimmedLine.isEmpty {
                // Add current paragraph if it's not empty, then reset
                if !currentParagraph.isEmpty {
                    formattedText += currentParagraph + "\n\n"
                    currentParagraph = ""
                }
            } else if isSectionTitle(trimmedLine) {
                // Add current paragraph before section title, then format the title
                if !currentParagraph.isEmpty {
                    formattedText += currentParagraph + "\n\n"
                    currentParagraph = ""
                }
                formattedText += "\n\n" + trimmedLine + "\n\n"
            } else {
                // Append to current paragraph with a space if not the first word
                if !currentParagraph.isEmpty {
                    currentParagraph += " "
                }
                currentParagraph += trimmedLine
            }
        }

        // Append any remaining paragraph
        if !currentParagraph.isEmpty {
            formattedText += currentParagraph + "\n\n"
        }

        return formattedText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func isSectionTitle(_ line: String) -> Bool {
        let sectionTitles = [
            "KESIMPULAN", "REFERENSI", "ABSTRAK", "ABSTRACT", "PENDAHULUAN",
            "METODE", "HASIL DAN PEMBAHASAN", "Introduction", "Survey Methodology", "References",
            "1. Introduction", "2. Literature Review", "3. Research Methodology", "4. Data Analysis", "5. Discussion", "6. Implications", "7. Limitations and future work", "8. Conclusion"
        ]

        let titlePattern = sectionTitles.joined(separator: "|")
        let regexPattern = #"(?i)^\s*(?:\#(titlePattern))\s*$"#
        return line.range(of: regexPattern, options: .regularExpression) != nil
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
