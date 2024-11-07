//
//  buzz_appApp.swift
//  buzz-app
//
//  Created by Anthony on 07/10/24.
//

import SwiftUI

@main
struct buzz_appApp: App {
    var body: some Scene {
        @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

        WindowGroup {
            ContentView()
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
            // Pastikan URL adalah file PDF
            if firstURL.pathExtension.lowercased() == "pdf" {
                viewModel.openPDF(url: firstURL)
            }
        }
    }
}
