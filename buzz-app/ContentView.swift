//
//  ContentView.swift
//  buzz-app
//
//  Created by Anthony on 07/10/24.
//

import PDFKit
import SwiftUI

struct ContentView: View {
    @State private var extractedText: String = "Teks dari PDF akan muncul di sini."
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    let lines = extractedText.components(separatedBy: "\n")
                    ForEach(lines, id: \.self) { line in
                        Text(line)
                            .foregroundColor(randomColor()) // Warna acak untuk setiap baris
                            .padding(2)
                    }
                }
            }
            .padding()
            
            
            Button(action: {
                // Pastikan kamu memiliki file PDF dalam bundle atau direktori tertentu
                if let pdfURL = Bundle.main.url(forResource: "dummy", withExtension: "pdf") {
                    if let text = convertPDFToPlainText(from: pdfURL) {
                        extractedText = text
                    } else {
                        extractedText = "Gagal mengekstrak teks dari PDF."
                    }
                } else {
                    extractedText = "File PDF tidak ditemukan."
                }
            }) {
                Text("Convert PDF to Plain Text")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
    
    // Fungsi untuk mengubah PDF menjadi plain text
    func convertPDFToPlainText(from url: URL) -> String? {
        // Memuat dokumen PDF
        guard let pdfDocument = PDFDocument(url: url) else {
            print("Tidak dapat memuat file PDF.")
            return nil
        }
        
        // String untuk menyimpan semua teks yang diekstrak
        var fullText = ""
        
        // Loop melalui setiap halaman dan ekstrak teks
        for pageIndex in 0..<pdfDocument.pageCount {
            if let page = pdfDocument.page(at: pageIndex),
               let pageText = page.string {
                fullText += pageText + "\n"
            }
        }
        
        print (fullText)
        return fullText
    }
    
    // Fungsi untuk menghasilkan warna acak
    func randomColor() -> Color {
        let red = Double.random(in: 0...1)
        let green = Double.random(in: 0...1)
        let blue = Double.random(in: 0...1)
        return Color(red: red, green: green, blue: blue)
    }
}


#Preview {
    ContentView()
}
