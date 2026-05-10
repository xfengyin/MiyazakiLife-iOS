//
//  WeatherAPIResponse.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import Foundation

struct WeatherAPIResponse: Codable {
    let latitude: Double?
    let longitude: Double?
    let timezone: String?
    let current: CurrentWeatherResponse?
    let hourly: HourlyWeatherResponse?
    let daily: DailyWeatherResponse?
}

struct CurrentWeatherResponse: Codable {
    let time: String
    let temperature2m: Double
    let relativeHumidity2m: Int
    let apparentTemperature: Double
    let weatherCode: Int
    let windSpeed10m: Double
}

struct HourlyWeatherResponse: Codable {
    let time: [String]
    let temperature2m: [Double]
    let weatherCode: [Int]
    let precipitationProbability: [Int]?
}

struct DailyWeatherResponse: Codable {
    let time: [String]
    let weatherCode: [Int]
    let temperature2mMax: [Double]
    let temperature2mMin: [Double]
    let precipitationProbabilityMax: [Int]?
}
