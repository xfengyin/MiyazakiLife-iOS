//
//  SettingsView.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showingLocationAlert = false
    
    var body: some View {
        NavigationView {
            List {
                // 外观设置
                Section(header: Text("外观")) {
                    Picker("主题", selection: $settingsManager.theme) {
                        Text("浅色").tag(Theme.light)
                        Text("深色").tag(Theme.dark)
                        Text("自动").tag(Theme.system)
                    }
                    
                    Picker("温度单位", selection: $settingsManager.temperatureUnit) {
                        Text("摄氏度").tag(TemperatureUnit.celsius)
                        Text("华氏度").tag(TemperatureUnit.fahrenheit)
                    }
                }
                
                // 通知设置
                Section(header: Text("通知")) {
                    Toggle("天气预警", isOn: $settingsManager.weatherAlertsEnabled)
                    
                    Toggle("每日提醒", isOn: $settingsManager.dailyReminderEnabled)
                    
                    if settingsManager.dailyReminderEnabled {
                        DatePicker(
                            "提醒时间",
                            selection: $settingsManager.reminderTime,
                            displayedComponents: .hourAndMinute
                        )
                    }
                }
                
                // 位置服务
                Section(header: Text("位置服务")) {
                    HStack {
                        Text("定位服务")
                        Spacer()
                        Text(settingsManager.locationEnabled ? "已启用" : "已禁用")
                            .foregroundColor(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        showingLocationAlert = true
                    }
                }
                
                // 关于
                Section(header: Text("关于")) {
                    HStack {
                        Text("版本")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Text("构建")
                        Spacer()
                        Text("2026.03.11")
                            .foregroundColor(.secondary)
                    }
                    
                    Link("隐私政策", destination: URL(string: "https://example.com/privacy")!)
                    
                    Link("用户协议", destination: URL(string: "https://example.com/terms")!)
                }
                
                // 开发者
                Section(header: Text("开发者")) {
                    Button("清除缓存") {
                        clearCache()
                    }
                    
                    Button("重置设置") {
                        resetSettings()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("设置")
            .alert("定位服务", isPresented: $showingLocationAlert) {
                Button("取消", role: .cancel) { }
                Button("前往设置") {
                    openLocationSettings()
                }
            } message: {
                Text("需要在系统设置中启用定位服务以获取当地天气信息。")
            }
        }
    }
    
    private func clearCache() {
        // 清除缓存逻辑
        print("清除缓存")
    }
    
    private func resetSettings() {
        settingsManager.resetToDefaults()
    }
    
    private func openLocationSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsManager())
}
