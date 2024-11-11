//
//  buzz_appApp.swift
//  buzz-app
//
//  Created by Anthony on 07/10/24.
//
import SwiftUI

@main
struct buzz_appApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, minHeight: 600)
                .environmentObject(appDelegate.viewModel)
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
