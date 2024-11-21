//
//  SegmentedPicker.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 14/11/24.
//
import SwiftUI

struct SegmentedPicker<T: Hashable>: View {
    let options: [T]
    @Binding var selectedOption: T
    let label: String
    let icon: String?
    let onSelectionChange: ((T) -> Void)?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .foregroundColor(.gray)
                .font(.footnote)
            
            Picker("", selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    HStack {
                        if let icon = icon {
                            Image(systemName: icon)
                        }
                        Text("\(option)")
                    }
                    .tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: selectedOption, perform: { newValue in
                onSelectionChange?(newValue)
            })
            .tint(Color("PrimaryColor"))
        }
    }
}
