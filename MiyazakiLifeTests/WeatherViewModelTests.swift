//
//  WeatherViewModelTests.swift
//  MiyazakiLifeTests
//
//  Created by Dev-Coder on 2026-03-11.
//

import XCTest
@testable import MiyazakiLife

final class WeatherViewModelTests: XCTestCase {
    
    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!
    
    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockWeatherService = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertNil(viewModel.currentWeather)
        XCTAssertTrue(viewModel.hourlyForecast.isEmpty)
        XCTAssertTrue(viewModel.dailyForecast.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testTemperatureDisplayFormatting() {
        let weather = WeatherData(
            id: "test-id",
            location: "Test Location",
            temperature: 25.5,
            feelsLike: 27.0,
            humidity: 65,
            windSpeed: 12.0,
            description: "Sunny",
            iconName: "sun.max.fill",
            timestamp: Date()
        )
        
        mockWeatherService.currentWeather = weather
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
        
        XCTAssertEqual(viewModel.temperatureDisplay, "25°")
    }
    
    func testWeatherDescription() {
        let weather = WeatherData(
            id: "test-id",
            location: "Test Location",
            temperature: 20.0,
            feelsLike: 21.0,
            humidity: 70,
            windSpeed: 8.0,
            description: "Cloudy",
            iconName: "cloud.fill",
            timestamp: Date()
        )
        
        mockWeatherService.currentWeather = weather
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
        
        XCTAssertEqual(viewModel.weatherDescription, "Cloudy")
    }
    
    func testWeatherIcon() {
        let weather = WeatherData(
            id: "test-id",
            location: "Test Location",
            temperature: 20.0,
            feelsLike: 21.0,
            humidity: 70,
            windSpeed: 8.0,
            description: "Sunny",
            iconName: "sun.max.fill",
            timestamp: Date()
        )
        
        mockWeatherService.currentWeather = weather
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
        
        XCTAssertEqual(viewModel.weatherIcon, "sun.max.fill")
    }
    
    func testAdditionalInfoItems() {
        let weather = WeatherData(
            id: "test-id",
            location: "Test Location",
            temperature: 20.0,
            feelsLike: 21.0,
            humidity: 70,
            windSpeed: 8.5,
            description: "Sunny",
            iconName: "sun.max.fill",
            timestamp: Date()
        )
        
        mockWeatherService.currentWeather = weather
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
        
        let info = viewModel.additionalInfo
        XCTAssertEqual(info.count, 3)
        
        XCTAssertEqual(info[0].icon, "wind")
        XCTAssertEqual(info[0].label, "风速")
        XCTAssertEqual(info[0].value, "8.5 km/h")
        
        XCTAssertEqual(info[1].icon, "humidity")
        XCTAssertEqual(info[1].label, "湿度")
        XCTAssertEqual(info[1].value, "70%")
        
        XCTAssertEqual(info[2].icon, "thermometer")
        XCTAssertEqual(info[2].label, "体感")
        XCTAssertEqual(info[2].value, "21°")
    }
    
    func testRefreshResetsState() async {
        let initialIsRefreshing = viewModel.isRefreshing
        XCTAssertFalse(initialIsRefreshing)
        
        // We'll just test that refresh doesn't crash
        await viewModel.refresh()
    }
    
    func testLocationDisplay() {
        let weather = WeatherData(
            id: "test-id",
            location: "Miyazaki",
            temperature: 20.0,
            feelsLike: 21.0,
            humidity: 70,
            windSpeed: 8.0,
            description: "Sunny",
            iconName: "sun.max.fill",
            timestamp: Date()
        )
        
        mockWeatherService.currentWeather = weather
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
        
        XCTAssertEqual(viewModel.location, "Miyazaki")
    }
}
