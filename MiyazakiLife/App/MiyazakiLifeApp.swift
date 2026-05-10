//
//  MiyazakiLifeApp.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import SwiftUI

@main
struct MiyazakiLifeApp: App {
    @StateObject private var weatherService = WeatherService()
    @StateObject private var settingsManager = SettingsManager()

    init() {
        setupAppearance()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(weatherService)
                .environmentObject(settingsManager)
                .preferredColorScheme(colorScheme)
        }
    }

    private var colorScheme: ColorScheme? {
        switch settingsManager.theme {
        case .light:
            return .light
        case .dark:
            return .dark
        case .system:
            return nil
        }
    }

    private func setupAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
}
