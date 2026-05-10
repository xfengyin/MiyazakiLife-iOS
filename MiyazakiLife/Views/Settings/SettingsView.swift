//
//  SettingsView.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @StateObject private var viewModel = SettingsViewModel()
    @State private var showingClearCacheAlert = false
    @State private var showingResetAlert = false

    var body: some View {
        NavigationView {
            List {
                appearanceSection
                notificationSection
                locationSection
                aboutSection
                developerSection
            }
            .navigationTitle("设置")
            .onAppear {
                viewModel.loadSettings()
            }
            .alert("清除缓存", isPresented: $showingClearCacheAlert) {
                Button("取消", role: .cancel) { }
                Button("清除", role: .destructive) {
                    viewModel.clearCache()
                }
            } message: {
                Text("确定要清除所有缓存数据吗？这不会影响您的设置。")
            }
            .alert("重置设置", isPresented: $showingResetAlert) {
                Button("取消", role: .cancel) { }
                Button("重置", role: .destructive) {
                    viewModel.resetToDefaults()
                }
            } message: {
                Text("确定要将所有设置重置为默认值吗？")
            }
        }
    }

    private var appearanceSection: some View {
        Section(header: sectionHeader("外观")) {
            Picker("主题", selection: $viewModel.theme) {
                ForEach(Theme.allCases, id: \.self) { theme in
                    Text(theme.displayName).tag(theme)
                }
            }
            .onChange(of: viewModel.theme) { _ in
                viewModel.saveSettings()
            }

            Picker("温度单位", selection: $viewModel.temperatureUnit) {
                Text("摄氏度 (°C)").tag(TemperatureUnit.celsius)
                Text("华氏度 (°F)").tag(TemperatureUnit.fahrenheit)
            }
            .onChange(of: viewModel.temperatureUnit) { _ in
                viewModel.saveSettings()
            }
        }
    }

    private var notificationSection: some View {
        Section(header: sectionHeader("通知")) {
            Toggle(isOn: $viewModel.weatherAlertsEnabled) {
                HStack {
                    Image(systemName: "bell.badge.fill")
                        .foregroundColor(.accentOrange)
                    Text("天气预警")
                }
            }
            .onChange(of: viewModel.weatherAlertsEnabled) { _ in
                viewModel.saveSettings()
            }

            Toggle(isOn: $viewModel.dailyReminderEnabled) {
                HStack {
                    Image(systemName: "alarm.fill")
                        .foregroundColor(.primaryBlue)
                    Text("每日提醒")
                }
            }
            .onChange(of: viewModel.dailyReminderEnabled) { _ in
                viewModel.saveSettings()
            }

            if viewModel.dailyReminderEnabled {
                DatePicker(
                    "提醒时间",
                    selection: $viewModel.reminderTime,
                    displayedComponents: .hourAndMinute
                )
                .onChange(of: viewModel.reminderTime) { _ in
                    viewModel.saveSettings()
                }
            }
        }
    }

    private var locationSection: some View {
        Section(header: sectionHeader("位置服务")) {
            Button(action: {
                viewModel.showingLocationAlert = true
            }) {
                HStack {
                    Image(systemName: "location.fill")
                        .foregroundColor(.secondaryGreen)
                    Text("定位服务")
                    Spacer()
                    Text(viewModel.locationStatusText)
                        .foregroundColor(.secondary)
                }
            }
            .foregroundColor(.primary)
            .alert("定位服务", isPresented: $viewModel.showingLocationAlert) {
                Button("取消", role: .cancel) { }
                Button("前往设置") {
                    viewModel.openLocationSettings()
                }
            } message: {
                Text("需要在系统设置中启用定位服务以获取当地天气信息。")
            }
        }
    }

    private var aboutSection: some View {
        Section(header: sectionHeader("关于")) {
            HStack {
                Text("版本")
                Spacer()
                Text(viewModel.appVersion)
                    .foregroundColor(.secondary)
            }

            HStack {
                Text("构建")
                Spacer()
                Text(viewModel.buildNumber)
                    .foregroundColor(.secondary)
            }

            Link(destination: URL(string: "https://example.com/privacy")!) {
                HStack {
                    Image(systemName: "lock.shield.fill")
                        .foregroundColor(.primaryBlue)
                    Text("隐私政策")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .foregroundColor(.primary)

            Link(destination: URL(string: "https://example.com/terms")!) {
                HStack {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(.primaryBlue)
                    Text("用户协议")
                    Spacer()
                    Image(systemName: "arrow.up.right")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .foregroundColor(.primary)
        }
    }

    private var developerSection: some View {
        Section(header: sectionHeader("开发者")) {
            Button(action: {
                showingClearCacheAlert = true
            }) {
                HStack {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.accentOrange)
                    Text("清除缓存")
                    Spacer()
                    Text(viewModel.cacheSize)
                        .foregroundColor(.secondary)
                }
            }
            .foregroundColor(.primary)

            Button(action: {
                showingResetAlert = true
            }) {
                HStack {
                    Image(systemName: "arrow.counterclockwise")
                        .foregroundColor(.red)
                    Text("重置设置")
                }
            }
            .foregroundColor(.red)
        }
    }

    private func sectionHeader(_ title: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: iconForSection(title))
                .font(.caption)
            Text(title)
        }
    }

    private func iconForSection(_ title: String) -> String {
        switch title {
        case "外观": return "paintbrush.fill"
        case "通知": return "bell.fill"
        case "位置服务": return "location.fill"
        case "关于": return "info.circle.fill"
        case "开发者": return "hammer.fill"
        default: return "gear"
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsManager())
}
