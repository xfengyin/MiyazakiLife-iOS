//
//  WeatherData.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import Foundation

struct WeatherData: Identifiable, Codable, Equatable {
    let id: String
    let location: String
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let windSpeed: Double
    let description: String
    let iconName: String
    let timestamp: Date

    init(
        id: String = UUID().uuidString,
        location: String,
        temperature: Double,
        feelsLike: Double,
        humidity: Int,
        windSpeed: Double,
        description: String,
        iconName: String,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.location = location
        self.temperature = temperature
        self.feelsLike = feelsLike
        self.humidity = humidity
        self.windSpeed = windSpeed
        self.description = description
        self.iconName = iconName
        self.timestamp = timestamp
    }

    var temperatureString: String {
        "\(Int(temperature))°"
    }

    var feelsLikeString: String {
        "体感 \(Int(feelsLike))°"
    }

    var humidityString: String {
        "\(humidity)%"
    }

    var windSpeedString: String {
        String(format: "%.1f km/h", windSpeed)
    }
}

struct HourlyWeatherData: Identifiable, Codable, Equatable {
    let id: String
    let time: Date
    let temperature: Double
    let iconName: String
    let precipitationChance: Int

    init(
        id: String = UUID().uuidString,
        time: Date,
        temperature: Double,
        iconName: String,
        precipitationChance: Int = 0
    ) {
        self.id = id
        self.time = time
        self.temperature = temperature
        self.iconName = iconName
        self.precipitationChance = precipitationChance
    }

    var temperatureString: String {
        "\(Int(temperature))°"
    }

    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: time)
    }

    var hourString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:00"
        return formatter.string(from: time)
    }
}

struct DailyWeatherData: Identifiable, Codable, Equatable {
    let id: String
    let date: Date
    let tempMax: Double
    let tempMin: Double
    let iconName: String
    let description: String
    let precipitationChance: Int

    init(
        id: String = UUID().uuidString,
        date: Date,
        tempMax: Double,
        tempMin: Double,
        iconName: String,
        description: String,
        precipitationChance: Int = 0
    ) {
        self.id = id
        self.date = date
        self.tempMax = tempMax
        self.tempMin = tempMin
        self.iconName = iconName
        self.description = description
        self.precipitationChance = precipitationChance
    }

    var temperatureRangeString: String {
        "\(Int(tempMax))° / \(Int(tempMin))°"
    }

    var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: date)
    }

    var shortDayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }
}

extension WeatherData {
    static func iconName(for code: Int) -> String {
        switch code {
        case 0: return "sun.max.fill"
        case 1, 2, 3: return "cloud.sun.fill"
        case 45, 48: return "fog.fill"
        case 51, 53, 55: return "cloud.drizzle.fill"
        case 61, 63, 65: return "cloud.rain.fill"
        case 71, 73, 75: return "cloud.snow.fill"
        case 77: return "cloud.sleet.fill"
        case 80, 81, 82: return "cloud.heavyrain.fill"
        case 85, 86: return "cloud.snow.fill"
        case 95, 96, 99: return "cloud.bolt.fill"
        default: return "cloud.fill"
        }
    }

    static func description(for code: Int) -> String {
        switch code {
        case 0: return "晴朗"
        case 1: return "大致晴朗"
        case 2: return "多云"
        case 3: return "阴天"
        case 45, 48: return "雾"
        case 51: return "轻微毛毛雨"
        case 53: return "毛毛雨"
        case 55: return "密集毛毛雨"
        case 61: return "轻微降雨"
        case 63: return "中等降雨"
        case 65: return "大雨"
        case 66, 67: return "冻雨"
        case 71: return "轻微降雪"
        case 73: return "中等降雪"
        case 75: return "大雪"
        case 77: return "雪粒"
        case 80: return "轻微阵雨"
        case 81: return "中等阵雨"
        case 82: return "强烈阵雨"
        case 85: return "轻微雪阵"
        case 86: return "雪阵"
        case 95: return "雷暴"
        case 96, 99: return "雷暴伴冰雹"
        default: return "未知"
        }
    }

    static func color(for code: Int) -> String {
        switch code {
        case 0: return "yellow"
        case 1, 2, 3: return "orange"
        case 45, 48: return "gray"
        case 51, 53, 55, 61, 63, 65, 80, 81, 82: return "blue"
        case 71, 73, 75, 77, 85, 86: return "cyan"
        case 95, 96, 99: return "purple"
        default: return "gray"
        }
    }
}
