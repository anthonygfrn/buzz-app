import PDFKit
import RichTextKit
import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: PDFViewModel
    @State private var showPopup = false // Initially set to false
    
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
                            
                            RichTextEditor(text: $viewModel.displayedText, context: viewModel.context)
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
            }
            .background(Color("BgColor"))
            
            if showPopup {
                OnboardingView(showPopup: $showPopup)
            }
        }
        .onAppear {
            handleFirstLaunch()
            
            if viewModel.extractedText.length == .zero {
                openPDFPicker()
            }
        }
    }
    
    func handleFirstLaunch() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
        if !hasSeenOnboarding {
            showPopup = true
            UserDefaults.standard.set(true, forKey: "HasSeenOnboarding") // Mark onboarding as shown
        }
    }
    
    func openPDFPicker() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["pdf"]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false

        panel.begin { response in
            if response == .OK {
                if let url = panel.url {
                    // Create a PDFDocument from the URL
                    if let pdfDocument = PDFDocument(url: url) {
                        // Retrieve document attributes
                        if let attributes = pdfDocument.documentAttributes {
                            var title = attributes[PDFDocumentAttribute.titleAttribute] as? String ?? ""
                            title = "\n" + title + "\n\n"
                            viewModel.title = title
                        } else {
                            print("No metadata available in the PDF.")
                        }
                    } else {
                        print("Unable to open PDF.")
                    }
                    viewModel.openPDF(url: url)
                }
            }
        }
    }
}
