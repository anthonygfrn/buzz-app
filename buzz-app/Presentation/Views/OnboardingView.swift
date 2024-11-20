//
//  OnboardingView.swift
//  buzz-app
//
//  Created by Anthony on 20/11/24.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var showPopup: Bool // Bind to the parent view's state

    var body: some View {
        VStack(spacing: 32) {
            // Header text
            Text("Let's enhance our reading experience")
                .font(.system(size: 42))
                .fontWeight(.bold)
                .onHover { _ in NSCursor.arrow.set() }

            // Icons row
            HStack(spacing: 20) {
                Icons(iconName: "textformat", customImage: nil)
                    .onHover { _ in NSCursor.arrow.set() }
                Icons(iconName: "arrow.up.and.down.text.horizontal", customImage: nil)
                    .onHover { _ in NSCursor.arrow.set() }
                Icons(iconName: "text.justify.left", customImage: nil)
                    .onHover { _ in NSCursor.arrow.set() }
                Icons(iconName: nil, customImage: Image("Color-Mode"))
                    .onHover { _ in NSCursor.arrow.set() }
            }

            // Instructional text
            Group {
                Text("We’ve adjusted the ") +
                Text("text style, spacing, ").bold() +
                Text("and ") +
                Text("paragraph alignment ").bold() +
                Text("to\n make reading easier. Plus, we’ve added a ") +
                Text("touch of color ").bold() +
                Text("to help you keep\n track of where you are.")
            }
            .multilineTextAlignment(.center)
            .font(.system(size: 18))
            .padding()
            .onHover { _ in NSCursor.arrow.set() }

            // Customization suggestion
            Text("If you have any preferences, feel free to customize everything using the\n toolbar at the bottom of your screen anytime!")
                .multilineTextAlignment(.center)
                .font(.system(size: 18))
                .padding()
                .onHover { _ in NSCursor.arrow.set() }

            // "Start Reading" button
            Button(action: { showPopup = false }) {
                Text("Start reading")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
            }
            .frame(width: 155, height: 61, alignment: .center)
            .background(Color.blue)
            .cornerRadius(16)
            .buttonStyle(PlainButtonStyle())
            .onHover { _ in NSCursor.arrow.set() }
        }
        .padding(.horizontal, 128)
        .padding(.vertical, 64)
        .background(Color("Secondary"))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.25), radius: 32, x: 0, y: 20)
        .frame(maxWidth: 1051, maxHeight: 717)
        .onHover { _ in NSCursor.arrow.set() } // Enforce arrow cursor for the entire frame
        .transition(.scale) // Optional: Add scaling effect
    }
}
