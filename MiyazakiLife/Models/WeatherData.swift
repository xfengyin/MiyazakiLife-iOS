//
//  WeatherData.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import Foundation

// MARK: - 当前天气数据
struct WeatherData: Identifiable, Codable {
    let id: String
    let location: String
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let windSpeed: Double
    let description: String
    let iconName: String
    let timestamp: Date
}

// MARK: - 小时预报数据
struct HourlyWeatherData: Identifiable, Codable {
    let id: String
    let time: Date
    let temperature: Double
    let iconName: String
    let precipitationChance: Int
}

// MARK: - 多日预报数据
struct DailyWeatherData: Identifiable, Codable {
    let id: String
    let date: Date
    let tempMax: Double
    let tempMin: Double
    let iconName: String
    let description: String
    let precipitationChance: Int
}

// MARK: - 天气响应数据
struct WeatherResponse: Codable {
    let current: CurrentWeatherResponse?
    let hourly: HourlyForecastResponse?
    let daily: DailyForecastResponse?
}

struct CurrentWeatherResponse: Codable {
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let windSpeed: Double
    let weatherCode: Int
    let time: String
}

struct HourlyForecastResponse: Codable {
    let time: [String]
    let temperature: [Double]
    let weatherCode: [Int]
}

struct DailyForecastResponse: Codable {
    let time: [String]
    let temperatureMax: [Double]
    let temperatureMin: [Double]
    let weatherCode: [Int]
}

// MARK: - 天气代码映射
extension WeatherData {
    static func iconName(for code: Int) -> String {
        switch code {
        case 0: return "sun.max.fill"
        case 1, 2, 3: return "cloud.sun.fill"
        case 45, 48: return "fog.fill"
        case 51, 53, 55: return "cloud.drizzle.fill"
        case 61, 63, 65: return "cloud.rain.fill"
        case 71, 73, 75: return "cloud.snow.fill"
        case 80, 81, 82: return "cloud.sun.rain.fill"
        case 95, 96, 99: return "cloud.bolt.fill"
        default: return "cloud.fill"
        }
    }
    
    static func description(for code: Int) -> String {
        switch code {
        case 0: return "晴朗"
        case 1, 2, 3: return "多云"
        case 45, 48: return "雾"
        case 51, 53, 55: return "毛毛雨"
        case 61, 63, 65: return "下雨"
        case 71, 73, 75: return "下雪"
        case 80, 81, 82: return "阵雨"
        case 95, 96, 99: return "雷雨"
        default: return "未知"
        }
    }
}
