//
//  Localization.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import SwiftUI

// MARK: - Localized Strings

struct L10n {
    // MARK: - Tab
    enum Tab {
        static let home = NSLocalizedString("tab.home", comment: "Home tab title")
        static let weather = NSLocalizedString("tab.weather", comment: "Weather tab title")
        static let settings = NSLocalizedString("tab.settings", comment: "Settings tab title")
    }
    
    // MARK: - Navigation
    enum Nav {
        static let home = NSLocalizedString("nav.title.home", comment: "Home navigation title")
        static let weather = NSLocalizedString("nav.title.weather", comment: "Weather navigation title")
        static let settings = NSLocalizedString("nav.title.settings", comment: "Settings navigation title")
    }
    
    // MARK: - Section
    enum Section {
        static let appearance = NSLocalizedString("section.appearance", comment: "Appearance section header")
        static let notifications = NSLocalizedString("section.notifications", comment: "Notifications section header")
        static let location = NSLocalizedString("section.location", comment: "Location section header")
        static let about = NSLocalizedString("section.about", comment: "About section header")
        static let developer = NSLocalizedString("section.developer", comment: "Developer section header")
    }
    
    // MARK: - Theme
    enum Theme {
        static let light = NSLocalizedString("theme.light", comment: "Light theme option")
        static let dark = NSLocalizedString("theme.dark", comment: "Dark theme option")
        static let system = NSLocalizedString("theme.system", comment: "System theme option")
    }
    
    // MARK: - Temperature Unit
    enum Unit {
        static let celsius = NSLocalizedString("unit.celsius", comment: "Celsius option")
        static let fahrenheit = NSLocalizedString("unit.fahrenheit", comment: "Fahrenheit option")
    }
    
    // MARK: - Toggle
    enum Toggle {
        static let weatherAlerts = NSLocalizedString("toggle.weatherAlerts", comment: "Weather alerts toggle")
        static let dailyReminder = NSLocalizedString("toggle.dailyReminder", comment: "Daily reminder toggle")
    }
    
    // MARK: - Button
    enum Button {
        static let refresh = NSLocalizedString("button.refresh", comment: "Refresh button")
        static let retry = NSLocalizedString("button.retry", comment: "Retry button")
        static let clearCache = NSLocalizedString("button.clearCache", comment: "Clear cache button")
        static let resetSettings = NSLocalizedString("button.resetSettings", comment: "Reset settings button")
        static let goToSettings = NSLocalizedString("button.goToSettings", comment: "Go to settings button")
        static let cancel = NSLocalizedString("button.cancel", comment: "Cancel button")
    }
    
    // MARK: - Label
    enum Label {
        static let location = NSLocalizedString("label.location", comment: "Location label")
        static let temperature = NSLocalizedString("label.temperature", comment: "Temperature label")
        static let humidity = NSLocalizedString("label.humidity", comment: "Humidity label")
        static let windSpeed = NSLocalizedString("label.windSpeed", comment: "Wind speed label")
        static let feelsLike = NSLocalizedString("label.feelsLike", comment: "Feels like label")
        static let hourlyForecast = NSLocalizedString("label.hourlyForecast", comment: "Hourly forecast label")
        static let dailyForecast = NSLocalizedString("label.dailyForecast", comment: "Daily forecast label")
        static let dailyTip = NSLocalizedString("label.dailyTip", comment: "Daily tip label")
        static let version = NSLocalizedString("label.version", comment: "Version label")
        static let build = NSLocalizedString("label.build", comment: "Build label")
        static let privacyPolicy = NSLocalizedString("label.privacyPolicy", comment: "Privacy policy label")
        static let termsOfUse = NSLocalizedString("label.termsOfUse", comment: "Terms of use label")
        static let locationEnabled = NSLocalizedString("label.locationEnabled", comment: "Location enabled text")
        static let locationDisabled = NSLocalizedString("label.locationDisabled", comment: "Location disabled text")
        static let lastUpdated = NSLocalizedString("label.lastUpdated", comment: "Last updated label")
        static let neverUpdated = NSLocalizedString("label.neverUpdated", comment: "Never updated text")
    }
    
