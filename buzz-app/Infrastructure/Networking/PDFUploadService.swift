//
//  PDFUploadService.swift
//  buzz-app
//
//  Created by Rangga Yudhistira Brata on 06/11/24.
//

import Foundation
import AppKit

class PDFUploadService {
    func uploadPDFToAPI(pdfURL: URL, completion: @escaping (Result<[NSImage], Error>) -> Void) {
        let url = URL(string: "https://rggayb-polaread.hf.space/upload")! // Sesuaikan dengan URL server API
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(pdfURL.lastPathComponent)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: application/pdf\r\n\r\n".data(using: .utf8)!)
        data.append(try! Data(contentsOf: pdfURL))
        data.append("\r\n".data(using: .utf8)!)
        data.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        let task = URLSession.shared.uploadTask(with: request, from: data) { responseData, response, error in
            if let error = error {
                completion(.failure(error))
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
                        completion(.success(extractedImages))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}

