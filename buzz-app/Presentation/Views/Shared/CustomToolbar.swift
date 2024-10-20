//
//  CustomToolbar.swift
//  buzz-app
//
//  Created by Anthony on 16/10/24.
//

import SwiftUI

enum ActiveToolbar {
    case main
    case textFormat
    case textAlign
    case textSpacing
    case palette
}

struct CustomToolbar: View {
    @EnvironmentObject var pdfViewModel: PDFViewModel
    @StateObject var toolbarViewModel = ToolBarViewModel()
    @State private var selectedAlignment: String?

    var body: some View {
        ZStack {
            HStack {
                if toolbarViewModel.activeToolbar == .main {
                    // Main toolbar buttons
                    ToolbarButton(iconName: "textformat", customImage: nil, overlayOpacity: 0.2) {
                        toolbarViewModel.activeToolbar = .textFormat // Show child buttons for text format
                    }

                    ToolbarButton(iconName: "arrow.up.and.down.text.horizontal", customImage: nil, overlayOpacity: 0.2) {
                        toolbarViewModel.setActiveToolbar(.textSpacing)
                    }

                    ToolbarButton(iconName: "text.justify.left", customImage: nil, overlayOpacity: 0.2) {
                        toolbarViewModel.setActiveToolbar(.textAlign)
                    }

                    ToolbarButton(iconName: nil, customImage: Image("color-mode"),  overlayOpacity: 0.2) {
                        toolbarViewModel.setActiveToolbar(.palette)
                    }
                } else if toolbarViewModel.activeToolbar == .textFormat {
                    Button(action: {
                        toolbarViewModel.setActiveToolbar(.main)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle())

                    EnumPicker(selectedItem: $pdfViewModel.selectedFontFamily, items: FontFamilyPicker.allCases, imageName: "textformat", assetImageName: nil)
                        .padding(.horizontal, 0)
                        .frame(width: 264)
                        .onChange(of: pdfViewModel.selectedFontFamily) { newValue in
                            pdfViewModel.setSelectedFontFamily(to: newValue)
                        }

                    EnumPicker(selectedItem: $pdfViewModel.selectedFontSize, items: FontSizePicker.allCases, imageName: "textformat.size", assetImageName: nil)
                        .padding(.horizontal, 0)
                        .frame(width: 264)
                        .onChange(of: pdfViewModel.selectedFontSize) { newValue in
                            pdfViewModel.setSelectedFontSize(to: newValue)
                        }

                    EnumPicker(selectedItem: $pdfViewModel.selectedFontWeight, items: FontWeightPicker.allCases, imageName: "bold", assetImageName: nil)
                        .padding(.horizontal, 0)
                        .frame(width: 264)
                        .onChange(of: pdfViewModel.selectedFontWeight) { newValue in
                            pdfViewModel.setSelectedFontWeight(to: newValue)
                        }
                } else if toolbarViewModel.activeToolbar == .textSpacing {
                    Button(action: {
                        toolbarViewModel.setActiveToolbar(.main)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24)) // Customize icon size if needed
                            .padding() // Add padding if required for alignment
                    }
                    .buttonStyle(PlainButtonStyle())

                    EnumPicker(selectedItem: $pdfViewModel.selectedLineSpacing, items: LineSpacing.allCases, imageName: "arrow.up.and.down.text.horizontal", assetImageName: nil)
                        .padding(.horizontal, 0)
                        .frame(width: 264)
                        .onChange(of: pdfViewModel.selectedFontFamily) { newValue in
                            pdfViewModel.setSelectedFontFamily(to: newValue)
                        }

                    EnumPicker(selectedItem: $pdfViewModel.selectedLetterSpacing, items: LetterSpacing.allCases, imageName: nil, assetImageName: "space.character")
                        .padding(.horizontal, 0)
                        .frame(width: 264)
                        .onChange(of: pdfViewModel.selectedFontSize) { newValue in
                            pdfViewModel.setSelectedFontSize(to: newValue)
                        }

                    EnumPicker(selectedItem: $pdfViewModel.selectedParagraphSpacing, items: ParagraphSpacing.allCases, imageName: "text.justify.left", assetImageName: nil)
                        .padding(.horizontal, 0)
                        .frame(width: 264)
                        .onChange(of: pdfViewModel.selectedFontWeight) { newValue in
                            pdfViewModel.setSelectedFontWeight(to: newValue)
                        }
                } else if toolbarViewModel.activeToolbar == .textAlign {
                    Button(action: {
                        toolbarViewModel.setActiveToolbar(.main)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24)) // Customize icon size if needed
                            .padding() // Add padding if required for alignment
                    }
                    .buttonStyle(PlainButtonStyle())
                    HStack(spacing: 5) {
                        ToolbarButton(iconName: "text.alignleft", customImage: nil, overlayOpacity: 0) {
                            selectedAlignment = "left" // Set the selected state
                            print("Align Left tapped")
                        }
                        .background(selectedAlignment == "left" ? Color.blue : Color.clear) // Blue background when selected
                        .cornerRadius(12) // Add corner radius to match rounded rectangle

                        ToolbarButton(iconName: "text.aligncenter", customImage: nil, overlayOpacity: 0) {
                            selectedAlignment = "center"
                            print("Align Center tapped")
                        }
                        .background(selectedAlignment == "center" ? Color.blue : Color.clear)
                        .cornerRadius(12)

                        ToolbarButton(iconName: "text.alignright", customImage: nil, overlayOpacity: 0) {
                            selectedAlignment = "right"
                            print("Align Right tapped")
                        }
                        .background(selectedAlignment == "right" ? Color.blue : Color.clear)
                        .cornerRadius(12)

                        ToolbarButton(iconName: "text.justify.leading", customImage: nil, overlayOpacity: 0) {
                            selectedAlignment = "justify"
                            print("Justify tapped")
                        }
                        .background(selectedAlignment == "justify" ? Color.blue : Color.clear)
                        .cornerRadius(12)
                    }
                    .padding(6) // Reduced padding around the buttons
                    .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.3), lineWidth: 1.5)) // Rounded rectangle border
                } else if toolbarViewModel.activeToolbar == .palette {
                    // Left chevron button to go back to main toolbar
                    Button(action: {
                        toolbarViewModel.setActiveToolbar(.main) // Return to main toolbar
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24)) // Customize icon size if needed
                            .padding() // Add padding if required for alignment
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    HStack(spacing: 20) {
                        HStack(spacing: 12) {
                            Button(action: {
                                pdfViewModel.setColoringStyle(to: .text)
                            }) {
                                Image(systemName: "character")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32) // Make the image bigger
                                    .foregroundColor(.white)
                                    .padding(8) // Adjust padding to make button smaller
                                    .background(pdfViewModel.coloringStyle == .text ? Color.blue : Color.gray)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                pdfViewModel.setColoringStyle(to: .highlight)
                            }) {
                                Image(systemName: "a.square.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32) // Make the image bigger
                                    .foregroundColor(.white)
                                    .padding(8) // Adjust padding to make button smaller
                                    .background(pdfViewModel.coloringStyle == .highlight ? Color.blue : Color.gray)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(8) // Reduce padding around the buttons
                        .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.5), lineWidth: 2)) // Rounded rectangle border around both buttons
                    }
                    HStack(spacing: 20) {
                        HStack(spacing: 10) {
                            Button(action: {
                                pdfViewModel.setSegmentedControlValue(to: .sentence)
                            }) {
                                Image(systemName: "text.word.spacing")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32) // Make the image bigger
                                    .foregroundColor(.white)
                                    .padding(8) // Adjust padding to make button smaller
                                    .background(pdfViewModel.segmentColoringMode == .sentence ? Color.blue : Color.gray)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Button(action: {
                                pdfViewModel.setSegmentedControlValue(to: .line)
                            }) {
                                Image(systemName: "text.justify.left")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32, height: 32) // Make the image bigger
                                    .foregroundColor(.white)
                                    .padding(8) // Adjust padding to make button smaller
                                    .background(pdfViewModel.segmentColoringMode == .line ? Color.blue : Color.gray)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(8) // Reduce padding around the buttons
                        .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.5), lineWidth: 2)) // Rounded rectangle border around both buttons
                    }
                }

                Spacer() // Pushes buttons to the left
            }
            .padding(.leading, 88) // Add margin on the left

            // Show the Reset button only when in the main toolbar
            if toolbarViewModel.activeToolbar == .main {
                HStack {
                    Spacer() // Pushes the Reset button to the right

                    // Reset button as clickable text
                    Text("Reset All")
                        .font(.title) // Apply title font style
                        .bold() // Emphasize the text
                        .foregroundColor(.red)
                        .onTapGesture {
                            toolbarViewModel.setActiveToolbar(.main)
                            print("Reset All button tapped")
                        }
                }
                .padding(.trailing, 88) // Add same margin as the left for the Reset button
            }
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 126, maxHeight: 126) // Adjusted toolbar height
        .background(Color.white) // Background for the toolbar
        .overlay(
            Rectangle() // Straight top line for outline
                .frame(height: 2)
                .foregroundColor(Color.gray.opacity(0.3)),
            alignment: .top // The line appears only at the top
        )
        .padding([.leading, .trailing], 0) // Ensure full width with no side padding
    }
}
