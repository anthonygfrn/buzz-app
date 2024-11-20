//
//  Icons.swift
//  buzz-app
//
//  Created by Anthony on 20/11/24.
//

import SwiftUI

struct Icons: View {
    let iconName: String?
    let customImage: Image?
    
    var body: some View {
        if let iconName = iconName{
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 28, height: 28)
                .foregroundColor(Color("Default"))
                .padding(14)
                .background(Color("Secondary"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("LightOutlinePrimary"), lineWidth: 2)
                )
                .cornerRadius(12)
                .frame(width: 64, height: 64)
        } else if let customImage = customImage {
            customImage
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .padding(4)
                .background(Color("Secondary"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("LightOutlinePrimary"), lineWidth: 2)
                )
                .cornerRadius(12)
                .frame(width: 64, height: 64)
        }
    }
}
