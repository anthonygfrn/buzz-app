//
//  OpenPDFCommand.swift
//  Polaread
//
//  Created by Anthony on 22/11/24.
//

import SwiftUI

struct OpenPDFCommand: Commands {
    var body: some Commands {
        CommandGroup(replacing: .newItem) { // Add to the "File" menu
            Button("Open PDF in New Window") {
                openNewWindow()
            }
            .keyboardShortcut("O", modifiers: [.command]) // Optional: Add a shortcut
        }
    }

    private func openNewWindow() {
        // Create a new window with a fresh `PDFViewModel`
        let newScene = NSWindow(contentViewController: NSHostingController(
            rootView: ContentView()
                .environmentObject(PDFViewModel(
                    extractPDFTextUseCase: ExtractPDFTextUseCase(repository: PDFRepository()),
                    applyColorModeUseCase: ApplyColorModeUseCase(),
                    applyFontAttributesUseCase: ApplyFontAttributesUseCase()
                ))
                .environmentObject(ToolBarViewModel())
        ))
        newScene.title = "New PDF Window"
        newScene.makeKeyAndOrderFront(nil)
    }
}
