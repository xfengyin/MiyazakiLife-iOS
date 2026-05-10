//
//  HomeViewModelTests.swift
//  MiyazakiLifeTests
//
//  Created by Dev-Coder on 2026-03-11.
//

import XCTest
@testable import MiyazakiLife
import SwiftUI

final class HomeViewModelTests: XCTestCase {
    
    var viewModel: HomeViewModel!
    var mockWeatherService: MockWeatherService!
    
    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        viewModel = HomeViewModel(weatherService: mockWeatherService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockWeatherService = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertNotNil(viewModel)
        XCTAssertNotNil(viewModel.features)
        XCTAssertFalse(viewModel.features.isEmpty)
        XCTAssertNotNil(viewModel.dailyTip)
    }
    
    func testGreetingUpdatesBasedOnTime() {
        let originalGreeting = viewModel.greeting
        
        // Greeting should be set
        XCTAssertFalse(originalGreeting.isEmpty)
        XCTAssertNotNil(originalGreeting)
    }
    
    func testDailyTipContent() {
        let tip = viewModel.dailyTip
        XCTAssertFalse(tip.title.isEmpty)
        XCTAssertFalse(tip.content.isEmpty)
    }
    
    func testFeaturesCount() {
        XCTAssertEqual(viewModel.features.count, 4)
    }
    
    func testFeatureTitles() {
        let titles = viewModel.features.map { $0.title }
        XCTAssertTrue(titles.contains("天气"))
        XCTAssertTrue(titles.contains("日程"))
        XCTAssertTrue(titles.contains("笔记"))
        XCTAssertTrue(titles.contains("更多"))
    }
    
    func testFeatureActions() {
        let actions = viewModel.features.map { $0.action }
        XCTAssertTrue(actions.contains(.weather))
        XCTAssertTrue(actions.contains(.schedule))
        XCTAssertTrue(actions.contains(.notes))
        XCTAssertTrue(actions.contains(.more))
    }
}

class MockWeatherService: WeatherServiceProtocol {
    var currentWeather: WeatherData?
    var hourlyForecast: [HourlyWeatherData] = []
    var dailyForecast: [DailyWeatherData] = []
    var isLoading: Bool = false
    var errorMessage: String?
    var lastUpdated: Date?
    
    func fetchWeather() async {
        isLoading = true
        defer { isLoading = false }
        
        currentWeather = WeatherData(
            id: "test-id",
            location: "Test Location",
            temperature: 25.0,
            feelsLike: 26.0,
            humidity: 60,
            windSpeed: 10.0,
            description: "Sunny",
            iconName: "sun.max.fill",
            timestamp: Date()
        )
    }
    
    func fetchWeather(for latitude: Double, longitude: Double) async {
        await fetchWeather()
    }
    
    func refreshWeather() async {
        await fetchWeather()
    }
}
