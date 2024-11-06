//
//  Test.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 04/11/24.
//

import SwiftUI

struct Test: View {
    @State private var size: CGSize = .zero

    // Sample text that will be split into lines
    let text = """
    This is a beautiful paragraph of text that will demonstrate
    gradient colors across multiple lines. Each line will have
    its own gradient color scheme. As you resize the window,
    the text will reflow and the gradients will adjust accordingly.
    Feel free to make the window bigger or smaller to see the effect.
    """

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                Text(text)
                    .lineSpacing(5)
                    .fixedSize(horizontal: false, vertical: true)
                    .overlay(
                        LinearGradient(
                            colors: [
                                .blue,
                                .purple
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .mask(
                        Text(text)
                            .lineSpacing(5)
                            .fixedSize(horizontal: false, vertical: true)
                    )
                    .onChange(of: geometry.size) { newSize in
                        size = newSize
                        print("Window size changed to: \(newSize)")
                    }
            }
            .padding()
        }
        .frame(minWidth: 300, minHeight: 200)
    }
}

#Preview {
    Test()
}
