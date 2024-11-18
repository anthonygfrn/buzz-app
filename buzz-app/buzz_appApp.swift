import SwiftUI

@main
struct buzz_appApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var toolbarViewModel = ToolBarViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .inspector(isPresented: $toolbarViewModel.isOpen) {
                    SideToolbarView()

                        .padding(.horizontal, 20)
                        .toolbar {
                            Spacer()
                            Button(action: {
                                toolbarViewModel.toggleIsOpen()
                            }) {
                                Image(systemName: "paintbrush.pointed.fill")
                            }
                        }
                }
                .frame(minWidth: 800, minHeight: 600)
                .environmentObject(appDelegate.viewModel)
                .environmentObject(toolbarViewModel)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var viewModel = PDFViewModel(
        extractPDFTextUseCase: ExtractPDFTextUseCase(repository: PDFRepository()),
        applyColorModeUseCase: ApplyColorModeUseCase(),
        applyFontAttributesUseCase: ApplyFontAttributesUseCase()
    )

    func application(_ application: NSApplication, open urls: [URL]) {
        if let firstURL = urls.first {
            if firstURL.pathExtension.lowercased() == "pdf" {
                viewModel.shouldShowPDFPicker = false // Prevent PDF picker when opening a file
                viewModel.openPDF(url: firstURL)
            }
        }
    }
}
