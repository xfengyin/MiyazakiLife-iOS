//
//  WeatherService.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import Foundation
import CoreLocation

@MainActor
class WeatherService: NSObject, ObservableObject, WeatherServiceProtocol {
    @Published var currentWeather: WeatherData?
    @Published var hourlyForecast: [HourlyWeatherData] = []
    @Published var dailyForecast: [DailyWeatherData] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var lastUpdated: Date?

    private let apiBaseURL = Constants.API.baseURL
    private let cacheService: CacheServiceProtocol
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    override init() {
        self.cacheService = CacheService()
        super.init()
        setupLocationManager()
        loadCachedData()
    }

    init(cacheService: CacheServiceProtocol) {
        self.cacheService = cacheService
        super.init()
        setupLocationManager()
        loadCachedData()
    }

    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    private func loadCachedData() {
        Task {
            if let cachedWeather: WeatherData = try? cacheService.load(forKey: Constants.Cache.weatherCacheKey) {
                self.currentWeather = cachedWeather
            }
            if let cachedHourly: [HourlyWeatherData] = try? cacheService.load(forKey: "\(Constants.Cache.weatherCacheKey)_hourly") {
                self.hourlyForecast = cachedHourly
            }
            if let cachedDaily: [DailyWeatherData] = try? cacheService.load(forKey: "\(Constants.Cache.weatherCacheKey)_daily") {
                self.dailyForecast = cachedDaily
            }
        }
    }

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func fetchWeather() async {
        await fetchWeather(
            for: Constants.Location.defaultLatitude,
            longitude: Constants.Location.defaultLongitude
        )
    }

    func fetchWeather(for latitude: Double, longitude: Double) async {
        isLoading = true
        errorMessage = nil

        defer { isLoading = false }

        let cacheKey = "\(Constants.Cache.weatherCacheKey)_\(latitude)_\(longitude)"

        if let cachedResponse: CachedWeatherResponse = try? cacheService.load(forKey: cacheKey) {
            applyWeatherData(cachedResponse)
            lastUpdated = cachedResponse.timestamp
            return
        }

        do {
            let response = try await fetchWeatherData(latitude: latitude, longitude: longitude)
            applyWeatherData(response)

            let cachedResponse = CachedWeatherResponse(
                current: currentWeather,
                hourly: hourlyForecast,
                daily: dailyForecast,
                timestamp: Date()
            )
            try? cacheService.save(cachedResponse, forKey: cacheKey)

            lastUpdated = Date()
        } catch {
            errorMessage = error.localizedDescription
            Logger.log("Weather fetch failed: \(error)", level: .error)
        }
    }

    func refreshWeather() async {
        await fetchWeather()
    }

    private func fetchWeatherData(latitude: Double, longitude: Double) async throws -> CachedWeatherResponse {
        let urlString = buildURL(latitude: latitude, longitude: longitude)

        guard let requestURL = URL(string: urlString) else {
            throw AppError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.timeoutInterval = Constants.API.timeout

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw AppError.networkError(underlying: nil)
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let apiResponse = try decoder.decode(WeatherAPIResponse.self, from: data)
        return parseAPIResponse(apiResponse)
    }

    private func buildURL(latitude: Double, longitude: Double) -> String {
        "\(apiBaseURL)\(Constants.API.forecastEndpoint)" +
        "?latitude=\(latitude)&longitude=\(longitude)" +
        "&current=temperature_2m,relative_humidity_2m,apparent_temperature,weather_code,wind_speed_10m" +
        "&hourly=temperature_2m,weather_code,precipitation_probability" +
        "&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max" +
        "&timezone=auto" +
        "&forecast_days=7"
    }

    private func parseAPIResponse(_ response: WeatherAPIResponse) -> CachedWeatherResponse {
        var currentWeatherData: WeatherData?
        var hourlyData: [HourlyWeatherData] = []
        var dailyData: [DailyWeatherData] = []

        if let current = response.current {
            currentWeatherData = WeatherData(
                location: Constants.Location.defaultLocationName,
                temperature: current.temperature2m,
                feelsLike: current.apparentTemperature,
                humidity: current.relativeHumidity2m,
                windSpeed: current.windSpeed10m,
                description: WeatherData.description(for: current.weatherCode),
                iconName: WeatherData.iconName(for: current.weatherCode),
                timestamp: dateFormatter.date(from: current.time) ?? Date()
            )
        }

        if let hourly = response.hourly {
            let count = min(hourly.time.count, hourly.temperature2m.count, hourly.weatherCode.count)
            hourlyData = (0..<count).map { index in
                HourlyWeatherData(
                    time: dateFormatter.date(from: hourly.time[index]) ?? Date(),
                    temperature: hourly.temperature2m[index],
                    iconName: WeatherData.iconName(for: hourly.weatherCode[index]),
                    precipitationChance: hourly.precipitationProbability?[index] ?? 0
                )
            }
        }

        if let daily = response.daily {
            let count = min(daily.time.count, daily.temperature2mMax.count, daily.temperature2mMin.count, daily.weatherCode.count)
            dailyData = (0..<count).map { index in
                DailyWeatherData(
                    date: dateFormatter.date(from: daily.time[index]) ?? Date(),
                    tempMax: daily.temperature2mMax[index],
                    tempMin: daily.temperature2mMin[index],
                    iconName: WeatherData.iconName(for: daily.weatherCode[index]),
                    description: WeatherData.description(for: daily.weatherCode[index]),
                    precipitationChance: daily.precipitationProbabilityMax?[index] ?? 0
                )
            }
        }

        return CachedWeatherResponse(
            current: currentWeatherData,
            hourly: hourlyData,
            daily: dailyData,
            timestamp: Date()
        )
    }

    private func applyWeatherData(_ response: CachedWeatherResponse) {
        currentWeather = response.current
        hourlyForecast = response.hourly
        dailyForecast = response.daily
    }
}

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

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            if manager.authorizationStatus == .authorizedWhenInUse ||
               manager.authorizationStatus == .authorizedAlways {
                locationManager.startUpdatingLocation()
            }
        }
    }
}

struct CachedWeatherResponse: Codable {
    let current: WeatherData?
    let hourly: [HourlyWeatherData]
    let daily: [DailyWeatherData]
    let timestamp: Date
}

enum LogLevel: String {
    case debug, info, warning, error

    var emoji: String {
        switch self {
        case .debug: return "🔍"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .error: return "❌"
        }
    }
}

struct Logger {
    static func log(_ message: String, level: LogLevel = .info, file: String = #file, function: String = #function, line: Int = #line) {
        #if DEBUG
        let filename = (file as NSString).lastPathComponent
        print("\(level.emoji) [\(level.rawValue.uppercased())] \(filename):\(line) \(function) - \(message)")
        #endif
    }
}
