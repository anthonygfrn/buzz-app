//
//  ToolbarButton.swift
//  buzz-app
//
//  Created by Anthony on 16/10/24.
//

import SwiftUI

struct ToolbarButton: View {
    let iconName: String? // SF Symbol name (optional for custom image)
    let customImage: Image? // Custom image (optional)
    let action: () -> Void // Action closure for button tap

    // State for hover effect
    @State private var isHovered: Bool = false

    var body: some View {
        Button(action: action) {
            if let iconName = iconName {
                // SF Symbol Button (smaller symbol, larger padding)
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24) // Smaller SF Symbol
                    .foregroundColor(.black)
                    .padding(16)
                    .font(.title)
                    .bold()
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 1.5)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isHovered ? Color.black.opacity(0.2) : Color.clear)
                            )
                    )
                    .frame(width: 64, height: 64) // Outer frame remains the same
            } else if let customImage = customImage {
                // Custom Image Button (larger image, smaller padding)
                customImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48) // Larger custom image
                    .padding(4) // Smaller padding for custom image
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray, lineWidth: 1.5)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isHovered ? Color.black.opacity(0.2) : Color.clear)
                            )
                    )
                    .frame(width: 64, height: 64) // Same outer frame size
            }
        }
        .buttonStyle(PlainButtonStyle()) // Ensure default button style is plain
        .onHover { hovering in
            isHovered = hovering
            // Explicitly set the cursor to pointing hand when hovering
            if hovering {
                NSCursor.pointingHand.push()
            } else {
                NSCursor.pop() // Return to the default cursor when not hovering
            }
        }
        .onExitCommand {
            // Fallback: Reset cursor when exiting the button area
            NSCursor.arrow.set()
        }
    }
}

#Preview {
    ToolbarButton(iconName: "textformat", customImage: nil, action: {
        print("Button tapped")
    })
}
