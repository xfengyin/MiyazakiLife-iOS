//
//  EmptyStateView.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct EmptyStateView: View {
    let icon: String
    let title: String
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    init(
        icon: String,
        title: String,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: icon)
                .font(.system(size: 70))
                .foregroundColor(.secondary)
                .padding(.bottom, 10)

            Text(title)
                .font(.title2)
                .fontWeight(.semibold)

            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 12)
                        .background(Color.primaryBlue)
                        .cornerRadius(12)
                }
                .padding(.top, 10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct WeatherEmptyView: View {
    let onRefresh: () -> Void

    var body: some View {
        EmptyStateView(
            icon: "cloud.fill",
            title: "暂无天气数据",
            message: "无法获取天气信息，请检查网络连接后重试。",
            actionTitle: "刷新",
            action: onRefresh
        )
    }
}
