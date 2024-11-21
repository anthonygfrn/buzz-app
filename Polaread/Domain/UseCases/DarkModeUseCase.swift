//
//  DarkModeUseCase.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 22/10/24.
//

import Foundation

class DarkModeUseCase: DarkModeUseCaseProtocol {
    private let settingsRepository: SettingsRepository

    init(settingsRepository: SettingsRepository) {
        self.settingsRepository = settingsRepository
    }

    func getCurrentAppearance() -> Bool {
        return settingsRepository.isDarkModeEnabled()
    }
}
