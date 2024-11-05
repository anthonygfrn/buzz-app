import PDFKit
import RichTextKit
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PDFViewModel(
        extractPDFTextUseCase: ExtractPDFTextUseCase(repository: PDFRepository()),
        applyColorModeUseCase: ApplyColorModeUseCase(),
        applyFontAttributesUseCase: ApplyFontAttributesUseCase()
    )
    
    @StateObject var darkModeViewModel = DarkModeViewModel()
    
    var body: some View {
        VStack(spacing: 0) { // Mengatur spacing menjadi 0 untuk menghilangkan ruang kosong
            GeometryReader { geometry in
                
                let totalWidth = geometry.size.width
                let contentWidth: CGFloat = min(totalWidth * 0.80, 1424)
                let totalHeight = geometry.size.height
                let sidePadding = (totalWidth - contentWidth) / 2
                ScrollView {
                
                    
                    VStack {
                        RichTextEditor(text: $viewModel.extractedText, context: viewModel.context)
                            .frame(width: contentWidth, height: totalHeight)
                            .fixedSize(horizontal: true, vertical: true)
//                            .disabled(true)
                          
                     
                    }
                    .padding(.leading, sidePadding)
                    .padding(.trailing, sidePadding)

                }

                .background(Color("BgColor"))
            }
            CustomToolbar()
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
        
        if panel.runModal() == .OK {
            if let url = panel.url {
                viewModel.openPDF(url: url)
                
                // Set the window title to the file name
                if let window = NSApplication.shared.windows.first {
                    window.title = url.lastPathComponent // Nama file PDF
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
