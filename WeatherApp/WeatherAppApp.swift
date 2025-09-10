//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Sneha Jaiswal on 9/7/25.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject private var appState = AppState()
    
    init() {
        print("✅ Loaded API Key:", Secrets.weatherAPIKey)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}
