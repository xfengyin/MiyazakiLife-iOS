//
//  Color+Extensions.swift
//  MiyazakiLife
//
//  Created by Dev-Coder on 2026-03-11.
//

import SwiftUI

extension Color {
    // MARK: - Primary Brand Colors
    static let primaryBlue = Color(light: Color(hex: "007AFF"), dark: Color(hex: "0A84FF"))
    static let secondaryGreen = Color(light: Color(hex: "34C759"), dark: Color(hex: "30D158"))
    static let accentOrange = Color(light: Color(hex: "FF9500"), dark: Color(hex: "FF9F0A"))
    
    // MARK: - Background Colors
    static let appBackground = Color(light: .white, dark: Color(hex: "000000"))
    static let backgroundGray = Color(light: Color(hex: "F2F2F7"), dark: Color(hex: "1C1C1E"))
    static let cardBackground = Color(light: Color(hex: "F2F2F7"), dark: Color(hex: "2C2C2E"))
    static let secondaryBackground = Color(light: Color(hex: "E5E5EA"), dark: Color(hex: "1C1C1E"))
    
    // MARK: - Text Colors
    static let primaryText = Color(light: .black, dark: .white)
    static let secondaryText = Color(light: Color(hex: "8E8E93"), dark: Color(hex: "98989D"))
    static let tertiaryText = Color(light: Color(hex: "C7C7CC"), dark: Color(hex: "636366"))
    
    // MARK: - Functional Colors
    static let success = Color(light: Color(hex: "34C759"), dark: Color(hex: "30D158"))
    static let warning = Color(light: Color(hex: "FF9500"), dark: Color(hex: "FF9F0A"))
    static let error = Color(light: Color(hex: "FF3B30"), dark: Color(hex: "FF453A"))
    
    // MARK: - Semantic Initializer
    init(light: Color, dark: Color) {
        self.init(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark ? UIColor(dark) : UIColor(light)
        })
    }

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
        case 0: return Color(light: .yellow, dark: .yellow.opacity(0.9))
        case 1, 2, 3: return Color(light: .orange, dark: .orange.opacity(0.9))
        case 45, 48: return Color(light: .gray, dark: Color(hex: "636366"))
        case 51, 53, 55, 61, 63, 65, 80, 81, 82: return Color(light: .blue, dark: Color(hex: "64D2FF"))
        case 71, 73, 75, 77, 85, 86: return Color(light: .cyan, dark: .cyan.opacity(0.9))
        case 95, 96, 99: return Color(light: .purple, dark: .purple.opacity(0.9))
        default: return Color(light: .gray, dark: Color(hex: "636366"))
        }
    }

    static func gradientColors(for code: Int) -> LinearGradient {
        switch code {
        case 0:
            return LinearGradient(
                colors: [
                    Color(light: Color(hex: "FFD700"), dark: Color(hex: "FFB700")), 
                    Color(light: Color(hex: "FFA500"), dark: Color(hex: "FF8C00"))
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 1, 2, 3:
            return LinearGradient(
                colors: [
                    Color(light: Color(hex: "87CEEB"), dark: Color(hex: "4A90D9")), 
                    Color(light: Color(hex: "4682B4"), dark: Color(hex: "2E5A8C"))
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 45, 48:
            return LinearGradient(
                colors: [
                    Color(light: .gray.opacity(0.8), dark: Color(hex: "636366")), 
                    Color(light: .gray.opacity(0.5), dark: Color(hex: "48484A"))
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 51, 53, 55, 61, 63, 65, 80, 81, 82:
            return LinearGradient(
                colors: [
                    Color(light: .blue.opacity(0.7), dark: Color(hex: "007AFF").opacity(0.6)), 
                    Color(light: .blue.opacity(0.4), dark: Color(hex: "007AFF").opacity(0.3))
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case 95, 96, 99:
            return LinearGradient(
                colors: [
                    Color(light: .purple, dark: Color(hex: "BF5AF2")), 
                    Color(light: .blue, dark: Color(hex: "0A84FF"))
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return LinearGradient(
                colors: [
                    Color(light: .gray.opacity(0.8), dark: Color(hex: "636366")), 
                    Color(light: .gray.opacity(0.5), dark: Color(hex: "48484A"))
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
}

// MARK: - UIColor Extension
extension UIColor {
    convenience init(_ color: Color) {
        let components = color.cgColor?.components ?? [0, 0, 0, 1]
        self.init(red: components[0], green: components[1], blue: components[2], alpha: components.count > 3 ? components[3] : 1)
    }
}
