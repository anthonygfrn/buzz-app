
import Foundation
import SwiftUI

struct SideToolbarView: View {
    @EnvironmentObject var pdfViewModel: PDFViewModel
    @EnvironmentObject var toolbarViewModel: ToolBarViewModel
    @State private var selectedFont = "Calibri"
    @State private var selectedParagraphSpacing = "Standard"

    private let fonts = ["Calibri", "Arial", "Times New Roman"]
    private let spacingOptions = ["Standard", "Large", "1.5", "2.0"]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Typeface Section
            VStack(alignment: .leading, spacing: 8) {
                Text("Typeface")
                    .foregroundColor(.gray)
                    .font(.footnote)

                HStack {
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
                }
                .padding(.leading, 8)

                HStack {
                    Picker("", selection: $pdfViewModel.selectedFontSize) {
                        Button(action: {}) {
                            Image("fontsize1")
                                .resizable()
                                .frame(width: 7, height: 13)
                        }
                        .tag(FontSizePicker.normal)
                        Button(action: {}) {
                            Image("fontsize2")
                                .resizable()
                                .frame(width: 9, height: 13)
                        }
                        .tag(FontSizePicker.large)
                        Button(action: {}) {
                            Image("fontsize3")
                                .resizable()
                                .frame(width: 11, height: 16)
                        }
                        .tag(FontSizePicker.extraLarge)
                    }

                    .pickerStyle(.segmented)
                    .tint(Color("PrimaryColor"))

                    VStack {
                        HStack {
                            Text("B")
                        }
                        .frame(width: 34, height: 24, alignment: .center)
                        .fontWeight(.bold)
                        .background(Color.white.opacity(0))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.black.opacity(0.1), lineWidth: 2)
                        )
                        .cornerRadius(6)
                        .shadow(color: pdfViewModel.selectedFontWeight == .bold ? Color.black.opacity(0.4) : Color.clear,
                                radius: 4, x: 2, y: 2) // Outer shadow diterapkan saat bold
                    }
                    .background(pdfViewModel.selectedFontWeight == .bold ? Color("ButtonBgSelected") : Color("ButtonBg"))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .onTapGesture {
                        if pdfViewModel.selectedFontWeight == .regular {
                            pdfViewModel.selectedFontWeight = .bold
                        } else {
                            pdfViewModel.selectedFontWeight = .regular
                        }
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
                    Button(action: {}) {
                        Image("lineSpacing-1")
                    }
                    .tag(LineSpacing.standard)
                    Button(action: {}) {
                        Image("lineSpacing-2")
                    }
                    .tag(LineSpacing.large)
                    Button(action: {}) {
                        Image("lineSpacing-3")
                    }
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
                    Button("abc", action: {})
                        .tag(LetterSpacing.standard)
                    Button("a b c", action: {})
                        .tag(LetterSpacing.large)
                    Button("a  b  c", action: {})
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
                HStack {
                    Menu {
                        ForEach(ParagraphSpacing.allCases, id: \.self) { option in
                            Button(option.rawValue, action: { pdfViewModel.selectedParagraphSpacing = option })
                        }

                    } label: {
                        HStack {
                            Text(pdfViewModel.selectedParagraphSpacing.rawValue)
                            Spacer()
                            Image(systemName: "chevron.up.chevron.down")
                        }
                        .padding()
                        .background(Color.white)
                    }
                }
                .padding(.leading, 8)
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
                        Image("Punctuation")
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
        .onChange(of: pdfViewModel.selectedFontWeight) {
            newValue in
            pdfViewModel.setSelectedFontWeight(to: newValue)
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

        .onChange(of: pdfViewModel.segmentColoringMode) {
            newValue in
            pdfViewModel.setSegmentedControlValue(to: newValue)
        }
        .onChange(of: pdfViewModel.coloringStyle) {
            newValue in
            pdfViewModel.setColoringStyle(to: newValue)
        }

        .padding()
    }
}
