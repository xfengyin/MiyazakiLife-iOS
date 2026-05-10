//
//  WeatherServiceProtocol.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import Foundation
import CoreLocation

protocol WeatherServiceProtocol: ObservableObject {
    var currentWeather: WeatherData? { get }
    var hourlyForecast: [HourlyWeatherData] { get }
    var dailyForecast: [DailyWeatherData] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var lastUpdated: Date? { get }

    func fetchWeather() async
    func fetchWeather(for latitude: Double, longitude: Double) async
    func refreshWeather() async
}

protocol LocationServiceProtocol: ObservableObject {
    var currentLocation: CLLocation? { get }
    var authorizationStatus: CLAuthorizationStatus { get }
    var isLocationAvailable: Bool { get }

    func requestLocationPermission()
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

protocol CacheServiceProtocol {
    func save<T: Encodable>(_ value: T, forKey key: String) throws
    func load<T: Decodable>(forKey key: String) throws -> T?
    func remove(forKey key: String)
    func clearAll()
}
