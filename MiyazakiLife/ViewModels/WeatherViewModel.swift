//
//  WeatherViewModel.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import Foundation
import SwiftUI

@MainActor
class WeatherViewModel: ObservableObject {
    @Published var currentWeather: WeatherData?
    @Published var hourlyForecast: [HourlyWeatherData] = []
    @Published var dailyForecast: [DailyWeatherData] = []
    @Published var isLoading: Bool = false
    @Published var isRefreshing: Bool = false
    @Published var errorMessage: String?
    @Published var lastUpdated: Date?
    @Published var location: String = "宫崎"

    private let weatherService: WeatherServiceProtocol?

    init(weatherService: WeatherServiceProtocol? = nil) {
        self.weatherService = weatherService
        loadData()
    }

    func loadData() {
        guard let service = weatherService else { return }

        currentWeather = service.currentWeather
        hourlyForecast = service.hourlyForecast
        dailyForecast = service.dailyForecast
        isLoading = service.isLoading
        errorMessage = service.errorMessage
        lastUpdated = service.lastUpdated

        if let weather = currentWeather {
            location = weather.location
        }
    }

    func refresh() async {
        isRefreshing = true

        guard let service = weatherService else {
            isRefreshing = false
            return
        }

        await service.refreshWeather()

        await MainActor.run {
            loadData()
            isRefreshing = false
        }
    }

    func fetchWeather() async {
        guard let service = weatherService else { return }

        await service.fetchWeather()

        await MainActor.run {
            loadData()
        }
    }

    var lastUpdatedString: String {
        guard let lastUpdated = lastUpdated else {
            return "从未更新"
        }

        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: lastUpdated, relativeTo: Date())
    }

    var temperatureDisplay: String {
        guard let temp = currentWeather?.temperature else {
            return "--"
        }
        return "\(Int(temp))°"
    }

    var weatherDescription: String {
        currentWeather?.description ?? "暂无数据"
    }

    var weatherIcon: String {
        currentWeather?.iconName ?? "cloud.fill"
    }

    var additionalInfo: [(icon: String, label: String, value: String)] {
        guard let weather = currentWeather else {
            return []
        }

        return [
            (icon: "wind", label: "风速", value: weather.windSpeedString),
            (icon: "humidity", label: "湿度", value: weather.humidityString),
            (icon: "thermometer", label: "体感", value: weather.feelsLikeString)
        ]
    }
}
