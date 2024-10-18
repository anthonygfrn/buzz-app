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
    @State private var activeToolbar: ActiveToolbar = .main // Default is the main toolbar

    var body: some View {
        ZStack {
            HStack {
                if activeToolbar == .main {
                    // Main toolbar buttons
                    ToolbarButton(iconName: "textformat", customImage: nil) {
                        activeToolbar = .textFormat // Show child buttons for text format
                    }
                    
                    ToolbarButton(iconName: "arrow.up.and.down.text.horizontal", customImage: nil) {
                        activeToolbar = .textSpacing // Another text alignment example
                    }
                    
                    ToolbarButton(iconName: "text.justify.left", customImage: nil) {
                        activeToolbar = .textAlign // Show child buttons for text alignment
                    }
                    
                    // Using a custom image for the palette button
                    ToolbarButton(iconName: nil, customImage: Image("Color-Mode")) {
                        activeToolbar = .palette // Show child buttons for color palette
                    }
                } else if activeToolbar == .textFormat {
                    // Left chevron button to go back to main toolbar
                    Button(action: {
                            activeToolbar = .main // Return to main toolbar
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 24)) // Customize icon size if needed
                                .padding() // Add padding if required for alignment
                        }
                        .buttonStyle(PlainButtonStyle())
                    // Child buttons for text format (Font, Size, Weight pickers)
                    Picker(items: ["SF Pro", "Tahoma", "Sans Serif"]) // Font picker
                    Picker(items: ["Normal", "Large", "Extra Large"]) // Size picker
                    Picker(items: ["Regular", "Bold"]) // Weight picker
                } else if activeToolbar == .textSpacing {
                    Button(action: {
                        activeToolbar = .main // Return to main toolbar
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24)) // Customize icon size if needed
                            .padding() // Add padding if required for alignment
                    }
                    .buttonStyle(PlainButtonStyle())

                    // Child buttons for text format (Font, Size, Weight pickers)
                    Picker(items: ["SF Pro", "Tahoma", "Sans Serif"])
                    Picker(items: ["Normal", "Large", "Extra Large"])
                    Picker(items: ["Regular", "Bold"]) // Weight picker
                } else if activeToolbar == .textAlign {
                    Button(action: {
                            activeToolbar = .main // Return to main toolbar
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
                } else if activeToolbar == .palette {
                    // Left chevron button to go back to main toolbar
                    Button(action: {
                        activeToolbar = .main // Return to main toolbar
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24)) // Customize icon size if needed
                            .padding() // Add padding if required for alignment
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Container for a pair of buttons inside one rounded rectangle
                    HStack(spacing: 20) {
                        HStack(spacing: 10) {
                            // First button (e.g., Bold Text Button)
                            Button(action: {
                                print("Bold button tapped")
                            }) {
                                Image(systemName: "character")
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
                                Image(systemName: "a.square.fill")
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
            if activeToolbar == .main {
                HStack {
                    Spacer() // Pushes the Reset button to the right

                    // Reset button as clickable text
                    Text("Reset All")
                        .font(.title) // Apply title font style
                        .bold() // Emphasize the text
                        .foregroundColor(.red)
                        .onTapGesture {
                            activeToolbar = .main // Reset to the main toolbar
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

#Preview {
    CustomToolbar()
}
