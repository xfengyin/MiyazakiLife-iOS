//
//  HomeViewModel.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var greeting: String = ""
    @Published var currentWeather: WeatherData?
    @Published var dailyTip: DailyTip = DailyTip.defaultTip
    @Published var features: [Feature] = Feature.defaultFeatures
    @Published var isLoading: Bool = false

    private let weatherService: WeatherServiceProtocol?

    init(weatherService: WeatherServiceProtocol? = nil) {
        self.weatherService = weatherService
        updateGreeting()
        loadData()
    }

    func refresh() async {
        isLoading = true
        updateGreeting()
        loadData()
        isLoading = false
    }

    func loadData() {
        if let service = weatherService {
            currentWeather = service.currentWeather
        }
        loadDailyTip()
    }

    private func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())

        switch hour {
        case 5..<12:
            greeting = "早上好，宫崎！☀️"
        case 12..<14:
            greeting = "中午好，宫崎！🌤️"
        case 14..<18:
            greeting = "下午好，宫崎！🌤️"
        case 18..<22:
            greeting = "晚上好，宫崎！🌙"
        default:
            greeting = "夜深了，宫崎！⭐"
        }
    }

    private func loadDailyTip() {
        let tips = [
            DailyTip(
                title: "今日天气",
                content: currentWeather != nil
                    ? "今天\(currentWeather!.location)的天气是\(currentWeather!.description)，温度\(currentWeather!.temperatureString)。\(getWeatherSuggestion())"
                    : "今天宫崎的天气不错，适合出门走走！"
            ),
            DailyTip(
                title: "健康提醒",
                content: "记得多喝水，保持充足睡眠，这对身体健康很重要。💧"
            ),
            DailyTip(
                title: "运动建议",
                content: "天气晴朗时适合户外运动，散步、跑步或骑行都是不错的选择。🏃"
            )
        ]

        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        dailyTip = tips[dayOfYear % tips.count]
    }

    private func getWeatherSuggestion() -> String {
        guard let weather = currentWeather else { return "" }

        if weather.temperature > 30 {
            return "天气炎热，请注意防暑降温。"
        } else if weather.temperature < 10 {
            return "天气较冷，请注意保暖。"
        } else if weather.description.contains("雨") {
            return "记得带上雨伞以防万一。☂️"
        } else {
            return "适合出门活动！🌸"
        }
    }
}

struct DailyTip: Identifiable {
    let id = UUID()
    let title: String
    let content: String

    static let defaultTip = DailyTip(
        title: "每日提示",
        content: "今天宫崎的天气不错，适合出门走走！记得带上雨伞以防万一。☂️"
    )
}

struct Feature: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let color: Color
    let action: FeatureAction

    enum FeatureAction {
        case weather
        case schedule
        case notes
        case more
    }

    static let defaultFeatures: [Feature] = [
        Feature(title: "天气", icon: "cloud.sun.fill", color: .blue, action: .weather),
        Feature(title: "日程", icon: "calendar", color: .green, action: .schedule),
        Feature(title: "笔记", icon: "note.text", color: .orange, action: .notes),
        Feature(title: "更多", icon: "ellipsis", color: .purple, action: .more)
    ]
}
