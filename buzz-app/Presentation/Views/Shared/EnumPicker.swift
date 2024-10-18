import SwiftUI

struct EnumPicker<T: RawRepresentable & Hashable>: View where T.RawValue == String {
    @Binding var selectedItem: T
    @State private var isMenuVisible: Bool = false
    let items: [T]

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
                    // Picker container with SF Symbol "textformat" and item name
                    HStack {
                        HStack {
                            Image(systemName: "textformat")
                                .font(.system(size: 24))
                                .padding(.trailing, 5)

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
                        .background(Color.white)
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.black, lineWidth: 1)
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
                                Text(item.rawValue) // Display the enum rawValue (String)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 10)
                            }
                            .background(Color.black.opacity(0.9))
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .frame(width: 264)
                    .background(Color.black.opacity(0.9))
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
