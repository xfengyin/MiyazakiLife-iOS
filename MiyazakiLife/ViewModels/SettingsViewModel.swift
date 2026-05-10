//
//  SettingsViewModel.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import Foundation
import SwiftUI

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var theme: Theme = .system
    @Published var temperatureUnit: TemperatureUnit = .celsius
    @Published var weatherAlertsEnabled: Bool = true
    @Published var dailyReminderEnabled: Bool = false
    @Published var reminderTime: Date = Date()
    @Published var locationEnabled: Bool = false
    @Published var showingLocationAlert: Bool = false
    @Published var cacheSize: String = "计算中..."

    private let settingsManager: SettingsManager
    private let cacheService: CacheServiceProtocol

    init(settingsManager: SettingsManager = SettingsManager(), cacheService: CacheServiceProtocol = CacheService()) {
        self.settingsManager = settingsManager
        self.cacheService = cacheService
        loadSettings()
        calculateCacheSize()
    }

    func loadSettings() {
        theme = settingsManager.theme
        temperatureUnit = settingsManager.temperatureUnit
        weatherAlertsEnabled = settingsManager.weatherAlertsEnabled
        dailyReminderEnabled = settingsManager.dailyReminderEnabled
        reminderTime = settingsManager.reminderTime
        locationEnabled = settingsManager.locationEnabled
    }

    func saveSettings() {
        settingsManager.theme = theme
        settingsManager.temperatureUnit = temperatureUnit
        settingsManager.weatherAlertsEnabled = weatherAlertsEnabled
        settingsManager.dailyReminderEnabled = dailyReminderEnabled
        settingsManager.reminderTime = reminderTime
        settingsManager.locationEnabled = locationEnabled
        settingsManager.saveSettings()
    }

    func resetToDefaults() {
        settingsManager.resetToDefaults()
        loadSettings()
    }

    func clearCache() {
        cacheService.clearAll()
        calculateCacheSize()
    }

    func calculateCacheSize() {
        Task {
            if let cacheDir = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("MiyazakiLifeCache") {
                var totalSize: Int64 = 0

                if let enumerator = FileManager.default.enumerator(at: cacheDir, includingPropertiesForKeys: [.fileSizeKey]) {
                    while let fileURL = enumerator.nextObject() as? URL {
                        if let fileSize = try? fileURL.resourceValues(forKeys: [.fileSizeKey]).fileSize {
                            totalSize += Int64(fileSize)
                        }
                    }
                }

                let formatter = ByteCountFormatter()
                formatter.allowedUnits = [.useKB, .useMB]
                formatter.countStyle = .file

                await MainActor.run {
                    cacheSize = formatter.string(fromByteCount: totalSize)
                }
            } else {
                await MainActor.run {
                    cacheSize = "0 KB"
                }
            }
        }
    }

    func openLocationSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }

    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    var themeDisplayName: String {
        theme.displayName
    }

    var temperatureUnitDisplayName: String {
        temperatureUnit.displayName
    }

    var locationStatusText: String {
        locationEnabled ? "已启用" : "已禁用"
    }
}
