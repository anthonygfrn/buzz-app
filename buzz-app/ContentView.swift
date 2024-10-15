//
//  ContentView.swift
//  Dump-Macro
//
//  Created by Rangga Yudhistira Brata on 14/10/24.
//

import SwiftUI
import PDFKit

struct ContentView: View {
    var body: some View {
        if let url = Bundle.main.url(forResource: "dummy2", withExtension: "pdf"),
           let extractedText = extractTextFromPDF(url: url) {
            PDFTextView(extractedText: extractedText)
        } else {
            Text("PDF not found or failed to extract text")
        }
    }
}

// Fungsi untuk mengekstrak teks dari PDF
func extractTextFromPDF(url: URL) -> String? {
    guard let document = PDFDocument(url: url) else { return nil }
    var fullText = ""
    
    for pageIndex in 0..<document.pageCount {
        if let page = document.page(at: pageIndex), let pageText = page.string {
            fullText += pageText
        }
    }
    return fullText
}

// Fungsi untuk mengganti spasi antar kata sesuai dengan pengaturan word spacing
func applyWordSpacing(to text: String, wordSpacing: CGFloat) -> String {
    let additionalSpacing = String(repeating: " ", count: Int(wordSpacing)) // Menambahkan jumlah spasi sesuai word spacing
    let spacedText = text.replacingOccurrences(of: " ", with: " " + additionalSpacing) // Menambahkan spasi di antara kata-kata
    return spacedText
}

// Fungsi untuk membuat NSAttributedString dengan jarak antar huruf, antar kata, antar baris, dan antar paragraf
func attributedStringWithSpacing(_ text: String, letterSpacing: CGFloat, wordSpacing: CGFloat, lineSpacing: CGFloat, paragraphSpacing: CGFloat) -> NSAttributedString {
    // Terapkan word spacing
    let spacedText = applyWordSpacing(to: text, wordSpacing: wordSpacing)
    
    let attributedString = NSMutableAttributedString(string: spacedText)
    
    // Pengaturan letter spacing (jarak antar huruf)
    attributedString.addAttribute(.kern, value: letterSpacing, range: NSRange(location: 0, length: spacedText.count))
    
    // Pengaturan line spacing (jarak antar baris) dan paragraph spacing (jarak antar paragraf). Belom jalan.
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = lineSpacing // Jarak antar baris
    paragraphStyle.paragraphSpacing = paragraphSpacing // Jarak antar paragraf
    paragraphStyle.alignment = .left
    
    attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: spacedText.count))
    
    return attributedString
}

// UIViewRepresentable untuk menampilkan NSAttributedString dalam SwiftUI
struct AttributedTextView: NSViewRepresentable {
    var attributedString: NSAttributedString
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        let textView = NSTextView()
        
        textView.isEditable = false
        textView.textStorage?.setAttributedString(attributedString)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = true
        textView.autoresizingMask = [.width]
        
        // Mengatur kontainer teks agar cocok dengan konten
        let contentSize = scrollView.contentSize
        textView.minSize = NSSize(width: 0.0, height: contentSize.height)
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = true
        textView.textContainer?.containerSize = NSSize(width: contentSize.width, height: CGFloat.greatestFiniteMagnitude)
        textView.textContainer?.widthTracksTextView = true
        
        scrollView.documentView = textView
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers = true
        
        return scrollView
    }
    
    func updateNSView(_ nsView: NSScrollView, context: Context) {
        if let textView = nsView.documentView as? NSTextView {
            textView.textStorage?.setAttributedString(attributedString)
        }
    }
}

// Tampilan SwiftUI untuk menampilkan teks yang diekstrak dari PDF dan memungkinkan perubahan letter spacing, word spacing, line spacing, dan paragraph spacing
struct PDFTextView: View {
    @State private var letterSpacing: CGFloat = 0.0
    @State private var wordSpacing: CGFloat = 0.0
    @State private var lineSpacing: CGFloat = 0.0
    @State private var paragraphSpacing: CGFloat = 0.0
    let extractedText: String
    
    var body: some View {
        VStack {
            Slider(value: $letterSpacing, in: 0...10, step: 0.1) {
                Text("Letter Spacing: \(letterSpacing, specifier: "%.1f")")
            }
            .padding()
            
            Slider(value: $wordSpacing, in: 0...10, step: 1.0) {
                Text("Word Spacing: \(wordSpacing, specifier: "%.0f")")
            }
            .padding()
            
            Slider(value: $lineSpacing, in: 0...20, step: 0.5) {
                Text("Line Spacing: \(lineSpacing, specifier: "%.1f")")
            }
            .padding()
            
            Slider(value: $paragraphSpacing, in: 0...30, step: 0.5) {
                Text("Paragraph Spacing: \(paragraphSpacing, specifier: "%.1f")")
            }
            .padding()
            
            AttributedTextView(attributedString: attributedStringWithSpacing(extractedText, letterSpacing: letterSpacing, wordSpacing: wordSpacing, lineSpacing: lineSpacing, paragraphSpacing: paragraphSpacing))
                .frame(minHeight: 400) // Menyediakan frame untuk membuat tampilan teks lebih fleksibel
                .padding()
        }
        .padding()
    }
}

// Tampilan untuk menampilkan PDF yang telah dimodifikasi
struct PDFViewUI: View {
    let pdfDocument: PDFDocument
    
    var body: some View {
        PDFKitRepresentedView(pdfDocument: pdfDocument)
            .edgesIgnoringSafeArea(.all)
    }
}

struct PDFKitRepresentedView: NSViewRepresentable {
    var pdfDocument: PDFDocument
    
    func makeNSView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        return pdfView
    }
    
    func updateNSView(_ nsView: PDFView, context: Context) {
        nsView.document = pdfDocument
    }
}

#Preview {
    ContentView()
}

