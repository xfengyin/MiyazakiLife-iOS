//
//  ErrorView.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, *)
struct ErrorView: View {
    let error: AppError
    let onRetry: () -> Void
    @State private var isVisible = false

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: error.iconName)
                .font(.system(size: 60))
                .foregroundColor(.accentOrange)
                .scaleEffect(isVisible ? 1.0 : 0.5)
                .opacity(isVisible ? 1.0 : 0)

            VStack(spacing: 8) {
                Text("出错了")
                    .font(.title2)
                    .fontWeight(.semibold)

                Text(error.localizedDescription)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)

                if let suggestion = error.recoverySuggestion {
                    Text(suggestion)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                }
            }

            Button(action: onRetry) {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("重试")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 12)
                .background(Color.primaryBlue)
                .cornerRadius(12)
            }
            .scaleEffect(isVisible ? 1.0 : 0.8)
            .opacity(isVisible ? 1.0 : 0)
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                isVisible = true
            }
        }
    }
}

@available(iOS 17.0, macOS 14.0, *)
struct ErrorBanner: View {
    let message: String
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.accentOrange)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.primary)

            Spacer()

            Button(action: onDismiss) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
