import PDFKit
import RichTextKit
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = PDFViewModel(
        extractPDFTextUseCase: ExtractPDFTextUseCase(repository: PDFRepository()),
        applyColorModeUseCase: ApplyColorModeUseCase(),
        applyFontAttributesUseCase: ApplyFontAttributesUseCase()
    )
    
    @State private var showPopup = true // Default is true to show popup initially
    
    var body: some View {
        ZStack {
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
                                // Display extracted text with images using RichTextEditor
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
                let fontFamilies = NSFontManager.shared.availableFontFamilies
                for family in fontFamilies {
                    print("\(family)")
                    let fontNames = NSFontManager.shared.availableMembers(ofFontFamily: family)
                    fontNames?.forEach { font in
                        if let fontName = font.first as? String {
                            print("  Font Name: \(fontName)")
                        }
                    }
                }
                
                if viewModel.extractedText.length == .zero && !viewModel.isLoading {
                    openPDFPicker()
                }
            }
            
            // Overlay for popup with darkened background
            if showPopup{
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 32) {
                    Text("Let's enhance our reading experience")
                        .font(.system(size: 42))
                        .fontWeight(.bold)
                    
                    
                    HStack(spacing: 20) {
                        Icons(iconName: "textformat", customImage: nil)
                        Icons(iconName: "arrow.up.and.down.text.horizontal", customImage: nil)
                        Icons(iconName: "text.justify.left", customImage: nil)
                        Icons(iconName: nil, customImage: Image("Color-Mode"))
                    }
                    
                    Group{
                        Text("We’ve adjusted the ") +
                        Text("text style, spacing, ").bold() +
                        Text("and ") +
                        Text("paragraph alignment ").bold() +
                        Text("to\n make reading easier. Plus, we’ve added a ") +
                        Text("touch of color ").bold() +
                        Text("to help you keep\n track of where you are.")
                    }
                    .multilineTextAlignment(.center)
                    .font(.system(size: 18))
                    .padding()
                    
                    Text("If you have any preferences, feel free to customize everything using the\n toolbar at the bottom of your screen anytime!")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 18))
                        .padding()
                    
                    Button(action: { showPopup = false }) {
                        Text("Start reading")
                            .foregroundStyle(Color.white)
                            .font(.system(size: 18))
                    }
                    .frame(width: 155, height: 61, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(16)
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.horizontal, 128)
                .padding(.vertical, 64)
                .background(Color("Secondary"))
                .cornerRadius(16)
                .shadow(color: .black.opacity(0.25), radius: 32, x: 0, y: 20)
                .frame(maxWidth: 1051, maxHeight: 717)
            }
        }
    }
    
    func openPDFPicker() {
        let panel = NSOpenPanel()
        panel.allowedFileTypes = ["pdf"]
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        
        panel.begin { response in
            if response == .OK, let url = panel.url {
                viewModel.isLoading = true // Start loading only after selecting PDF
                viewModel.openPDF(url: url)
                
                // Set the window title to the file name
                if let window = NSApplication.shared.windows.first {
                    window.title = url.lastPathComponent
                }
            } else {
                viewModel.isLoading = false // Cancel loading if no file is selected
            }
        }
    }
}

#Preview {
    ContentView()
}

struct Icons: View {
    let iconName: String?
    let customImage: Image?
    
    var body: some View {
        if let iconName = iconName{
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundColor(Color("Default"))
                .padding(14)
                .background(Color("Secondary"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("LightOutlinePrimary"), lineWidth: 2)
                )
                .cornerRadius(12)
                .frame(width: 64, height: 64)
        } else if let customImage = customImage {
            customImage
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .padding(4)
                .background(Color("Secondary"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("LightOutlinePrimary"), lineWidth: 2)
                )
                .cornerRadius(12)
                .frame(width: 64, height: 64)
        }
    }
}
