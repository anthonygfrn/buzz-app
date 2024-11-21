//
//  TopBar.swift
//  buzz-app
//
//  Created by Anthony on 20/11/24.
//

import SwiftUI

struct TopBar: View {
    var fileName: String // File name to display
    var questionMarkAction: () -> Void // Action for the question mark button

    var body: some View {
        HStack {
            // Close button (simulated as invisible spacer for alignment)
            Button(action: {}) {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12) // Match close button size
            }
            .hidden() // Invisible to keep alignment
            
            Spacer()

            // File name text centered
            Text(fileName.isEmpty ? "Untitled" : fileName)
                .font(.system(size: 12)) // Match font size for alignment
                .lineLimit(1)
                .multilineTextAlignment(.center)
                .alignmentGuide(.firstTextBaseline) { d in d[.firstTextBaseline] }
                .frame(maxWidth: .infinity, alignment: .center)

            Spacer()

            // Question mark button on the right
            Button(action: questionMarkAction) {
                Image(systemName: "questionmark.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 12, height: 12) // Same size as close button
            }
        }
        .frame(height: 18) // Match top bar height to the close button
        .background(Color.gray.opacity(0.15)) // Light gray background
        .padding(.horizontal, 8) // Add some padding for better visuals
    }
}
