//
//  DeafCommunicateApp.swift
//  Deaf Communicate
//
//  Created by Alex Demerjian on 6/22/22.
//

import SwiftUI
import TipKit

@main
struct DeafCommunicateApp: App {
    var body: some Scene {
        WindowGroup{
            MainView()
        }
    }
    
    init() {
        do {
            // Configure and load all tips in the app.
            try Tips.configure()
        }
        catch {
            print("Error initializing tips: \(error)")
        }
    }
}
