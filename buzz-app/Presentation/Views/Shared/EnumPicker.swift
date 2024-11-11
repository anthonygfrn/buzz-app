import SwiftUI

struct EnumPicker<T: RawRepresentable & Hashable>: View where T.RawValue == String {
    let idPicker: Int
    @Binding var selectedItem: T
    @EnvironmentObject var toolbarViewModel: ToolBarViewModel
    @State private var isMenuVisible: Bool = false
    @State private var isHovered: Bool = false // Track hover state for outer rectangle
    @State private var hoveredItem: T? = nil // Track hovered item for hover effect
    let items: [T]
    let imageName: String?
    let assetImageName: String?

    var body: some View {
        ZStack {
            if isMenuVisible {
                Color.clear
                    .onTapGesture {
                        isMenuVisible = false
                        toolbarViewModel.resetActivePicker()
                    }
                    .frame(width: .infinity, height: .infinity)
                    .ignoresSafeArea()
            }

            VStack {
                if !isMenuVisible {
                    HStack {
                        HStack {
                            if let assetImageName = assetImageName {
                                Image(assetImageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24)
                                    .padding(.trailing, 5)
                                    .foregroundStyle(Color("Default"))
                            } else if let imageName = imageName {
                                Image(systemName: imageName)
                                    .font(.system(size: 24))
                                    .padding(.trailing, 5)
                            }

                            Text(selectedItem.rawValue == "OpenDyslexic" ? "Open Dyslexic" : selectedItem.rawValue)
                                .font(.system(size: 16))

                            Spacer()

                            Button(action: {
                                toolbarViewModel.setActivePicker(idPicker)
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
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("OutlinePrimary"), lineWidth: 1)
                        )
                    }
                    .frame(width: 264)
                    .background(RoundedRectangle(cornerRadius: 12)
                        .fill(isHovered ? Color("Hover") : Color.clear)) // Hover effect background
                    .onHover { hovering in
                        isHovered = hovering
                    }
                }

                if isMenuVisible {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(items, id: \.self) { item in
                            Button(action: {
                                selectedItem = item
                                isMenuVisible = false
                                toolbarViewModel.resetActivePicker()
                            }) {
                                Text(item.rawValue)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 10)
                                    .background(hoveredItem == item ? Color("Hover") : Color.clear)
                                    .cornerRadius(5)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .onHover { hovering in
                                hoveredItem = hovering ? item : nil
                            }
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
        .onChange(of: toolbarViewModel.activePicker) { newValue in
            isMenuVisible = (newValue == idPicker)
        }
        .simultaneousGesture(
            TapGesture()
                .onEnded {
                    if toolbarViewModel.activePicker != idPicker {
                        isMenuVisible = false
                    }
                }
        )
        .padding()
        .background(Color.clear)
    }
}
