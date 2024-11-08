//
//  ToolbarButton.swift
//  buzz-app
//
//  Created by Anthony on 16/10/24.
//

import SwiftUI

struct ToolbarButton: View {
    let iconName: String?
    let customImage: Image?
    let overlayOpacity: Double
    let action: () -> Void
    let isSelected: Bool // New property to determine if the button is selected

    @State private var isHovered: Bool = false

    var body: some View {
        Button(action: action) {
            if let iconName = iconName {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
                    .foregroundColor(Color("Default"))
                    .padding(14)
                    .background(isSelected ? Color.blue : (isHovered ? Color("Hover") : Color.clear))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("OutlinePrimary"), lineWidth: 1.5)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isHovered && !isSelected ? Color("OutlinePrimary").opacity(overlayOpacity) : Color.clear)
                            )
                    )
                    .cornerRadius(12)
                    .frame(width: 64, height: 64)
            } else if let customImage = customImage {
                customImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 48, height: 48)
                    .padding(4)
                    .background(isSelected ? Color.blue : (isHovered ? Color("Hover") : Color.clear))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("OutlinePrimary"), lineWidth: 1.5)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isHovered && !isSelected ? Color("OutlinePrimary").opacity(overlayOpacity) : Color.clear)
                            )
                    )
                    .cornerRadius(12)
                    .frame(width: 64, height: 64)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
