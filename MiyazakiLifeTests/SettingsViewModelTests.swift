//
//  SettingsViewModelTests.swift
//  MiyazakiLifeTests
//
//  Created by Dev-Coder on 2026-03-11.
//

import XCTest
@testable import MiyazakiLife

final class SettingsViewModelTests: XCTestCase {
    
    var viewModel: SettingsViewModel!
    var settingsManager: SettingsManager!
    var mockCacheService: MockCacheService!
    
    override func setUp() {
        super.setUp()
        settingsManager = SettingsManager()
        mockCacheService = MockCacheService()
        viewModel = SettingsViewModel(settingsManager: settingsManager, cacheService: mockCacheService)
    }
    
    override func tearDown() {
        viewModel = nil
        settingsManager = nil
        mockCacheService = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel.theme, .system)
        XCTAssertEqual(viewModel.temperatureUnit, .celsius)
        XCTAssertTrue(viewModel.weatherAlertsEnabled)
        XCTAssertFalse(viewModel.dailyReminderEnabled)
        XCTAssertFalse(viewModel.locationEnabled)
    }
    
    func testSaveAndLoadSettings() {
        viewModel.theme = .dark
        viewModel.temperatureUnit = .fahrenheit
        viewModel.weatherAlertsEnabled = false
        viewModel.dailyReminderEnabled = true
        viewModel.locationEnabled = true
        
        viewModel.saveSettings()
        
        // Create new VM to test loading
        let newManager = SettingsManager()
        let newVM = SettingsViewModel(settingsManager: newManager, cacheService: mockCacheService)
        newVM.loadSettings()
        
        XCTAssertEqual(newVM.theme, .dark)
        XCTAssertEqual(newVM.temperatureUnit, .fahrenheit)
        XCTAssertFalse(newVM.weatherAlertsEnabled)
        XCTAssertTrue(newVM.dailyReminderEnabled)
        XCTAssertTrue(newVM.locationEnabled)
    }
    
    func testResetToDefaults() {
        viewModel.theme = .dark
        viewModel.temperatureUnit = .fahrenheit
        viewModel.weatherAlertsEnabled = false
        
        viewModel.resetToDefaults()
        
        XCTAssertEqual(viewModel.theme, .system)
        XCTAssertEqual(viewModel.temperatureUnit, .celsius)
        XCTAssertTrue(viewModel.weatherAlertsEnabled)
        XCTAssertFalse(viewModel.dailyReminderEnabled)
    }
    
    func testThemeDisplayNames() {
        viewModel.theme = .light
        XCTAssertEqual(viewModel.themeDisplayName, "浅色")
        
        viewModel.theme = .dark
        XCTAssertEqual(viewModel.themeDisplayName, "深色")
        
        viewModel.theme = .system
        XCTAssertEqual(viewModel.themeDisplayName, "自动")
    }
    
    func testTemperatureUnitDisplayNames() {
        viewModel.temperatureUnit = .celsius
        XCTAssertEqual(viewModel.temperatureUnitDisplayName, "°C")
        
        viewModel.temperatureUnit = .fahrenheit
        XCTAssertEqual(viewModel.temperatureUnitDisplayName, "°F")
    }
    
    func testLocationStatusText() {
        viewModel.locationEnabled = true
        XCTAssertEqual(viewModel.locationStatusText, "已启用")
        
        viewModel.locationEnabled = false
        XCTAssertEqual(viewModel.locationStatusText, "已禁用")
    }
    
    func testVersionInfo() {
        XCTAssertFalse(viewModel.appVersion.isEmpty)
        XCTAssertFalse(viewModel.buildNumber.isEmpty)
    }
    
    func testClearCache() {
        // Just test that it doesn't crash
        viewModel.clearCache()
    }
    
    func testCalculateCacheSize() {
        // Just test that it doesn't crash
        viewModel.calculateCacheSize()
        XCTAssertFalse(viewModel.cacheSize.isEmpty)
    }
}

class MockCacheService: CacheServiceProtocol {
    var cachedData: [String: Data] = [:]
    
    func save<T: Encodable>(_ value: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(value)
        cachedData[key] = data
    }
    
    func load<T: Decodable>(forKey key: String) throws -> T? {
        guard let data = cachedData[key] else { return nil }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func remove(forKey key: String) {
        cachedData.removeValue(forKey: key)
    }
    
    func clearAll() {
        cachedData.removeAll()
    }
}
