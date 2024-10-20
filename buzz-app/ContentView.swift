import PDFKit
import RichTextKit
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PDFViewModel(
        extractPDFTextUseCase: ExtractPDFTextUseCase(repository: PDFRepository()),
        applyColorModeUseCase: ApplyColorModeUseCase(),
        applyFontAttributesUseCase: ApplyFontAttributesUseCase()
    )

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack {
                        // Calculate padding based on the screen width and given ratio
                        let totalWidth = geometry.size.width
                        let contentWidth: CGFloat = 1424 // Fixed content width based on ratio
                        let sidePadding = (totalWidth - contentWidth) / 2

                        // Center the RichTextEditor with calculated padding
                        RichTextEditor(text: $viewModel.extractedText, context: viewModel.context)
                            .frame(width: contentWidth, height: 888) // Set fixed width and height for the editor
                            .padding(.leading, max(sidePadding, 0))
                            .padding(.trailing, max(sidePadding, 0))
                    }
                }
            }

            CustomToolbar()
        }
        .environmentObject(viewModel)
        .background(Color.white) // Set the background color to white
        .onAppear {
            openPDFPicker() // Call the PDF picker when the view appears
        }
    }

    // Function to open PDF from Finder (macOS)
    func openPDFPicker() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["pdf"]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        if panel.runModal() == .OK {
            if let url = panel.url {
                viewModel.openPDF(url: url)
            }
        }
    }
}

#Preview {
    ContentView()
}
