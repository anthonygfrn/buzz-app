//
//  ContentView.swift
//  Dump-Macro
//
//  Created by Rangga Yudhistira Brata on 14/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedPDF: URL? = nil
    @State private var images: [NSImage] = []  // Untuk menampung gambar yang diterima dari server
    
    var body: some View {
        VStack {
            Button("Pilih PDF") {
                selectPDF()
            }
            .padding()
            
            if !images.isEmpty {
                ScrollView {
                    ForEach(images, id: \.self) { image in
                        Image(nsImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .padding()
                    }
                }
            }
        }
    }
    
    // Fungsi untuk memilih PDF menggunakan NSOpenPanel
    func selectPDF() {
        let openPanel = NSOpenPanel()  // NSOpenPanel untuk memilih file di macOS
        openPanel.allowedFileTypes = ["pdf"]
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        
        openPanel.begin { response in
            if response == .OK, let url = openPanel.url {
                self.selectedPDF = url
                uploadPDFToAPI(pdfURL: url)
            }
        }
    }
    
    // Fungsi untuk mengunggah PDF ke API dan menerima gambar dalam bentuk base64
    func uploadPDFToAPI(pdfURL: URL) {
        let url = URL(string: "https://rggayb-polaread.hf.space/upload")! // Ganti dengan URL server API
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Buat boundary untuk multipart/form-data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        
        // Tambahkan PDF ke body request
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(pdfURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: application/pdf\r\n\r\n".data(using: .utf8)!)
        data.append(try! Data(contentsOf: pdfURL))
        data.append("\r\n".data(using: .utf8)!)
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        let task = URLSession.shared.uploadTask(with: request, from: data) { responseData, response, error in
            if let error = error {
                print("Gagal mengunggah PDF: \(error)")
                return
            }
            
            if let responseData = responseData {
                do {
                    // Decode respons JSON
                    if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                       let imageArray = json["images"] as? [[String: Any]] {
                        
                        var extractedImages: [NSImage] = []
                        
                        for imageInfo in imageArray {
                            if let base64String = imageInfo["image_data"] as? String,
                               let imageData = Data(base64Encoded: base64String),
                               let image = NSImage(data: imageData) {
                                extractedImages.append(image)
                            }
                        }
                        
                        DispatchQueue.main.async {
                            self.images = extractedImages  // Menampilkan gambar-gambar di antarmuka
                        }
                    }
                } catch {
                    print("Gagal decode JSON: \(error)")
                }
            }
        }
        
        task.resume()
    }
}

#Preview {
    ContentView()
}
