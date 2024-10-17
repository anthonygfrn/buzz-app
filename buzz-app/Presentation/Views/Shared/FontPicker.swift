//
//  FontPicker.swift
//  buzz-app
//
//  Created by Anthony on 17/10/24.
//

import SwiftUI

struct FontPicker: View {
    @State private var selectedFont: String = "SF Pro"
    @State private var isMenuVisible: Bool = false
    let fonts = ["SF Pro", "Tahoma", "Sans Serif"]

    var body: some View {
        VStack {
            HStack {
                // "Aa" icon and selected font in one oval container
                HStack {
                    Text("Aa")
                        .font(.system(size: 24))
                        .padding(.trailing, 5)
                    
                    Text(selectedFont)
                        .font(.system(size: 16))
                    
                    Spacer()
                    
                    // Both chevron arrows in the same container
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundColor(.white)
                        .padding(6)
                        .background(Color.blue)
                        .cornerRadius(5)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 8)
                .background(Color(NSColor.windowBackgroundColor))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                )
                .onTapGesture {
                    withAnimation {
                        isMenuVisible.toggle()
                    }
                }
            }
            .frame(width: 200) // Adjust width to your preference
            
            // Dropdown menu when the picker is clicked
            if isMenuVisible {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(fonts, id: \.self) { font in
                        Button(action: {
                            selectedFont = font
                            isMenuVisible = false
                        }) {
                            Text(font)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                        }
                        .background(Color.black.opacity(0.9))
                    }
                }
                .frame(width: 200)
                .background(Color.black.opacity(0.9))
                .cornerRadius(10)
                .shadow(radius: 5)
                .offset(y: -5) // Overlay the dropdown over the picker
            }
        }
        .padding()
    }
}


#Preview {
    FontPicker()
}
