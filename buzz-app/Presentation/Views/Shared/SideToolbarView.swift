
import Foundation
import SwiftUI

struct SideToolbarView: View {
    @EnvironmentObject var pdfViewModel: PDFViewModel
    @EnvironmentObject var toolbarViewModel: ToolBarViewModel
    @State private var selectedFont = "Calibri"
    @State private var selectedParagraphSpacing = "Standard"

    private let fonts = ["Calibri", "Arial", "Times New Roman"]
    private let spacingOptions = ["Standard", "1.15", "1.5", "2.0"]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Typeface Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Typeface")
                    .foregroundColor(.gray)
                    .font(.footnote)

                Menu {
                    ForEach(FontFamily.allCases) { option in
                        Button(option.rawValue, action: { pdfViewModel.selectedFontFamily = option })
                    }

                } label: {
                    HStack {
                        Text(pdfViewModel.selectedFontFamily.rawValue)
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                    }
                    .padding()
                    .background(Color.white)
                }

                HStack {
                    Picker("", selection: $pdfViewModel.selectedFontSize) {
                        Button("A", action: {})
                            .tag(FontSizePicker.normal)
                        Button("A", action: {})
                            .tag(FontSizePicker.large)
                        Button("A", action: {})
                            .tag(FontSizePicker.extraLarge)
                    }

                    .pickerStyle(.segmented)
                    .tint(Color("PrimaryColor"))

                    VStack {
                        Button(action: {}) {
                            Text("B")
                                .fontWeight(.bold)
                        }
                        .background(Color("PrimaryColor"))
                        .cornerRadius(4)
                    }
                    .padding(.vertical, 8)
                }

                Picker("", selection: $pdfViewModel.selectedTextAlignment) {
                    Button(action: {}) {
                        Image(systemName: "text.alignleft")
                    }
                    .tag(AlignmentText.left)

                    Button(action: {}) {
                        Image(systemName: "text.aligncenter")
                    }
                    .tag(AlignmentText.center)
                    Button(action: {}) {
                        Image(systemName: "text.alignright")
                    }
                    .tag(AlignmentText.right)
                    Button(action: {}) {
                        Image(systemName: "text.justify.leading")
                    }
                    .tag(AlignmentText.justified)
                }

                .pickerStyle(.segmented)
                .tint(Color("PrimaryColor"))
            }

            // Line Spacing Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Line spacing")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Picker("", selection: $pdfViewModel.selectedLineSpacing) {
                    Button("A", action: {})
                        .tag(LineSpacing.standard)
                    Button("A", action: {})
                        .tag(LineSpacing.large)
                    Button("A", action: {})
                        .tag(LineSpacing.extraLarge)
                }

                .pickerStyle(.segmented)
                .tint(Color("PrimaryColor"))
            }

            // Letter Spacing Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Character spacing")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Picker("", selection: $pdfViewModel.selectedLetterSpacing) {
                    Button("abc", action:{})
                        .tag(LetterSpacing.standard)
                    Button("a b c", action:{})
                        .tag(LetterSpacing.large)
                    Button("a  b  c", action:{})
                        .tag(LetterSpacing.extraLarge)
                }
                .pickerStyle(.segmented)
                .tint(Color("PrimaryColor"))
            }

            // Paragraph Spacing Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Paragraph spacing")
                    .foregroundColor(.gray)
                    .font(.footnote)
                Menu {
                    ForEach(spacingOptions, id: \.self) { option in
                        Button(option) {
                            selectedParagraphSpacing = option
                        }
                    }
                } label: {
                    HStack {
                        Text(selectedParagraphSpacing)
                            .foregroundColor(.primary)
                        Spacer()
                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundColor(.primary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                }
            }

            // Coloring Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Coloring")
                    .font(.footnote)
                    .foregroundColor(.gray)
                Picker("", selection: $pdfViewModel.coloringStyle) {
                    Button("A", action: {})
                        .tag(ColoringStyle.text)
                    Button(action: {}) {
                        Image(systemName: "highlighter")
                    }
                    .tag(ColoringStyle.highlight)
                }
                .pickerStyle(.segmented)
                .tint(Color("PrimaryColor"))

                // Additional Controls
                Picker("", selection: $pdfViewModel.segmentColoringMode) {
                    Button(action: {}) {
                        Image(systemName: "text.justify")
                    }
                    .tag(SegmentColoringMode.line)

                    Button(action: {}) {
                        Image(systemName: "text.word.spacing")
                    }
                    .tag(SegmentColoringMode.sentence)

                    Button(action: {}) {
                        Image(systemName: "text.justify.left")
                    }
                    .tag(SegmentColoringMode.paragraph)

                    Button(action: {}) {
                        Image("Punctuation-2")
                    }
                    .tag(SegmentColoringMode.punctuation)
                }
                .pickerStyle(.segmented)
                .tint(Color("PrimaryColor"))
            }
            Spacer()
        }
        .onChange(of: pdfViewModel.selectedFontFamily) {
            newValue in
            pdfViewModel.setSelectedFontFamily(to: newValue)
        }
        .onChange(of: pdfViewModel.selectedFontSize) {
            newValue in
            pdfViewModel.setSelectedFontSize(to: newValue)
        }
        .onChange(of: pdfViewModel.selectedTextAlignment) {
            newValue in
            pdfViewModel.setSelectedTextAlignment(to: newValue)
        }
        .onChange(of: pdfViewModel.selectedLineSpacing) {
            newValue in
            pdfViewModel.setLineSpacing(to: newValue)
        }
        .onChange(of: pdfViewModel.selectedLetterSpacing) {
            newValue in
            pdfViewModel.setLetterSpacing(to: newValue)
        }
        .onChange(of: pdfViewModel.selectedParagraphSpacing) {
            newValue in
            pdfViewModel.setParagraphSpacing(to: newValue)
        }
        .onChange(of: pdfViewModel.coloringStyle) {
            newValue in
            pdfViewModel.setColoringStyle(to: newValue)
        }
        .onChange(of: pdfViewModel.segmentColoringMode) {
            newValue in
            pdfViewModel.setSegmentedControlValue(to: newValue)
        }

        .padding()
    }
}

//                Button(action: {
//                    toolbarViewModel.toggleIsOpen() // Toggle menu visibility
//                }) {
//                    // Customize button appearance
//                    HStack {
//                        Text(pdfViewModel.selectedFontFamily.rawValue)
//                            .font(.headline)
//                        Spacer()
//                        Image(systemName: "chevron.up.chevron.down")
//                    }
//                    .padding(10)
//                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.white))
//                }
//                .buttonStyle(PlainButtonStyle()) // Allows for custom styling without button effect
//                .menuStyle(BorderlessButtonMenuStyle()) // Borderless menu style for macOS
//
//                // Attach Menu as an overlay to show on button click
//                .overlay(
//                    Group {
//                        if toolbarViewModel.isOpen {
//                            VStack {
//                                ForEach(FontFamily.allCases) { option in
//                                    Button(action: {
//                                        pdfViewModel.selectedFontFamily = option
//                                        toolbarViewModel.isOpen = false // Dismiss menu on selection
//                                    }) {
//                                        Text(option.rawValue)
//                                    }
//                                }
//                            }.background(Color.white)
//                        }
//                    }
//                )
//                .padding()
