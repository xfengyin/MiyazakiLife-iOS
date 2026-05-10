//
//  ConfigurationIntent.swift
//  MiyazakiLifeWidget
//
//  Created by Dev-Coder on 2026-03-11.
//

import WidgetKit
import AppIntents

struct ConfigurationIntent: AppIntent {
    static var title: LocalizedStringResource = "配置"
    static var description = IntentDescription("配置天气小部件的显示选项")
    
    @Parameter(title: "位置")
    var location: LocationEntity?
    
    init() {}
    
    init(location: LocationEntity) {
        self.location = location
    }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}

struct LocationEntity: AppEntity {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "位置")
    static var defaultQuery = LocationQuery()
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

struct LocationQuery: EntityQuery {
    func entities(for identifiers: [LocationEntity.ID]) async throws -> [LocationEntity] {
        // 返回默认的宫崎位置
        [
            LocationEntity(
                id: "miyazaki",
                name: "宫崎",
                latitude: 31.9077,
                longitude: 131.4202
            )
        ]
    }
    
    func suggestedEntities() async throws -> [LocationEntity] {
        [
            LocationEntity(
                id: "miyazaki",
                name: "宫崎",
                latitude: 31.9077,
                longitude: 131.4202
            )
        ]
    }
    
    func defaultResult() async -> LocationEntity? {
        LocationEntity(
            id: "miyazaki",
            name: "宫崎",
            latitude: 31.9077,
            longitude: 131.4202
        )
    }
}
