//
//  ExtractPDFTextUseCase.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 17/10/24.
//

import Foundation

struct ExtractPDFTextUseCase {
    private let repository: PDFRepositoryProtocol

    init(repository: PDFRepositoryProtocol) {
        self.repository = repository
    }

    func execute(url: URL) -> PDFDocumentEntity? {
        return repository.extractText(from: url)
    }
}
