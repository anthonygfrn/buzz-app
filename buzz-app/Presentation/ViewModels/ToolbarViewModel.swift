//
//  ToolbarViewModel.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 18/10/24.
//

import Foundation

class ToolBarViewModel: ObservableObject {
    @Published var activeToolbar: ActiveToolbar = .main
    
    func setActiveToolbar(_ toolbar: ActiveToolbar) {
        self.activeToolbar = toolbar
    }
}
