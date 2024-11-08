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
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView("Loading PDF...") // Loading indicator
                    .padding()
            } else {
                GeometryReader { geometry in
                    let totalWidth = geometry.size.width
                    let contentWidth: CGFloat = min(totalWidth * 0.80, 1424)
                    let totalHeight = geometry.size.height
                    let sidePadding = (totalWidth - contentWidth) / 2
                    
                    ScrollView {
                        VStack {
                            // Tampilkan teks yang diekstrak beserta gambar menggunakan RichTextEditor
                            RichTextEditor(text: $viewModel.extractedText, context: viewModel.context)
                                .frame(width: contentWidth, height: totalHeight)
                                .fixedSize(horizontal: true, vertical: true)
                        }
                        .padding(.leading, sidePadding)
                        .padding(.trailing, sidePadding)
                    }
                    .background(Color("BgColor"))
                    .onChange(of: geometry.size.width) { newWidth in
                        viewModel.containerWidth = min(newWidth * 0.80, 1424)
                        if viewModel.segmentColoringMode == .line {
                            viewModel.recolorText()
                        }
                    }
                }
                CustomToolbar()
            }
        }
        .environmentObject(viewModel)
        .onAppear {
            openPDFPicker()
        }
    }
    
    func openPDFPicker() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["pdf"]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                viewModel.isLoading = true // Mulai loading hanya setelah memilih PDF
                viewModel.openPDF(url: url)
                
                // Set the window title to the file name
                if let window = NSApplication.shared.windows.first {
                    window.title = url.lastPathComponent
                }
            } else {
                viewModel.isLoading = false // Batalkan loading jika tidak memilih file
            }
        }
    }
}

#Preview {
    ContentView()
}
