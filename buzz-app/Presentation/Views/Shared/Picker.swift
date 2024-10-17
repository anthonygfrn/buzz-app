//
//  Picker.swift
//  buzz-app
//
//  Created by Anthony on 17/10/24.
//

import SwiftUI

struct Picker: View {
    @State private var selectedItem: String = "Default"
    @State private var isMenuVisible: Bool = false
    let items: [String]

    var body: some View {
        VStack {
            if !isMenuVisible {
                // Picker container with SF Symbol "textformat" and item name
                HStack {
                    // SF Symbol "textformat" and selected item in one container
                    HStack {
                        Image(systemName: "textformat")
                            .font(.system(size: 24))
                            .padding(.trailing, 5)
                        
                        Text(selectedItem)
                            .font(.system(size: 16))
                        
                        Spacer()  // Allow space for the button
                        
                        // Dropdown button, toggles menu visibility
                        Button(action: {
                            withAnimation {
                                isMenuVisible.toggle()
                            }
                        }) {
                            Image(systemName: "chevron.up.chevron.down")
                                .foregroundColor(.white)
                                .font(.system(size: 20))  // Make the chevron icon bigger
                                .padding(8)
                                .background(Color.blue)
                                .cornerRadius(5)
                        }
                        .buttonStyle(PlainButtonStyle()) // Ensure the button is plain without a hover effect
                    }
                    .padding(.horizontal, 8)  // Adjusted padding
                    .padding(.vertical, 6)  // Adjusted padding
                    .background(Color.white) // Set picker background to white
                    .cornerRadius(16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.black, lineWidth: 1) // Set border to black
                    )
                }
                .frame(width: 264)
            }

            // Dropdown menu that overlays and covers the picker
            if isMenuVisible {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(items, id: \.self) { item in
                        Button(action: {
                            selectedItem = item
                            isMenuVisible = false
                        }) {
                            Text(item)
                                .foregroundColor(.white) // Always keep text white
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                        }
                        .background(Color.black.opacity(0.9)) // Menu stays dark
                        .buttonStyle(PlainButtonStyle()) // No hover or focus styling
                    }
                }
                .frame(width: 264)
                .background(Color.black.opacity(0.9)) // Menu stays black
                .cornerRadius(10)
                .shadow(radius: 5)
                .offset(y: -24) // Smooth overlay over the picker
            }
        }
        .padding()
        .background(Color.clear) // Transparent background to capture outside taps
        .onTapGesture {
            if isMenuVisible {
                isMenuVisible = false
            }
        }
    }
}

#Preview {
    Picker(items: ["SF Pro", "Tahoma", "Sans Serif"])
}
