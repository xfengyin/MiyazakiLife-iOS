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
    @State private var greeting: String = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 问候区域
                    Text(greeting)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    // 快捷功能卡片
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        FeatureCard(
                            title: "天气",
                            icon: "cloud.sun",
                            color: .blue
                        )
                        
                        FeatureCard(
                            title: "日程",
                            icon: "calendar",
                            color: .green
                        )
                        
                        FeatureCard(
                            title: "笔记",
                            icon: "note.text",
                            color: .orange
                        )
                        
                        FeatureCard(
                            title: "更多",
                            icon: "ellipsis",
                            color: .purple
                        )
                    }
                    
                    // 每日提示
                    DailyTipCard()
                }
                .padding()
            }
            .navigationTitle("宫崎生活")
            .onAppear {
                updateGreeting()
            }
        }
    }
    
    private func updateGreeting() {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:
            greeting = "早上好，宫崎！☀️"
        case 12..<18:
            greeting = "下午好，宫崎！🌤️"
        case 18..<22:
            greeting = "晚上好，宫崎！🌙"
        default:
            greeting = "夜深了，宫崎！⭐"
        }
    }
}

// MARK: - 功能卡片
struct FeatureCard: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 30))
                .foregroundColor(color)
                .padding()
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

// MARK: - 每日提示卡片
struct DailyTipCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "lightbulb.fill")
                    .foregroundColor(.yellow)
                Text("每日提示")
                    .font(.headline)
            }
            
            Text("今天宫崎的天气不错，适合出门走走！记得带上雨伞以防万一。☔")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    HomeView()
        .environmentObject(WeatherService())
        .environmentObject(SettingsManager())
}
