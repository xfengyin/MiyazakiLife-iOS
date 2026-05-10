//
//  MiyazakiLifeTests.swift
//  MiyazakiLifeTests
//
//  Created by Dev-Coder on 2026-03-11.
//

import XCTest
@testable import MiyazakiLife

final class MiyazakiLifeTests: XCTestCase {
    
    override func setUpWithError() throws {
        super.setUp()
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
    }
    
    func testWeatherDataModel() {
        let weather = WeatherData(
            id: "test-id",
            location: "Test Location",
            temperature: 25.5,
            feelsLike: 26.0,
            humidity: 65,
            windSpeed: 12.5,
            description: "Sunny",
            iconName: "sun.max.fill",
            timestamp: Date()
        )
        
        XCTAssertEqual(weather.id, "test-id")
        XCTAssertEqual(weather.location, "Test Location")
        XCTAssertEqual(weather.temperature, 25.5)
        XCTAssertEqual(weather.temperatureString, "25°")
        XCTAssertEqual(weather.feelsLikeString, "体感 26°")
        XCTAssertEqual(weather.humidityString, "65%")
        XCTAssertEqual(weather.windSpeedString, "12.5 km/h")
    }
    
    func testHourlyWeatherDataModel() {
        let date = Date()
        let hourly = HourlyWeatherData(
            id: "hourly-1",
            time: date,
            temperature: 23.0,
            iconName: "cloud.fill",
            precipitationChance: 30
        )
        
        XCTAssertEqual(hourly.id, "hourly-1")
        XCTAssertEqual(hourly.temperature, 23.0)
        XCTAssertEqual(hourly.temperatureString, "23°")
        XCTAssertEqual(hourly.precipitationChance, 30)
    }
    
    func testDailyWeatherDataModel() {
        let date = Date()
        let daily = DailyWeatherData(
            id: "daily-1",
            date: date,
            tempMax: 28.0,
            tempMin: 18.0,
            iconName: "sun.max.fill",
            description: "Sunny",
            precipitationChance: 10
        )
        
        XCTAssertEqual(daily.id, "daily-1")
        XCTAssertEqual(daily.tempMax, 28.0)
        XCTAssertEqual(daily.tempMin, 18.0)
        XCTAssertEqual(daily.temperatureRangeString, "28° / 18°")
        XCTAssertTrue(daily.isToday)
    }
    
    func testWeatherCodeMapping() {
        XCTAssertEqual(WeatherData.iconName(for: 0), "sun.max.fill")
        XCTAssertEqual(WeatherData.description(for: 0), "晴朗")
        
        XCTAssertEqual(WeatherData.iconName(for: 51), "cloud.drizzle.fill")
        XCTAssertEqual(WeatherData.description(for: 51), "轻微毛毛雨")
        
        XCTAssertEqual(WeatherData.iconName(for: 61), "cloud.rain.fill")
        XCTAssertEqual(WeatherData.description(for: 61), "轻微降雨")
        
        XCTAssertEqual(WeatherData.iconName(for: 71), "cloud.snow.fill")
        XCTAssertEqual(WeatherData.description(for: 71), "轻微降雪")
        
        XCTAssertEqual(WeatherData.iconName(for: 95), "cloud.bolt.fill")
        XCTAssertEqual(WeatherData.description(for: 95), "雷暴")
    }
    
    func testThemeEnum() {
        XCTAssertEqual(Theme.light.displayName, "浅色")
        XCTAssertEqual(Theme.dark.displayName, "深色")
        XCTAssertEqual(Theme.system.displayName, "自动")
    }
    
    func testTemperatureUnitEnum() {
        XCTAssertEqual(TemperatureUnit.celsius.displayName, "°C")
        XCTAssertEqual(TemperatureUnit.fahrenheit.displayName, "°F")
        XCTAssertEqual(TemperatureUnit.celsius.convert(from: 25), 25)
        XCTAssertEqual(TemperatureUnit.fahrenheit.convert(from: 25), 77)
    }
    
    func testAppErrorDescription() {
        XCTAssertEqual(AppError.invalidURL.errorDescription, "无效的 URL")
        XCTAssertEqual(AppError.networkError(underlying: nil).errorDescription, "网络错误")
        XCTAssertEqual(AppError.parseError.errorDescription, "数据解析失败")
        XCTAssertEqual(AppError.locationDenied.errorDescription, "定位服务被拒绝")
        XCTAssertEqual(AppError.noData.errorDescription, "暂无数据")
        XCTAssertEqual(AppError.cacheError.errorDescription, "缓存读取失败")
        XCTAssertEqual(AppError.unknownError.errorDescription, "未知错误")
    }
    
    func testDateExtensions() {
        let now = Date()
        
        XCTAssertTrue(now.isToday)
        let tomorrow = now.addingTimeInterval(86400)
        XCTAssertTrue(tomorrow.isTomorrow)
        
        XCTAssertFalse(now.hourString.isEmpty)
        XCTAssertFalse(now.shortDayString.isEmpty)
        XCTAssertFalse(now.fullDayString.isEmpty)
        XCTAssertFalse(now.dateString.isEmpty)
    }
}
