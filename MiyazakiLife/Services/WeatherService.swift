//
//  WeatherService.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import Foundation
import CoreLocation

// MARK: - 天气服务
@MainActor
class WeatherService: NSObject, ObservableObject {
    // MARK: - Published Properties
    @Published var currentWeather: WeatherData?
    @Published var hourlyForecast: [HourlyWeatherData] = []
    @Published var dailyForecast: [DailyWeatherData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    // MARK: - Location Manager
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    
    // MARK: - API Configuration
    private let apiBaseURL = "https://api.open-meteo.com/v1"
    
    // MARK: - Init
    override init() {
        super.init()
        setupLocationManager()
    }
    
    // MARK: - Setup Location Manager
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    // MARK: - Request Location Permission
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Fetch Weather
    func fetchWeather() async {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        let latitude = 31.9077
        let longitude = 131.4202
        
        do {
            try await fetchWeatherData(latitude: latitude, longitude: longitude)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: - Fetch Weather Data
    private func fetchWeatherData(latitude: Double, longitude: Double) async throws {
        let url = "\(apiBaseURL)/forecast?latitude=\(latitude)&longitude=\(longitude)" +
                  "&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m" +
                  "&hourly=temperature_2m,weather_code" +
                  "&daily=weather_code,temperature_2m_max,temperature_2m_min" +
                  "&timezone=auto"
        
        guard let requestURL = URL(string: url) else {
            throw WeatherError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: requestURL)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw WeatherError.networkError
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let weatherResponse = try decoder.decode(WeatherAPIResponse.self, from: data)
        parseWeatherData(weatherResponse)
    }
    
    // MARK: - Parse Weather Data
    private func parseWeatherData(_ response: WeatherAPIResponse) {
        // 解析当前天气
        if let current = response.current {
            currentWeather = WeatherData(
                id: UUID().uuidString,
                location: "宫崎市",
                temperature: current.temperature2m,
                feelsLike: current.apparentTemperature,
                humidity: current.relativeHumidity2m,
                windSpeed: current.windSpeed10m,
                description: WeatherData.description(for: current.weatherCode),
                iconName: WeatherData.iconName(for: current.weatherCode),
                timestamp: ISO8601DateFormatter().date(from: current.time) ?? Date()
            )
        }
        
        // 解析小时预报
        if let hourly = response.hourly {
            hourlyForecast = zip(hourly.time, hourly.temperature2m).enumerated().map { (index, pair) in
                let (time, temp) = pair
                return HourlyWeatherData(
                    id: UUID().uuidString,
                    time: ISO8601DateFormatter().date(from: time) ?? Date(),
                    temperature: temp,
                    iconName: WeatherData.iconName(for: hourly.weatherCode[index]),
                    precipitationChance: 0
                )
            }
        }
        
        // 解析多日预报
        if let daily = response.daily {
            dailyForecast = zip(daily.time, daily.temperature2mMax).enumerated().map { (index, pair) in
                let (time, tempMax) = pair
                return DailyWeatherData(
                    id: UUID().uuidString,
                    date: ISO8601DateFormatter().date(from: time) ?? Date(),
                    tempMax: tempMax,
                    tempMin: daily.temperature2mMin[index],
                    iconName: WeatherData.iconName(for: daily.weatherCode[index]),
                    description: WeatherData.description(for: daily.weatherCode[index]),
                    precipitationChance: 0
                )
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherService: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            currentLocation = locations.first
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            errorMessage = "定位失败：\(error.localizedDescription)"
        }
    }
}

// MARK: - Weather Error
enum WeatherError: LocalizedError {
    case invalidURL
    case networkError
    case parseError
    case locationDenied
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "无效的 URL"
        case .networkError: return "网络错误，请检查连接"
        case .parseError: return "数据解析失败"
        case .locationDenied: return "定位服务被拒绝"
        }
    }
}

// MARK: - API Response Models
struct WeatherAPIResponse: Codable {
    let current: CurrentWeather?
    let hourly: HourlyWeather?
    let daily: DailyWeather?
}

struct CurrentWeather: Codable {
    let time: String
    let temperature2m: Double
    let relativeHumidity2m: Int
    let apparentTemperature: Double
    let weatherCode: Int
    let windSpeed10m: Double
}

struct HourlyWeather: Codable {
    let time: [String]
    let temperature2m: [Double]
    let weatherCode: [Int]
}

struct DailyWeather: Codable {
    let time: [String]
    let temperature2mMax: [Double]
    let temperature2mMin: [Double]
    let weatherCode: [Int]
}
