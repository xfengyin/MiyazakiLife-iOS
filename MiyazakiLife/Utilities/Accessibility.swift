//
//  Accessibility.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import SwiftUI

// MARK: - Accessibility Helpers

extension View {
    func weatherAccessibility(label: String, value: String? = nil, hint: String? = nil) -> some View {
        self
            .accessibilityLabel(Text(label))
            .accessibilityValue(value.map { Text($0) } ?? Text(""))
            .accessibilityHint(hint.map { Text($0) } ?? Text(""))
    }
    
    func featureCardAccessibility(title: String, hint: String? = nil) -> some View {
        self
            .accessibilityLabel(Text(title))
            .accessibilityHint(hint.map { Text($0) } ?? Text("点击打开"))
            .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Accessibility Identifiers

enum AccessibilityIdentifier: String {
    case homeTab
    case weatherTab
    case settingsTab
    
    case greetingHeader
    case weatherSummaryCard
    case featureGrid
    case dailyTipCard
    
    case currentWeatherCard
    case hourlyForecast
    case dailyForecast
    
    case themePicker
    case temperatureUnitPicker
    case weatherAlertsToggle
    case dailyReminderToggle
    case clearCacheButton
    case resetSettingsButton
}

extension View {
    func accessibilityIdentifier(_ identifier: AccessibilityIdentifier) -> some View {
        self.accessibilityIdentifier(identifier.rawValue)
    }
}

// MARK: - VoiceOver Labels

enum VoiceOverLabels {
    enum Home {
        static let greeting = "问候语"
        static let greetingHint = "显示基于时间的问候"
        
        static let weatherSummary = "天气摘要"
        static let weatherSummaryHint = "查看当前天气的简要信息"
        
        static let featureGrid = "功能网格"
        static let featureGridHint = "选择要访问的功能"
        
        static let dailyTip = "每日提示"
        static let dailyTipHint = "显示当天的建议或提示"
    }
    
    enum Weather {
        static let currentWeather = "当前天气"
        static let currentWeatherHint = "显示当前位置的天气详情"
        
        static let temperature = "温度"
        static let temperatureHint = "当前气温"
        
        static let humidity = "湿度"
        static let humidityHint = "当前相对湿度"
        
        static let windSpeed = "风速"
        static let windSpeedHint = "当前风速"
        
        static let feelsLike = "体感温度"
        static let feelsLikeHint = "实际体感温度"
        
        static let hourlyForecast = "小时预报"
        static let hourlyForecastHint = "接下来几小时的天气预报"
        
        static let dailyForecast = "多日预报"
        static let dailyForecastHint = "未来几天的天气预报"
    }
    
    enum Settings {
        static let theme = "主题设置"
        static let themeHint = "选择浅色、深色或系统自动主题"
        
        static let temperatureUnit = "温度单位"
        static let temperatureUnitHint = "选择摄氏度或华氏度"
        
        static let weatherAlerts = "天气预警"
        static let weatherAlertsHint = "是否接收天气预警通知"
        
        static let dailyReminder = "每日提醒"
        static let dailyReminderHint = "是否启用每日天气提醒"
        
        static let clearCache = "清除缓存"
        static let clearCacheHint = "删除应用缓存数据"
        
        static let resetSettings = "重置设置"
        static let resetSettingsHint = "将所有设置恢复为默认值"
    }
}
