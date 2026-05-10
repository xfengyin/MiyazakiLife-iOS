//
//  WeatherWidget.swift
//  MiyazakiLifeWidget
//
//  Created by Dev-Coder on 2026-03-11.
//

import WidgetKit
import SwiftUI

// MARK: - Weather Widget Provider
struct WeatherProvider: AppIntentTimelineProvider {
    typealias Intent = ConfigurationIntent
    typealias Entry = WeatherEntry
    
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(
            date: Date(),
            weather: .placeholder,
            configuration: ConfigurationIntent()
        )
    }
    
    func snapshot(for configuration: ConfigurationIntent, in context: Context) async -> WeatherEntry {
        WeatherEntry(
            date: Date(),
            weather: .placeholder,
            configuration: configuration
        )
    }
    
    func timeline(for configuration: ConfigurationIntent, in context: Context) async -> Timeline<WeatherEntry> {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
        
        let entry = WeatherEntry(
            date: currentDate,
            weather: .placeholder,
            configuration: configuration
        )
        
        return Timeline(entries: [entry], policy: .after(refreshDate))
    }
}

// MARK: - Weather Entry
struct WeatherEntry: TimelineEntry {
    let date: Date
    let weather: WeatherWidgetModel
    let configuration: ConfigurationIntent
}

// MARK: - Weather Widget Model
struct WeatherWidgetModel: Identifiable {
    let id = UUID()
    let location: String
    let temperature: String
    let highTemp: String
    let lowTemp: String
    let iconName: String
    let description: String
    let humidity: String
    let windSpeed: String
    
    static let placeholder = WeatherWidgetModel(
        location: "宫崎",
        temperature: "25°",
        highTemp: "28°",
        lowTemp: "20°",
        iconName: "sun.max.fill",
        description: "晴朗",
        humidity: "65%",
        windSpeed: "12 km/h"
    )
}

// MARK: - Weather Widget View
struct WeatherWidgetEntryView: View {
    var entry: WeatherProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            WeatherSmallWidgetView(weather: entry.weather)
        case .systemMedium:
            WeatherMediumWidgetView(weather: entry.weather)
        case .systemLarge:
            WeatherLargeWidgetView(weather: entry.weather)
        case .accessoryCircular, .accessoryRectangular, .accessoryInline:
            WeatherAccessoryWidgetView(weather: entry.weather)
        @unknown default:
            WeatherSmallWidgetView(weather: entry.weather)
        }
    }
}

// MARK: - Small Widget
struct WeatherSmallWidgetView: View {
    let weather: WeatherWidgetModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.primaryBlue.opacity(0.8), Color.primaryBlue.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 8) {
                Text(weather.location)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white.opacity(0.9))
                
                Spacer()
                
                Image(systemName: weather.iconName)
                    .font(.title)
                    .foregroundColor(.white)
                
                Text(weather.temperature)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                
                Text(weather.description)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(12)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }
}

// MARK: - Medium Widget
struct WeatherMediumWidgetView: View {
    let weather: WeatherWidgetModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.primaryBlue.opacity(0.8), Color.primaryBlue.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(weather.location)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white.opacity(0.9))
                    
                    Text(weather.temperature)
                        .font(.system(size: 40, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(weather.description)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Image(systemName: weather.iconName)
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    
                    VStack(spacing: 4) {
                        Text(weather.highTemp)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        Text(weather.lowTemp)
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }
            }
            .padding(16)
        }
    }
}

// MARK: - Large Widget
struct WeatherLargeWidgetView: View {
    let weather: WeatherWidgetModel
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.primaryBlue.opacity(0.8), Color.primaryBlue.opacity(0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(weather.location)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.9))
                        
                        Text(weather.temperature)
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text(weather.description)
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    Image(systemName: weather.iconName)
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                }
                
                Divider()
                    .background(Color.white.opacity(0.3))
                
                HStack(spacing: 24) {
                    WeatherInfoItemWidget(icon: "humidity", label: "湿度", value: weather.humidity)
                    WeatherInfoItemWidget(icon: "wind", label: "风速", value: weather.windSpeed)
                }
                .foregroundColor(.white)
                
                HStack(spacing: 16) {
                    WeatherDayForecastWidget(day: "今天", tempHigh: weather.highTemp, tempLow: weather.lowTemp, icon: weather.iconName)
                    WeatherDayForecastWidget(day: "明天", tempHigh: weather.highTemp, tempLow: weather.lowTemp, icon: "cloud.fill")
                }
                .foregroundColor(.white)
            }
            .padding(20)
        }
    }
}

// MARK: - Weather Info Item Widget
struct WeatherInfoItemWidget: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
            Text(label)
                .font(.caption)
                .opacity(0.8)
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Weather Day Forecast Widget
struct WeatherDayForecastWidget: View {
    let day: String
    let tempHigh: String
    let tempLow: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(day)
                .font(.subheadline)
                .fontWeight(.medium)
            
            Image(systemName: icon)
                .font(.title2)
            
            VStack(spacing: 4) {
                Text(tempHigh)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(tempLow)
                    .font(.caption)
                    .opacity(0.7)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Accessory Widget
struct WeatherAccessoryWidgetView: View {
    let weather: WeatherWidgetModel
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: weather.iconName)
                .font(.title)
                .foregroundColor(.primaryBlue)
            
            Text(weather.temperature)
                .font(.headline)
                .fontWeight(.medium)
        }
    }
}

// MARK: - Widget Configuration
@main
struct MiyazakiLifeWidgets: WidgetBundle {
    var body: some Widget {
        WeatherWidget()
    }
}

struct WeatherWidget: Widget {
    let kind: String = "MiyazakiLifeWeatherWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: WeatherProvider()
        ) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("宫崎天气")
        .description("快速查看宫崎的天气信息")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .accessoryCircular,
            .accessoryRectangular,
            .accessoryInline
        ])
    }
}

// MARK: - Previews
struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            WeatherSmallWidgetView(weather: .placeholder)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            WeatherMediumWidgetView(weather: .placeholder)
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            WeatherLargeWidgetView(weather: .placeholder)
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
