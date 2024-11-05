//
//  buzz_appApp.swift
//  buzz-app
//
//  Created by Anthony on 07/10/24.
//

import SwiftUI

@main
struct buzz_appApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(minWidth: 800, minHeight: 600)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Menangkap event keyboard di level aplikasi
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { _ in
            // Mengabaikan semua input keyboard
            return nil
        }
        
        
    }
}
