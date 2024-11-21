//
//  DarkModeViewModel.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 22/10/24.
//

import Foundation

class DarkModeViewModel: ObservableObject {
    @Published var isDarkMode: Bool = false

    private let darkModeUseCase: DarkModeUseCase

    init(isDarkMode: Bool = false, darkModeUseCase: DarkModeUseCase = DarkModeUseCase(settingsRepository: SettingsRepository())) {
        self.isDarkMode = darkModeUseCase.getCurrentAppearance()
        self.darkModeUseCase = darkModeUseCase
    }
}
    
