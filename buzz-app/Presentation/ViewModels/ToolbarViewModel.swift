//
//  ToolbarViewModel.swift
//  buzz-app
//
//  Created by Kurnia Kharisma Agung Samiadjie on 18/10/24.
//

import Foundation

class ToolBarViewModel: ObservableObject {
    @Published var activeToolbar: ActiveToolbar = .main
    @Published var activePicker: Int = -1
    @Published var isOpen: Bool = true
    
    func toggleIsOpen() {
        self.isOpen.toggle()
    }
    
    func setActiveToolbar(_ toolbar: ActiveToolbar) {
        self.activeToolbar = toolbar
    }
    
    func setActivePicker(_ picker: Int) {
        self.activePicker = picker
    }
    
    func resetActivePicker() {
        self.activePicker = -1
    }
}
