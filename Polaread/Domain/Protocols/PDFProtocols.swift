//
//  Protocolll.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 17/10/24.
//

import Foundation

protocol PDFRepositoryProtocol {
    func extractText(from url: URL) -> PDFDocumentEntity?
}
