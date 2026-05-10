//
//  LoadingView.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct LoadingView: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 24) {
            ZStack {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.primaryBlue.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(
                            .easeInOut(duration: 1.0)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.2),
                            value: isAnimating
                        )
                }

                Image(systemName: "cloud.sun.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.primaryBlue)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                    .animation(
                        .linear(duration: 3.0)
                        .repeatForever(autoreverses: false),
                        value: isAnimating
                    )
            }
            .frame(height: 100)

            VStack(spacing: 8) {
                Text("正在加载天气数据")
                    .font(.headline)
                    .foregroundColor(.primary)

                Text("请稍候...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .onAppear {
            isAnimating = true
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct LoadingOverlay: View {
    let message: String

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                ProgressView()
                    .scaleEffect(1.5)
                    .tint(.white)

                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            .padding(32)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
        }
    }
}
