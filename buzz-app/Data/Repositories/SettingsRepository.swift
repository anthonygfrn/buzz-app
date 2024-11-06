//
//  SettingsRepository.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 22/10/24.
//

import Foundation

protocol SettingsRepositoryProtocol {
    func isDarkModeEnabled() -> Bool
}

class SettingsRepository {
    private let darkModeKey = "dark_mode_preference"

    func isDarkModeEnabled() -> Bool {
        UserDefaults.standard.bool(forKey: darkModeKey)
    }
}
