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

    var body: some View {
        ZStack {
            HStack {
                if toolbarViewModel.activeToolbar == .main {
                    // Main toolbar buttons
                    ToolbarButton(iconName: "textformat", customImage: nil) {
                        toolbarViewModel.activeToolbar = .textFormat // Show child buttons for text format
                    }

                    ToolbarButton(iconName: "arrow.up.and.down.text.horizontal", customImage: nil) {
                        toolbarViewModel.setActiveToolbar(.textSpacing)
                    }

                    ToolbarButton(iconName: "text.justify.left", customImage: nil) {
                        toolbarViewModel.setActiveToolbar(.textAlign)
                    }

                    ToolbarButton(iconName: nil, customImage: Image("Color-Mode")) {
                        toolbarViewModel.setActiveToolbar(.palette)
                    }
                } else if toolbarViewModel.activeToolbar == .textFormat {
                    // Back Button
                    Button(action: {
                        toolbarViewModel.setActiveToolbar(.main)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                            .padding()
                    }
                    .buttonStyle(PlainButtonStyle())

                    // Font Family
                    EnumPicker(selectedItem: $pdfViewModel.selectedFontFamily, items: FontFamilyPicker.allCases)
                        .padding()
                        .onChange(of: pdfViewModel.selectedFontFamily) { newValue in
                            pdfViewModel.setSelectedFontFamily(to: newValue)
                        }

                    // Font Size
                    EnumPicker(
                        selectedItem: $pdfViewModel.selectedFontSize,
                        items: FontSizePicker.allCases
                    )
                    .padding()
                    .onChange(of: pdfViewModel.selectedFontSize) { newValue in
                        pdfViewModel.setSelectedFontSize(to: newValue)
                    }

                    // Font Weight
                    EnumPicker(
                        selectedItem: $pdfViewModel.selectedFontWeight,
                        items: FontWeightPicker.allCases
                    )
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

                    // Child buttons for text format (Font, Size, Weight pickers)
                    Picker(selectedItem: .constant("Default"), items: ["SF Pro", "Tahoma", "Sans Serif"])
                    Picker(selectedItem: .constant("Default"), items: ["Normal", "Large", "Extra Large"])
                    Picker(selectedItem: .constant("Default"), items: ["Regular", "Bold"]) // Weight picker
                } else if toolbarViewModel.activeToolbar == .textAlign {
                    Button(action: {
                        toolbarViewModel.setActiveToolbar(.main)
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24)) // Customize icon size if needed
                            .padding() // Add padding if required for alignment
                    }
                    .buttonStyle(PlainButtonStyle())
                    HStack(spacing: 20) {
                        ToolbarButton(iconName: "text.alignleft", customImage: nil) {
                            print("Align Left tapped")
                        }

                        ToolbarButton(iconName: "text.aligncenter", customImage: nil) {
                            print("Align Center tapped")
                        }

                        ToolbarButton(iconName: "text.alignright", customImage: nil) {
                            print("Align Right tapped")
                        }

                        ToolbarButton(iconName: "text.justify.leading", customImage: nil) {
                            print("Justify tapped")
                        }
                    }
                    .padding(12)
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
                        HStack(spacing: 10) {
                            Button(action: {
                                pdfViewModel.setColoringStyle(to: .text)
                            }) {
                                Image(systemName: "character")
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(pdfViewModel.coloringStyle == .text ? Color.blue : Color.gray)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())

                            Button(action: {
                                pdfViewModel.setColoringStyle(to: .highlight)
                            }) {
                                Image(systemName: "a.square.fill")
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(pdfViewModel.coloringStyle == .highlight ? Color.blue : Color.gray)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(12)
                        .background(RoundedRectangle(cornerRadius: 20).stroke(Color.gray.opacity(0.5), lineWidth: 2)) // Rounded rectangle border around both buttons
                    }
                    HStack(spacing: 20) {
                        HStack(spacing: 10) {
                            // First button (e.g., Bold Text Button)
                            Button(action: {
                                print("Bold button tapped")
                            }) {
                                Image(systemName: "text.justify.left")
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())

                            // Second button (e.g., Light Text Button)
                            Button(action: {
                                print("Light text button tapped")
                            }) {
                                Image(systemName: "text.word.spacing")
                                    .foregroundColor(.white)
                                    .padding(12)
                                    .background(Color.gray)
                                    .cornerRadius(10)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(12)
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

// #Preview {
//    CustomToolbar()
// }
