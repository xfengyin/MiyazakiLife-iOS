//
//  WeatherView.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct WeatherView: View {
    @EnvironmentObject var weatherService: WeatherService
    @StateObject private var viewModel = WeatherViewModel()
    @State private var isRefreshing = false

    var body: some View {
        NavigationView {
            ZStack {
                contentView
                    .navigationTitle("天气")
                    .toolbar { toolbarContent }

                if isRefreshing {
                    LoadingOverlay(message: "刷新中...")
                }
            }
            .onAppear {
                viewModel.loadData()
                Task {
                    await viewModel.fetchWeather()
                }
            }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if viewModel.isLoading && viewModel.currentWeather == nil {
            LoadingView()
        } else if let errorMessage = viewModel.errorMessage, viewModel.currentWeather == nil {
            ErrorView(error: AppError.networkError(underlying: nil)) {
                Task {
                    await viewModel.fetchWeather()
                }
            }
        } else {
            ScrollView {
                VStack(spacing: 24) {
                    if let weather = viewModel.currentWeather {
                        CurrentWeatherSection(weather: weather)
                            .transition(.asymmetric(
                                insertion: .move(edge: .top).combined(with: .opacity),
                                removal: .opacity
                            ))

                        HourlyForecastSection(forecast: viewModel.hourlyForecast)
                            .transition(.asymmetric(
                                insertion: .move(edge: .leading).combined(with: .opacity),
                                removal: .opacity
                            ))

                        DailyForecastSection(forecast: viewModel.dailyForecast)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .opacity
                            ))
                    } else {
                        WeatherEmptyView {
                            Task {
                                await viewModel.fetchWeather()
                            }
                        }
                    }
                }
                .padding()
            }
            .refreshable {
                await viewModel.refresh()
            }
        }
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: refreshWeather) {
                Image(systemName: "arrow.clockwise")
                    .rotationEffect(.degrees(isRefreshing ? 360 : 0))
                    .animation(
                        isRefreshing
                            ? .linear(duration: 1).repeatForever(autoreverses: false)
                            : .default,
                        value: isRefreshing
                    )
            }
            .disabled(isRefreshing)
        }
    }

    private func refreshWeather() {
        isRefreshing = true
        Task {
            await viewModel.refresh()
            isRefreshing = false
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct CurrentWeatherSection: View {
    let weather: WeatherData
    @State private var isAppeared = false

    var body: some View {
        VStack(spacing: 20) {
            locationHeader
            mainWeatherDisplay
            additionalInfoSection
        }
        .padding(24)
        .background(Color(.systemGray6))
        .cornerRadius(24)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                isAppeared = true
            }
        }
    }

    private var locationHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(weather.location)
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(weather.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if isAppeared {
                Image(systemName: weather.iconName)
                    .font(.system(size: 50))
                    .foregroundColor(.primaryBlue)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }

    private var mainWeatherDisplay: some View {
        HStack(alignment: .bottom, spacing: 16) {
            Text(weather.temperatureString)
                .font(.system(size: 72, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .opacity(isAppeared ? 1 : 0)
                .offset(y: isAppeared ? 0 : 20)

            VStack(alignment: .leading, spacing: 6) {
                Text("体感")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("\(Int(weather.feelsLike))°")
                    .font(.title3)
                    .fontWeight(.medium)
            }
            .padding(.bottom, 10)
            .opacity(isAppeared ? 1 : 0)

            Spacer()
        }
    }

    private var additionalInfoSection: some View {
        HStack(spacing: 0) {
            WeatherDetailItem(
                icon: "wind",
                label: "风速",
                value: weather.windSpeedString,
                delay: 0.0
            )

            Divider()
                .frame(height: 40)

            WeatherDetailItem(
                icon: "humidity",
                label: "湿度",
                value: weather.humidityString,
                delay: 0.1
            )

            Divider()
                .frame(height: 40)

            WeatherDetailItem(
                icon: "thermometer",
                label: "体感",
                value: "\(Int(weather.feelsLike))°",
                delay: 0.2
            )
        }
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
        .cornerRadius(16)
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct WeatherDetailItem: View {
    let icon: String
    let label: String
    let value: String
    let delay: Double

    @State private var isAppeared = false

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.primaryBlue)

            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .opacity(isAppeared ? 1 : 0)
        .offset(y: isAppeared ? 0 : 10)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay)) {
                isAppeared = true
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct HourlyForecastSection: View {
    let forecast: [HourlyWeatherData]
    @State private var isAppeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundColor(.primaryBlue)

                Text("小时预报")
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(forecast.prefix(12).enumerated()), id: \.element.id) { index, item in
                        HourlyWeatherItem(item: item, isNow: index == 0)
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .opacity
                            ))
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                isAppeared = true
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct HourlyWeatherItem: View {
    let item: HourlyWeatherData
    let isNow: Bool

    var body: some View {
        VStack(spacing: 10) {
            Text(isNow ? "现在" : item.hourString)
                .font(.caption)
                .fontWeight(isNow ? .bold : .regular)
                .foregroundColor(isNow ? .primaryBlue : .secondary)

            Image(systemName: item.iconName)
                .font(.title2)
                .foregroundColor(.primaryBlue)

            Text(item.temperatureString)
                .font(.subheadline)
                .fontWeight(.medium)

            if item.precipitationChance > 0 {
                HStack(spacing: 2) {
                    Image(systemName: "drop.fill")
                        .font(.caption2)
                    Text("\(item.precipitationChance)%")
                        .font(.caption2)
                }
                .foregroundColor(.blue)
            }
        }
        .frame(width: 70)
        .padding(.vertical, 12)
        .background(isNow ? Color.primaryBlue.opacity(0.1) : Color(.systemBackground))
        .cornerRadius(12)
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct DailyForecastSection: View {
    let forecast: [DailyWeatherData]
    @State private var isAppeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "calendar")
                    .foregroundColor(.primaryBlue)

                Text("多日预报")
                    .font(.headline)
                    .fontWeight(.semibold)

                Spacer()

                Text("7天")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 8) {
                ForEach(Array(forecast.prefix(7).enumerated()), id: \.element.id) { index, item in
                    DailyForecastRow(item: item, isLast: index == min(forecast.count - 1, 6))
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .opacity
                        ))
                        .animation(
                            .spring(response: 0.4, dampingFraction: 0.8).delay(Double(index) * 0.05),
                            value: isAppeared
                        )
                }
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3)) {
                isAppeared = true
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct DailyForecastRow: View {
    let item: DailyWeatherData
    let isLast: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(item.isToday ? "今天" : item.shortDayString)
                .font(.subheadline)
                .fontWeight(item.isToday ? .semibold : .regular)
                .frame(width: 50, alignment: .leading)

            Image(systemName: item.iconName)
                .font(.title3)
                .foregroundColor(.primaryBlue)
                .frame(width: 30)

            if item.precipitationChance > 0 {
                HStack(spacing: 2) {
                    Image(systemName: "drop.fill")
                        .font(.caption2)
                    Text("\(item.precipitationChance)%")
                        .font(.caption)
                }
                .foregroundColor(.blue)
                .frame(width: 45)
            } else {
                Spacer()
                    .frame(width: 45)
            }

            Spacer()

            Text(item.temperatureRangeString)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 8)
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

#Preview {
    WeatherView()
        .environmentObject(WeatherService())
        .environmentObject(SettingsManager())
}
