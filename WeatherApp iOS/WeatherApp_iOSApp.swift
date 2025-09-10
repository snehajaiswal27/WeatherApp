//
//  WeatherApp_iOSApp.swift
//  WeatherApp iOS
//
//  Created by Sneha Jaiswal on 9/9/25.
//

import SwiftUI
import FirebaseCore

@main
struct WeatherApp_iOSApp: App {
    init() {
        FirebaseApp.configure()
        print("Firebase configured? ->", FirebaseApp.app() != nil)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppState())
        }
    }
}
