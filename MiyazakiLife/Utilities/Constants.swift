//
//  Constants.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import Foundation

enum Constants {
    enum API {
        static let baseURL = "https://api.open-meteo.com/v1"
        static let forecastEndpoint = "/forecast"
        static let timeout: TimeInterval = 10.0
        static let retryCount = 3
    }

    enum Location {
        static let miyazakiLatitude: Double = 31.9077
        static let miyazakiLongitude: Double = 131.4202
        static let miyazakiName = "宫崎"

        static let defaultLatitude = miyazakiLatitude
        static let defaultLongitude = miyazakiLongitude
        static let defaultLocationName = miyazakiName
    }

    enum Cache {
        static let weatherCacheKey = "weather_cache"
        static let settingsCacheKey = "settings_cache"
        static let memoryCacheExpiration: TimeInterval = 30 * 60
        static let diskCacheExpiration: TimeInterval = 24 * 60 * 60
    }

    enum Animation {
        static let defaultDuration: Double = 0.3
        static let springResponse: Double = 0.5
        static let springDamping: Double = 0.8
    }

    enum UI {
        static let cornerRadius: CGFloat = 16
        static let cardPadding: CGFloat = 20
        static let gridSpacing: CGFloat = 15
        static let iconSize: CGFloat = 60
        static let largeIconSize: CGFloat = 80
    }
}
