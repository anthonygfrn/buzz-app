import SwiftUI

struct EnumPicker<T: RawRepresentable & Hashable>: View where T.RawValue == String {
    @Binding var selectedItem: T
    @State private var isMenuVisible: Bool = false
    let items: [T]
    let imageName: String? // Optional String for SF Symbol
    let assetImageName: String? // New property for asset images

    var body: some View {
        ZStack {
            // Background overlay to detect taps outside the Picker menu
            if isMenuVisible {
                Color.clear // Invisible background to capture taps
                    .onTapGesture {
                        isMenuVisible = false // Close the menu
                    }
                    .ignoresSafeArea() // Capture taps across the entire screen
            }

            VStack {
                if !isMenuVisible {
                    // Picker container with custom image and selected item name
                    HStack {
                        HStack {
                            // Use the provided image name for the picker
                            if let assetImageName = assetImageName {
                                Image(assetImageName) // Use asset image if available
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .padding(.trailing, 5)
                            } else if let imageName = imageName {
                                Image(systemName: imageName) // Fallback to SF Symbol
                                    .font(.system(size: 24))
                                    .padding(.trailing, 5)
                            }

                            // Show the rawValue (String) of the selected enum
                            Text(selectedItem.rawValue)
                                .font(.system(size: 16))

                            Spacer()

                            // Dropdown button, toggles menu visibility
                            Button(action: {
                                withAnimation {
                                    isMenuVisible.toggle()
                                }
                            }) {
                                Image(systemName: "chevron.up.chevron.down")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .padding(8)
                                    .background(Color.blue)
                                    .cornerRadius(5)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color("OutlinePrimary"), lineWidth: 1)
                        )
                    }
                    .frame(width: 264)
                }

                // Dropdown menu that overlays and covers the picker
                if isMenuVisible {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(items, id: \.self) { item in
                            Button(action: {
                                selectedItem = item
                                isMenuVisible = false
                            }) {
                                Text(item.rawValue)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 10)
                            }
                            .background(Color.white)
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(width: 264)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .offset(y: -24)
                }
            }
        }
        .padding()
        .background(Color.clear) // Transparent background to capture outside taps
    }
}
