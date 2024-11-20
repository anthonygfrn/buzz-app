//
//  ContentView.swift
//  buzz-app
//
//  Created by Anthony on 20/11/24.
//

import SwiftUI
import PDFKit
import RichTextKit

struct ContentView: View {
    @EnvironmentObject var viewModel: PDFViewModel
    @State private var showPopup = false // Onboarding popup state

    var body: some View {
        ZStack {
            // Main Content
            VStack(spacing: 0) {
                // Top Gray Bar
                Divider() // Optional divider below the title bar

                // Main Content Area
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
                }
                .background(Color("BgColor"))
            }

            // Overlay the Onboarding Popup if `showPopup` is true
            if showPopup {
                ZStack {
                    // Background overlay
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showPopup = false // Close popup when background is tapped
                        }

                    // Onboarding Popup
                    OnboardingView(showPopup: $showPopup)
                        .frame(maxWidth: 1051, maxHeight: 717)
                        .transition(.scale) // Smooth scale effect
                }
                .animation(.easeInOut(duration: 0.3), value: showPopup)
            }
        }
        .onAppear {
            handleFirstLaunch()

            if viewModel.extractedText.length == .zero {
                openPDFPicker()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text(viewModel.fileName.isEmpty ? "Untitled.pdf" : viewModel.fileName)
                    .font(.system(size: 13))
                    .foregroundColor(.black)
            }
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    showPopup = true
                }) {
                    Image(systemName: "questionmark")
                        .renderingMode(.template)
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color("Question"))
                        .frame(maxHeight: .infinity, alignment: .center)
                }
            }
        }
    }

    func handleFirstLaunch() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "HasSeenOnboarding")
        if !hasSeenOnboarding {
            showPopup = true
            UserDefaults.standard.set(true, forKey: "HasSeenOnboarding")
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
                    viewModel.title = url.lastPathComponent // Update title with file name

                    // Create a PDFDocument from the URL
                    if let pdfDocument = PDFDocument(url: url) {
                        // Retrieve document attributes
                        if let attributes = pdfDocument.documentAttributes {
                            let title = attributes[PDFDocumentAttribute.titleAttribute] as? String ?? ""
                            viewModel.title = title.isEmpty ? url.lastPathComponent : title
                        } else {
                            viewModel.title = url.lastPathComponent
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
