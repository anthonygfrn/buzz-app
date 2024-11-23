//
//  PDFUploadService.swift
//  buzz-app
//
//  Created by Rangga Yudhistira Brata on 06/11/24.
//

import AppKit
import Foundation

struct Figure: Identifiable {
    let id = UUID()
    let title: String
    let position: Int
    let imageData: Data
}

class PDFUploadService {
    func uploadPDFToAPI(pdfURL: URL, completion: @escaping (Result<(String, [Figure]), Error>) -> Void) {
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
        
        let task = URLSession.shared.uploadTask(with: request, from: data) { responseData, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let responseData = responseData {
                do {
                    // Decode respons JSON
                    if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                       let fullText = json["full_text"] as? String,
                       let figuresData = json["figures"] as? [[String: Any]]
                    {
                        var figures: [Figure] = []
                        
                        for figureInfo in figuresData {
                            if let title = figureInfo["title"] as? String,
                               let position = figureInfo["position"] as? Int,
                               let imageDataString = figureInfo["image_data"] as? String,
                               let imageData = Data(base64Encoded: imageDataString)
                            {
                                let figure = Figure(title: title, position: position, imageData: imageData)
                                figures.append(figure)
                            }
                        }
                        
                        completion(.success((fullText, figures)))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    func uploadPDFToAPIArray(pdfURL: URL, completion: @escaping (Result<([String], [Figure]), Error>) -> Void) {
        let url = URL(string: "https://rggayb-polaread.hf.space/upload-array")! // Sesuaikan dengan URL server API
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
        
        let task = URLSession.shared.uploadTask(with: request, from: data) { responseData, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let responseData = responseData {
                do {
                    // Decode respons JSON
                    if let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any],
                       let fullText = json["full_text"] as? [String],
                       let figuresData = json["figures"] as? [[String: Any]]
                    {
                        var figures: [Figure] = []
                        
                        for figureInfo in figuresData {
                            if let title = figureInfo["title"] as? String,
                               let position = figureInfo["position"] as? Int,
                               let imageDataString = figureInfo["image_data"] as? String,
                               let imageData = Data(base64Encoded: imageDataString)
                            {
                                let figure = Figure(title: title, position: position, imageData: imageData)
                                figures.append(figure)
                            }
                        }
                        
                        completion(.success((fullText, figures)))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
