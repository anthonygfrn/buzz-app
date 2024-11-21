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
        ZStack {
            Color.clear
                .edgesIgnoringSafeArea(.all)
                .onAppear {
                    if showPopup {
                        NSCursor.arrow.set()
                    }
                }
                .onHover { _ in
                    if showPopup {
                        NSCursor.arrow.set()
                    }
                }
            
            VStack(spacing: 32) {
                Text("Let's enhance our reading experience")
                    .font(.system(size: 42))
                    .fontWeight(.bold)
                
                HStack(spacing: 20) {
                    Icons(iconName: "textformat", customImage: nil)
                        .font(.system(size: 28, weight: .bold))
                    Icons(iconName: "arrow.up.and.down.text.horizontal", customImage: nil)
                        .font(.system(size: 28, weight: .bold))
                    Icons(iconName: "text.justify.left", customImage: nil)
                        .font(.system(size: 28, weight: .bold))
                    Icons(iconName: nil, customImage: Image("Color-Mode"))
                        .font(.system(size: 28, weight: .bold))
                }
                
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
                
                Text("If you have any preferences, feel free to customize everything using the\n toolbar at the bottom of your screen anytime!")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 18))
                    .padding()
                
                Button(action: { showPopup = false }) {
                    Text("Start reading")
                        .foregroundStyle(Color.white)
                        .font(.system(size: 18))
                }
                .frame(width: 155, height: 61, alignment: .center)
                .background(Color.blue)
                .cornerRadius(16)
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 128)
            .padding(.vertical, 64)
            .background(Color("Secondary"))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.25), radius: 32, x: 0, y: 20)
            .frame(maxWidth: 1051, maxHeight: 717)
            .onHover { _ in
                if showPopup {
                    NSCursor.arrow.set()
                }
            }
        }
    }
}
