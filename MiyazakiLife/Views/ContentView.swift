//
//  ContentView.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct ContentView: View {
    @EnvironmentObject var weatherService: WeatherService
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var selectedTab = 0
    @State private var tabBarHeight: CGFloat = 49

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                    Text("首页")
                }
                .tag(0)

            WeatherView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "cloud.sun.fill" : "cloud.sun")
                    Text("天气")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "gearshape.fill" : "gearshape")
                    Text("设置")
                }
                .tag(2)
        }
        .accentColor(.primaryBlue)
        .onAppear {
            setupTabBarAppearance()
        }
    }

    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct AnimatedTabBar: View {
    @Binding var selectedTab: Int
    let tabs: [(icon: String, title: String, index: Int)]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.index) { tab in
                TabBarItem(
                    icon: tab.icon,
                    title: tab.title,
                    isSelected: selectedTab == tab.index
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        selectedTab = tab.index
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? .primaryBlue : .secondary)

            Text(title)
                .font(.caption2)
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .primaryBlue : .secondary)
        }
        .frame(minWidth: 60)
        .padding(.vertical, 8)
        .background(isSelected ? Color.primaryBlue.opacity(0.1) : Color.clear)
        .cornerRadius(12)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

#Preview {
    ContentView()
        .environmentObject(WeatherService())
        .environmentObject(SettingsManager())
}
