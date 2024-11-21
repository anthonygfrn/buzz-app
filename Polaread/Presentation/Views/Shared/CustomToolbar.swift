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
    @EnvironmentObject var toolbarViewModel : ToolBarViewModel
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ZStack {
            HStack {
                if toolbarViewModel.activeToolbar == .main {
                    // Main toolbar buttons
                    ToolbarButton(iconName: "textformat", customImage: nil, overlayOpacity: 0.2, action: {
                        toolbarViewModel.activeToolbar = .textFormat
                    }, isSelected: toolbarViewModel.activeToolbar == .textFormat)

                    ToolbarButton(iconName: "arrow.up.and.down.text.horizontal", customImage: nil, overlayOpacity: 0.2, action: {
                        toolbarViewModel.setActiveToolbar(.textSpacing)
                    }, isSelected: toolbarViewModel.activeToolbar == .textSpacing)

                    ToolbarButton(iconName: "text.justify.left", customImage: nil, overlayOpacity: 0.2, action: {
                        toolbarViewModel.setActiveToolbar(.textAlign)
                    }, isSelected: toolbarViewModel.activeToolbar == .textAlign)

                    ToolbarButton(iconName: nil, customImage: Image("Color-Mode"), overlayOpacity: 0.2, action: {
                        toolbarViewModel.setActiveToolbar(.palette)
                    }, isSelected: toolbarViewModel.activeToolbar == .palette)
                } else if toolbarViewModel.activeToolbar == .textFormat {
                    BackButton {
                        toolbarViewModel.setActiveToolbar(.main)
                    }

                    EnumPicker(idPicker: 0, selectedItem: $pdfViewModel.selectedFontFamily, items: FontFamily.allCases, imageName: "textformat", assetImageName: nil)
                        .padding(.horizontal, 0)
                        .frame(width: 264)
                        .onChange(of: pdfViewModel.selectedFontFamily) { newValue in
                            pdfViewModel.setSelectedFontFamily(to: newValue)
                        }

                    EnumPicker(idPicker: 1, selectedItem: $pdfViewModel.selectedFontSize, items: FontSizePicker.allCases, imageName: "textformat.size", assetImageName: nil)
                        .padding(.horizontal, 0)
                        .frame(width: 264)
                        .onChange(of: pdfViewModel.selectedFontSize) { newValue in
                            pdfViewModel.setSelectedFontSize(to: newValue)
                        }

                    EnumPicker(idPicker: 2, selectedItem: $pdfViewModel.selectedFontWeight, items: FontWeightPicker.allCases, imageName: "bold", assetImageName: nil)
                        .padding(.horizontal, 0)
                        .frame(width: 264)
                        .onChange(of: pdfViewModel.selectedFontWeight) { newValue in
                            pdfViewModel.setSelectedFontWeight(to: newValue)
                        }
                } else if toolbarViewModel.activeToolbar == .textSpacing {
                    BackButton {
                        toolbarViewModel.setActiveToolbar(.main)
                    }

                    EnumPicker(idPicker: 3, selectedItem: $pdfViewModel.selectedLineSpacing, items: LineSpacing.allCases, imageName: "arrow.up.and.down.text.horizontal", assetImageName: nil)
                        .padding(.horizontal, 0)
                        .frame(width: 264)
                        .onChange(of: pdfViewModel.selectedLineSpacing) { newValue in
                            pdfViewModel.setLineSpacing(to: newValue)
                        }

                    EnumPicker(idPicker: 4, selectedItem: $pdfViewModel.selectedLetterSpacing, items: LetterSpacing.allCases, imageName: nil, assetImageName: "space.character")
                        .padding(.horizontal, 0)
                        .frame(width: 264)
                        .onChange(of: pdfViewModel.selectedLetterSpacing) { newValue in
                            pdfViewModel.setLetterSpacing(to: newValue)
                        }

                    EnumPicker(idPicker: 5, selectedItem: $pdfViewModel.selectedParagraphSpacing, items: ParagraphSpacing.allCases, imageName: "text.justify.left", assetImageName: nil)
                        .padding(.horizontal, 0)
                        .frame(width: 264)
                        .onChange(of: pdfViewModel.selectedParagraphSpacing) { newValue in
                            pdfViewModel.setParagraphSpacing(to: newValue)
                        }
                } else if toolbarViewModel.activeToolbar == .textAlign {
                    BackButton {
                        toolbarViewModel.setActiveToolbar(.main)
                    }
                    
                    HStack(spacing: 5) {
                        ToolbarButton(iconName: "text.alignleft", customImage: nil, overlayOpacity: 0, action: {
                            pdfViewModel.setSelectedTextAlignment(to: .left)
                        }, isSelected: pdfViewModel.selectedTextAlignment == .left)
                        .cornerRadius(12)

                        ToolbarButton(iconName: "text.aligncenter", customImage: nil, overlayOpacity: 0, action: {
                            pdfViewModel.setSelectedTextAlignment(to: .center)
                        }, isSelected: pdfViewModel.selectedTextAlignment == .center)
                        .cornerRadius(12)

                        ToolbarButton(iconName: "text.alignright", customImage: nil, overlayOpacity: 0, action: {
                            pdfViewModel.setSelectedTextAlignment(to: .right)
                        }, isSelected: pdfViewModel.selectedTextAlignment == .right)
                        .cornerRadius(12)

                        ToolbarButton(iconName: "text.justify.leading", customImage: nil, overlayOpacity: 0, action: {
                            pdfViewModel.setSelectedTextAlignment(to: .justified)
                        }, isSelected: pdfViewModel.selectedTextAlignment == .justified)
                        .cornerRadius(12)
                    }
                    .padding(6)
                } else if toolbarViewModel.activeToolbar == .palette {
                    BackButton {
                        toolbarViewModel.setActiveToolbar(.main)
                    }

                    HStack(spacing: 20) {
                        HStack(spacing: 12) {
                            PaletteButton(
                                iconName: nil,
                                assetImage: Image(pdfViewModel.coloringStyle == .text || colorScheme == .dark ? "letter-2" : "letter-1"),
                                isSelected: pdfViewModel.coloringStyle == .text,
                                action: { pdfViewModel.setColoringStyle(to: .text) }
                            )

                            PaletteButton(
                                iconName: nil,
                                assetImage: Image(pdfViewModel.coloringStyle == .highlight ? "highlight-selected" : "highlight"),
                                isSelected: pdfViewModel.coloringStyle == .highlight,
                                action: { pdfViewModel.setColoringStyle(to: .highlight) }
                            )
                        }
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.5), lineWidth: 2))
                    }

                    HStack(spacing: 20) {
                        PaletteButton(
                            iconName: "text.justify",
                            assetImage: nil,
                            isSelected: pdfViewModel.segmentColoringMode == .line,
                            action: { pdfViewModel.setSegmentedControlValue(to: .line) }
                        )

                        PaletteButton(
                            iconName: "text.word.spacing",
                            assetImage: nil,
                            isSelected: pdfViewModel.segmentColoringMode == .sentence,
                            action: { pdfViewModel.setSegmentedControlValue(to: .sentence) }
                        )

                        PaletteButton(
                            iconName: "text.justify.left",
                            assetImage: nil,
                            isSelected: pdfViewModel.segmentColoringMode == .paragraph,
                            action: { pdfViewModel.setSegmentedControlValue(to: .paragraph) }
                        )

                        PaletteButton(
                            iconName: nil,
                            assetImage: Image(pdfViewModel.segmentColoringMode == .punctuation || colorScheme == .dark ? "Punctuation-1" : "Punctuation-2"),
                            isSelected: pdfViewModel.segmentColoringMode == .punctuation,
                            action: { pdfViewModel.setSegmentedControlValue(to: .punctuation) }
                        )
                    }
                    .padding(8)
                    .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.5), lineWidth: 2))
                }
                Spacer() // Pushes buttons to the left
            }
            .padding(.leading, 88) // Add margin on the left

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
                            pdfViewModel.resetAllStyling()
                        }
                }
                .padding(.trailing, 88) // Add same margin as the left for the Reset button
            }
        }
        .environmentObject(toolbarViewModel)
        .padding()
        .frame(maxWidth: .infinity, minHeight: 126, maxHeight: 126) // Adjusted toolbar height
        .background(Color("BgColor"))
        .overlay(
            Rectangle() // Straight top line for outline
                .frame(height: 2)
                .foregroundColor(Color.gray.opacity(0.3)),
            alignment: .top // The line appears only at the top
        )
        .padding([.leading, .trailing], 0) // Ensure full width with no side padding
    }
}
