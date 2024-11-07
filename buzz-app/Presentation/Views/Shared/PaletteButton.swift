//
//  PaletteButton.swift
//  buzz-app
//
//  Created by Anthony on 07/11/24.
//

import SwiftUI

struct PaletteButton: View {
    let iconName: String?
    let assetImage: Image?
    let isSelected: Bool
    let action: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State private var isHovered: Bool = false

    var body: some View {
        Button(action: action) {
            if let assetImage = assetImage {
                assetImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(isSelected ? .white : .black)
                    .padding(8)
                    .background(isSelected ? Color.blue : (isHovered ? Color("Hover") : Color.clear))
                    .cornerRadius(10)
            } else if let iconName = iconName {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
                    .foregroundColor(isSelected ? .white : (colorScheme == .dark ? .white : .black))
                    .padding(8)
                    .background(isSelected ? Color.blue : (isHovered ? Color("Hover") : Color.clear))
                    .cornerRadius(10)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
