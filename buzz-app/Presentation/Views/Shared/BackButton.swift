//
//  BackButton.swift
//  buzz-app
//
//  Created by Anthony on 07/11/24.
//

import SwiftUI

struct BackButton: View {
    let action: () -> Void
    @State private var isHovered: Bool = false

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 24))
                .foregroundColor(Color("Default"))
                .frame(width: 56, height: 56)
                .background(isHovered ? Color("Hover") : Color.clear)
                .cornerRadius(10)
                .padding()
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
