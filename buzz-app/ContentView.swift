import PDFKit
import RichTextKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: PDFViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                GeometryReader { geometry in
                    ScrollView {
                        VStack {
                            let totalWidth = geometry.size.width
                            let totalHeight = geometry.size.height
                            let contentWidth: CGFloat = min(totalWidth * 0.80, 1424)
                            let sidePadding = (totalWidth - contentWidth) / 2

                            RichTextEditor(text: $viewModel.extractedText, context: viewModel.context)
                                .frame(width: contentWidth, height: totalHeight)
                                .padding(.leading, sidePadding)
                                .padding(.trailing, sidePadding)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .overlay(content: {
                        if viewModel.isLoading {
                            VStack {
                                Spacer()
                                ProgressView("Loading...")
                                Spacer()
                            }
                        }
                    })
                    .onChange(of: geometry.size.width) { newWidth in
                        viewModel.containerWidth = min(newWidth * 0.80, 1424)
                        if viewModel.segmentColoringMode == .line {
                            viewModel.recolorText()
                        }
                    }
                    .background(Color("BgColor"))
                }
//                CustomToolbar()
            }
            .background(Color("BgColor"))
        }
        .onAppear {
//            if viewModel.extractedText.length == .zero {
            print("hai")
            openPDFPicker()
//            }
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
            }
        }
    }
}

// #Preview {
//    ContentView()
//
// }
