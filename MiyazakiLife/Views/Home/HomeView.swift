//
//  HomeView.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct HomeView: View {
    @EnvironmentObject var weatherService: WeatherService
    @StateObject private var viewModel = HomeViewModel()
    @State private var isAppeared = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    GreetingHeader(greeting: viewModel.greeting, weather: viewModel.currentWeather)
                        .fadeInAnimation(delay: 0)

                    if let weather = viewModel.currentWeather {
                        WeatherSummaryCard(weather: weather)
                            .slideInAnimation(from: .trailing, delay: 0.1)
                    }

                    FeatureGrid(features: viewModel.features)
                        .fadeInAnimation(delay: 0.2)

                    DailyTipCard(tip: viewModel.dailyTip)
                        .slideInAnimation(from: .bottom, delay: 0.3)
                }
                .padding()
            }
            .refreshable {
                await viewModel.refresh()
                await weatherService.refreshWeather()
            }
            .navigationTitle("宫崎生活")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Image(systemName: "bell.badge")
                        .foregroundColor(.primaryBlue)
                }
            }
            .onAppear {
                viewModel.loadData()
                withAnimation {
                    isAppeared = true
                }
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct GreetingHeader: View {
    let greeting: String
    let weather: WeatherData?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(greeting)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundColor(.primary)

            if let weather = weather {
                HStack(spacing: 8) {
                    Image(systemName: weather.iconName)
                        .font(.title2)
                        .foregroundColor(.primaryBlue)

                    Text(weather.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text("•")
                        .foregroundColor(.secondary)

                    Text(weather.temperatureString)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct WeatherSummaryCard: View {
    let weather: WeatherData
    @State private var isPressed = false

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text(weather.location)
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text(weather.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: weather.iconName)
                    .font(.system(size: 50))
                    .foregroundColor(.primaryBlue)
            }

            HStack(alignment: .bottom) {
                Text(weather.temperatureString)
                    .font(.system(size: 56, weight: .bold, design: .rounded))

                VStack(alignment: .leading, spacing: 4) {
                    Text("体感 \(Int(weather.feelsLike))°")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text("湿度 \(weather.humidity)%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 8)

                Spacer()
            }

            HStack(spacing: 20) {
                WeatherSummaryItem(icon: "wind", label: "风速", value: weather.windSpeedString)
                WeatherSummaryItem(icon: "humidity", label: "湿度", value: weather.humidityString)
                WeatherSummaryItem(icon: "thermometer", label: "体感", value: "\(Int(weather.feelsLike))°")
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .pressableStyle(isPressed: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct WeatherSummaryItem: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.primaryBlue)

            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)

            Text(value)
                .font(.caption)
                .fontWeight(.medium)
        }
        .frame(maxWidth: .infinity)
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct FeatureGrid: View {
    let features: [Feature]
    @State private var pressedFeatureId: UUID?

    var body: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 15),
                GridItem(.flexible(), spacing: 15)
            ],
            spacing: 15
        ) {
            ForEach(Array(features.enumerated()), id: \.element.id) { index, feature in
                FeatureCard(feature: feature, isPressed: pressedFeatureId == feature.id)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            pressedFeatureId = feature.id
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                pressedFeatureId = nil
                            }
                        }
                    }
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .scale.combined(with: .opacity)
                    ))
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct FeatureCard: View {
    let feature: Feature
    let isPressed: Bool

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(feature.color.opacity(0.15))
                    .frame(width: 60, height: 60)

                Image(systemName: feature.icon)
                    .font(.system(size: 28))
                    .foregroundColor(feature.color)
            }

            Text(feature.title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .scaleEffect(isPressed ? 0.95 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct DailyTipCard: View {
    let tip: DailyTip
    @State private var isVisible = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                    .font(.title3)

                Text(tip.title)
                    .font(.headline)
                    .fontWeight(.semibold)
            }

            Text(tip.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(4)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(16)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 20)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2)) {
                isVisible = true
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(WeatherService())
        .environmentObject(SettingsManager())
}
