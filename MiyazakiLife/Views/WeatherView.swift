//
//  WeatherView.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import SwiftUI

struct WeatherView: View {
    @EnvironmentObject var weatherService: WeatherService
    @State private var isRefreshing = false
    
    var body: some View {
        NavigationView {
            Group {
                if weatherService.isLoading {
                    LoadingView()
                } else if let weatherData = weatherService.currentWeather {
                    ScrollView {
                        VStack(spacing: 20) {
                            // 当前天气
                            CurrentWeatherCard(weather: weatherData)
                            
                            // 小时预报
                            HourlyForecastView(forecast: weatherService.hourlyForecast)
                            
                            // 多日预报
                            DailyForecastView(forecast: weatherService.dailyForecast)
                        }
                        .padding()
                    }
                } else {
                    ErrorView(onRetry: {
                        Task {
                            await weatherService.fetchWeather()
                        }
                    })
                }
            }
            .navigationTitle("天气")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: refreshWeather) {
                        Image(systemName: "arrow.clockwise")
                            .rotationEffect(.degrees(isRefreshing ? 360 : 0))
                            .animation(isRefreshing ? .linear(duration: 1).repeatForever(autoreverses: false) : .default, value: isRefreshing)
                    }
                    .disabled(isRefreshing)
                }
            }
            .onAppear {
                Task {
                    await weatherService.fetchWeather()
                }
            }
        }
    }
    
    private func refreshWeather() {
        isRefreshing = true
        Task {
            await weatherService.fetchWeather()
            isRefreshing = false
        }
    }
}

// MARK: - 当前天气卡片
struct CurrentWeatherCard: View {
    let weather: WeatherData
    
    var body: some View {
        VStack(spacing: 15) {
            Text(weather.location)
                .font(.title2)
                .fontWeight(.medium)
            
            HStack(spacing: 20) {
                Image(systemName: weather.iconName)
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading) {
                    Text("\(Int(weather.temperature))°")
                        .font(.system(size: 50))
                        .fontWeight(.bold)
                    
                    Text(weather.description)
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack(spacing: 30) {
                WeatherInfoItem(icon: "wind", label: "风速", value: "\(weather.windSpeed) km/h")
                WeatherInfoItem(icon: "humidity", label: "湿度", value: "\(weather.humidity)%")
                WeatherInfoItem(icon: "thermometer", label: "体感", value: "\(Int(weather.feelsLike))°")
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

// MARK: - 天气信息项
struct WeatherInfoItem: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(.secondary)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
    }
}

// MARK: - 小时预报
struct HourlyForecastView: View {
    let forecast: [HourlyWeatherData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("小时预报")
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(forecast.prefix(8), id: \.time) { item in
                        VStack(spacing: 8) {
                            Text(formatHour(item.time))
                                .font(.caption)
                                .foregroundColor(.secondary)
                            
                            Image(systemName: item.iconName)
                                .font(.title2)
                            
                            Text("\(Int(item.temperature))°")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .frame(width: 60)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                }
            }
        }
    }
    
    private func formatHour(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:00"
        return formatter.string(from: time)
    }
}

// MARK: - 多日预报
struct DailyForecastView: View {
    let forecast: [DailyWeatherData]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("多日预报")
                .font(.headline)
            
            VStack(spacing: 8) {
                ForEach(forecast.prefix(5), id: \.date) { item in
                    HStack {
                        Text(formatDay(item.date))
                            .frame(width: 60, alignment: .leading)
                        
                        Image(systemName: item.iconName)
                            .frame(width: 40)
                        
                        Spacer()
                        
                        Text("\(Int(item.tempMax))° / \(Int(item.tempMin))°")
                            .fontWeight(.medium)
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }
            }
        }
    }
    
    private func formatDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

// MARK: - 加载视图
struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(1.5)
            Text("正在加载天气数据...")
                .foregroundColor(.secondary)
                .padding(.top)
        }
    }
}

// MARK: - 错误视图
struct ErrorView: View {
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("无法加载天气数据")
                .font(.headline)
            
            Text("请检查网络连接后重试")
                .foregroundColor(.secondary)
            
            Button(action: onRetry) {
                Text("重试")
                    .fontWeight(.medium)
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    WeatherView()
        .environmentObject(WeatherService())
        .environmentObject(SettingsManager())
}
