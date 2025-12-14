//
//  Colors.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 12/12/2025.
//

import UIKit
import SwiftUI

struct AppColors {
    // Primary Colors
    static let primaryBlue = UIColor(hex: "#0D6EFD")
    static let primaryBlueBorder = UIColor(hex: "#0D6EFD")
    
    // Background Colors
    static let removeBackground = UIColor(hex: "#FBEAE9")
    static let white = UIColor(hex: "#FFFFFF")
    static let lightBackground = UIColor(hex: "#EDF7F9")
    static let cardBackground = UIColor(hex: "#F9FAFB")
    
    // Card Backgrounds
    static let hotelsCardBackground = UIColor(hex: "#344054")
    static let activitiesCardBackground = UIColor(hex: "#0054E4")
    static let activitiesCardDarkBackground = UIColor(hex: "#000031")
    
    // Text Colors
    static let primaryText = UIColor(hex: "#1D2433")
    static let secondaryText = UIColor(hex: "#647995")
    static let tertiaryText = UIColor(hex: "#676E7E")
    
    // System Colors
    static let systemBackground = UIColor.systemBackground
    static let separator = UIColor.separator
}

extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            red: CGFloat(r) / 255,
            green: CGFloat(g) / 255,
            blue: CGFloat(b) / 255,
            alpha: CGFloat(a) / 255
        )
    }
}

// MARK: - SwiftUI Color Extensions
extension Color {
    // Primary Colors
    static let primaryBlue = Color(hex: "#0D6EFD")
    static let primaryBlueBorder = Color(hex: "#0D6EFD")

    // Background Colors
    static let removeBackground = Color(hex: "#FBEAE9")
    static let appWhite = Color(hex: "#FFFFFF")
    static let lightBackground = Color(hex: "#EDF7F9")
    static let cardBackground = Color(hex: "#F9FAFB")

    // Card Backgrounds
    static let hotelsCardBackground = Color(hex: "#344054")
    static let activitiesCardBackground = Color(hex: "#0054E4")
    static let activitiesCardDarkBackground = Color(hex: "#000031")

    // Text Colors
    static let primaryText = Color(hex: "#1D2433")
    static let secondaryText = Color(hex: "#647995")
    static let tertiaryText = Color(hex: "#676E7E")

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
            (a, r, g, b) = (255, 0, 0, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

