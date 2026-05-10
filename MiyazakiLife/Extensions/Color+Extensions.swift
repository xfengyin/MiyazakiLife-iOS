//
//  Color+Extensions.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import SwiftUI

extension Color {
    static let primaryBlue = Color(hex: "007AFF")
    static let secondaryGreen = Color(hex: "34C759")
    static let accentOrange = Color(hex: "FF9500")
    static let backgroundGray = Color(hex: "F2F2F7")
    static let cardBackground = Color(.systemGray6)

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    static func weatherColor(for code: Int) -> Color {
        switch code {
        case 0: return .yellow
        case 1, 2, 3: return .orange
        case 45, 48: return .gray
        case 51, 53, 55, 61, 63, 65, 80, 81, 82: return .blue
        case 71, 73, 75, 77, 85, 86: return .cyan
        case 95, 96, 99: return .purple
        default: return .gray
        }
    }

    static func gradientColors(for code: Int) -> LinearGradient {
        switch code {
        case 0:
            return LinearGradient(
                colors: [Color(hex: "FFD700"), Color(hex: "FFA500")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 1, 2, 3:
            return LinearGradient(
                colors: [Color(hex: "87CEEB"), Color(hex: "4682B4")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 45, 48:
            return LinearGradient(
                colors: [Color.gray, Color.gray.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 51, 53, 55, 61, 63, 65, 80, 81, 82:
            return LinearGradient(
                colors: [Color.blue.opacity(0.7), Color.blue.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 95, 96, 99:
            return LinearGradient(
                colors: [Color.purple, Color.blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                colors: [Color.gray, Color.gray.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}
