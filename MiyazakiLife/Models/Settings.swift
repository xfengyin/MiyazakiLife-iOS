//
//  Settings.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import Foundation
import SwiftUI

// MARK: - 主题枚举
enum Theme: String, CaseIterable, Codable {
    case light = "light"
    case dark = "dark"
    case system = "system"
    
    var displayName: String {
        switch self {
        case .light: return "浅色"
        case .dark: return "深色"
        case .system: return "自动"
        }
    }
}

// MARK: - 温度单位枚举
enum TemperatureUnit: String, CaseIterable, Codable {
    case celsius = "celsius"
    case fahrenheit = "fahrenheit"
    
    var displayName: String {
        switch self {
        case .celsius: return "°C"
        case .fahrenheit: return "°F"
        }
    }
    
    func convert(from celsius: Double) -> Double {
        switch self {
        case .celsius: return celsius
        case .fahrenheit: return (celsius * 9/5) + 32
        }
    }
}

// MARK: - 设置管理器
class SettingsManager: ObservableObject {
    // MARK: - Published Properties
    @Published var theme: Theme = .system
    @Published var temperatureUnit: TemperatureUnit = .celsius
    @Published var weatherAlertsEnabled: Bool = true
    @Published var dailyReminderEnabled: Bool = false
    @Published var reminderTime: Date = Date()
    @Published var locationEnabled: Bool = false
    
    // MARK: - Keys
    private enum Keys {
        static let theme = "theme"
        static let temperatureUnit = "temperatureUnit"
        static let weatherAlertsEnabled = "weatherAlertsEnabled"
        static let dailyReminderEnabled = "dailyReminderEnabled"
        static let reminderTime = "reminderTime"
        static let locationEnabled = "locationEnabled"
    }
    
    // MARK: - Init
    init() {
        loadSettings()
    }
    
    // MARK: - Load Settings
    func loadSettings() {
        if let themeRaw = UserDefaults.standard.string(forKey: Keys.theme),
           let theme = Theme(rawValue: themeRaw) {
            self.theme = theme
        }
        
        if let unitRaw = UserDefaults.standard.string(forKey: Keys.temperatureUnit),
           let unit = TemperatureUnit(rawValue: unitRaw) {
            self.temperatureUnit = unit
        }
        
        self.weatherAlertsEnabled = UserDefaults.standard.bool(forKey: Keys.weatherAlertsEnabled)
        self.dailyReminderEnabled = UserDefaults.standard.bool(forKey: Keys.dailyReminderEnabled)
        
        if let reminderTimeData = UserDefaults.standard.data(forKey: Keys.reminderTime),
           let reminderTime = try? CodableDate.decode(reminderTimeData) {
            self.reminderTime = reminderTime
        }
        
        self.locationEnabled = UserDefaults.standard.bool(forKey: Keys.locationEnabled)
    }
    
    // MARK: - Save Settings
    func saveSettings() {
        UserDefaults.standard.set(theme.rawValue, forKey: Keys.theme)
        UserDefaults.standard.set(temperatureUnit.rawValue, forKey: Keys.temperatureUnit)
        UserDefaults.standard.set(weatherAlertsEnabled, forKey: Keys.weatherAlertsEnabled)
        UserDefaults.standard.set(dailyReminderEnabled, forKey: Keys.dailyReminderEnabled)
        UserDefaults.standard.set(try? CodableDate.encode(reminderTime), forKey: Keys.reminderTime)
        UserDefaults.standard.set(locationEnabled, forKey: Keys.locationEnabled)
    }
    
    // MARK: - Reset to Defaults
    func resetToDefaults() {
        theme = .system
        temperatureUnit = .celsius
        weatherAlertsEnabled = true
        dailyReminderEnabled = false
        reminderTime = Date()
        locationEnabled = false
        saveSettings()
    }
}

// MARK: - Codable Date Helper
struct CodableDate {
    static func encode(_ date: Date) -> Data? {
        try? JSONEncoder().encode(date)
    }
    
    static func decode(_ data: Data) throws -> Date {
        try JSONDecoder().decode(Date.self, from: data)
    }
}