    // MARK: - Title
    enum Title {
        static let goodMorning = NSLocalizedString("title.goodMorning", comment: "Good morning greeting")
        static let goodAfternoon = NSLocalizedString("title.goodAfternoon", comment: "Good afternoon greeting")
        static let goodEvening = NSLocalizedString("title.goodEvening", comment: "Good evening greeting")
        static let lateNight = NSLocalizedString("title.lateNight", comment: "Late night greeting")
    }
    
    // MARK: - Error
    enum Error {
        static let invalidURL = NSLocalizedString("error.invalidURL", comment: "Invalid URL error")
        static let networkError = NSLocalizedString("error.networkError", comment: "Network error")
        static let parseError = NSLocalizedString("error.parseError", comment: "Parse error")
        static let locationDenied = NSLocalizedString("error.locationDenied", comment: "Location denied error")
        static let locationUnavailable = NSLocalizedString("error.locationUnavailable", comment: "Location unavailable error")
        static let noData = NSLocalizedString("error.noData", comment: "No data error")
        static let cacheError = NSLocalizedString("error.cacheError", comment: "Cache error")
        static let unknown = NSLocalizedString("error.unknown", comment: "Unknown error")
    }
    
    // MARK: - Alert
    enum Alert {
        static let locationServicesTitle = NSLocalizedString("alert.title.locationServices", comment: "Location services alert title")
        static let locationPermissionMessage = NSLocalizedString("alert.message.locationPermission", comment: "Location permission alert message")
        static let clearCacheTitle = NSLocalizedString("alert.title.clearCache", comment: "Clear cache alert title")
        static let clearCacheMessage = NSLocalizedString("alert.message.clearCache", comment: "Clear cache alert message")
        static let resetSettingsTitle = NSLocalizedString("alert.title.resetSettings", comment: "Reset settings alert title")
        static let resetSettingsMessage = NSLocalizedString("alert.message.resetSettings", comment: "Reset settings alert message")
    }
    
    // MARK: - Loading
    enum Loading {
        static let weather = NSLocalizedString("loading.weather", comment: "Loading weather data text")
        static let pleaseWait = NSLocalizedString("loading.pleaseWait", comment: "Please wait text")
        static let refreshing = NSLocalizedString("loading.refreshing", comment: "Refreshing text")
    }
    
    // MARK: - Empty
    enum Empty {
        static let weatherTitle = NSLocalizedString("empty.title.weather", comment: "No weather data title")
        static let weatherMessage = NSLocalizedString("empty.message.weather", comment: "No weather data message")
    }
    
    // MARK: - Feature
    enum Feature {
        static let weather = NSLocalizedString("feature.weather", comment: "Weather feature title")
        static let schedule = NSLocalizedString("feature.schedule", comment: "Schedule feature title")
        static let notes = NSLocalizedString("feature.notes", comment: "Notes feature title")
        static let more = NSLocalizedString("feature.more", comment: "More feature title")
    }
    
    // MARK: - Hint
    enum Hint {
        static let tapToOpen = NSLocalizedString("hint.tapToOpen", comment: "Tap to open hint")
        static let selectFeature = NSLocalizedString("hint.selectFeature", comment: "Select a feature hint")
    }
    
    // MARK: - Weather
    enum Weather {
        static let sunny = NSLocalizedString("weather.sunny", comment: "Sunny weather description")
        static let mostlySunny = NSLocalizedString("weather.mostlySunny", comment: "Mostly sunny weather description")
        static let partlyCloudy = NSLocalizedString("weather.partlyCloudy", comment: "Partly cloudy weather description")
        static let cloudy = NSLocalizedString("weather.cloudy", comment: "Cloudy weather description")
        static let foggy = NSLocalizedString("weather.foggy", comment: "Foggy weather description")
        static let drizzle = NSLocalizedString("weather.drizzle", comment: "Drizzle weather description")
        static let rain = NSLocalizedString("weather.rain", comment: "Rain weather description")
        static let snow = NSLocalizedString("weather.snow", comment: "Snow weather description")
        static let thunderstorm = NSLocalizedString("weather.thunderstorm", comment: "Thunderstorm weather description")
    }
}
