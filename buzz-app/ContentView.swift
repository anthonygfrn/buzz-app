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
    @State private var imageUrls: [String] = []  // Menyimpan URL gambar yang diekstraksi
    @State private var images: [NSImage] = []    // Menyimpan gambar yang sudah diunduh
    
    var body: some View {
        VStack {
            ScrollView {
                HStack(alignment: .top) {
                    // Bagi teks menjadi dua bagian untuk dua kolom
                    let (leftColumn, rightColumn) = splitTextIntoTwoColumns(text: extractedText)
                    
                    // Kolom pertama
                    VStack(alignment: .leading) {
                        ForEach(leftColumn, id: \.self) { line in
                            Text(line)
                                .foregroundColor(randomColor())
                                .padding(2)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Kolom kedua
                    VStack(alignment: .leading) {
                        ForEach(rightColumn, id: \.self) { line in
                            Text(line)
                                .foregroundColor(randomColor())
                                .padding(2)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
            
            Button(action: {
                // Pastikan kamu memiliki file PDF dalam bundle atau direktori tertentu
                if let pdfURL = Bundle.main.url(forResource: "dummy2", withExtension: "pdf") {
                    if let text = convertPDFToPlainText(from: pdfURL) {
                        extractedText = text
                        uploadPDF(pdfURL: pdfURL)  // Panggil fungsi uploadPDF
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
            
            // Tampilkan gambar yang diunduh
            if !images.isEmpty {
                Text("Gambar yang diekstraksi:")
                    .font(.headline)
                    .padding()
                
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(images, id: \.self) { image in
                            Image(nsImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .padding()
                        }
                    }
                }
            }
        }
    }
    
    // Fungsi untuk membagi teks menjadi dua kolom
    func splitTextIntoTwoColumns(text: String) -> ([String], [String]) {
        let lines = text.components(separatedBy: "\n")
        let half = lines.count / 2
        
        let leftColumn = Array(lines[0..<half])
        let rightColumn = Array(lines[half..<lines.count])
        
        return (leftColumn, rightColumn)
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
        
        return fullText
    }
    
    // Fungsi untuk mengunggah PDF ke API
    func uploadPDF(pdfURL: URL) {
        let url = URL(string: "http://127.0.0.1:5000/upload")! // Ganti dengan URL server Anda
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        let fileName = pdfURL.lastPathComponent
        let mimeType = "application/pdf"
        let fileData = try? Data(contentsOf: pdfURL)
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData!)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Error uploading file: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            if let responseObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let imageUrls = responseObject["images"] as? [String] {
                DispatchQueue.main.async {
                    self.imageUrls = imageUrls // Update state dengan URL gambar yang diekstraksi
                    self.downloadImages()      // Panggil fungsi untuk mengunduh gambar
                }
            } else {
                print("Failed to parse response")
            }
        }
        task.resume()
    }
    
    // Fungsi untuk mengunduh gambar dari URL
    func downloadImages() {
        images.removeAll() // Kosongkan array gambar sebelum menambahkan gambar baru
        
        for urlString in imageUrls {
            if let url = URL(string: urlString) {
                URLSession.shared.dataTask(with: url) { data, response, error in
                    guard let data = data, error == nil, let image = NSImage(data: data) else {
                        print("Failed to download image from \(urlString)")
                        return
                    }
                    DispatchQueue.main.async {
                        self.images.append(image) // Tambahkan gambar ke array images
                    }
                }.resume()
            }
        }
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



