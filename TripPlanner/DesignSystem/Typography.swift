//
//  Typography.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 12/12/2025.
//

import UIKit
import SwiftUI

enum FontWeight: String {
    case medium = "Medium"
    case bold = "Bold"
    case black = "Black"
    
    var uiFontWeight: UIFont.Weight {
        switch self {
        case .medium: return .medium
        case .bold: return .bold
        case .black: return .black
        }
    }
}

enum TypographyStyle {
    case b1SemiBold      // 18px, 700, 26px line height
    case b2SemiBold      // 16px, 700, 24px line height
    case b3Medium        // 14px, 500, 22px line height
    case b3SemiBold      // 14px, 700, 22px line height
    case b3Bold          // 14px, 900, 22px line height (letter spacing -4%)
    case b4Medium        // 12px, 500, 20px line height
    
    var fontSize: CGFloat {
        switch self {
        case .b1SemiBold: return 18
        case .b2SemiBold: return 16
        case .b3Medium, .b3SemiBold, .b3Bold: return 14
        case .b4Medium: return 12
        }
    }
    
    var fontWeight: FontWeight {
        switch self {
        case .b1SemiBold, .b2SemiBold: return .bold
        case .b3Medium, .b4Medium: return .medium
        case .b3SemiBold: return .bold
        case .b3Bold: return .black
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .b1SemiBold: return 26
        case .b2SemiBold: return 24
        case .b3Medium, .b3SemiBold, .b3Bold: return 22
        case .b4Medium: return 20
        }
    }
    
    var letterSpacing: CGFloat {
        switch self {
        case .b3Bold: return -0.56 // -4% of 14px
        default: return -0.5
        }
    }
}

extension UIFont {
    static func appFont(style: TypographyStyle) -> UIFont {
        // Try to load Satoshi font, fallback to system font
        let fontName = "Satoshi-\(style.fontWeight.rawValue)"
        if let font = UIFont(name: fontName, size: style.fontSize) {
            return font
        }
        
        // Fallback to system font with appropriate weight
        return UIFont.systemFont(ofSize: style.fontSize, weight: style.fontWeight.uiFontWeight)
    }
}

extension UILabel {
    func applyTypography(_ style: TypographyStyle, color: UIColor = AppColors.primaryText) {
        self.font = .appFont(style: style)
        self.textColor = color
        
        // Set line height using paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = style.lineHeight
        paragraphStyle.maximumLineHeight = style.lineHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .kern: style.letterSpacing
        ]
        
        if let text = self.text {
            self.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
    }
}

// SwiftUI Typography Support
extension Font {
    static func appFont(style: TypographyStyle) -> Font {
        let fontName = "Satoshi-\(style.fontWeight.rawValue)"
        if UIFont(name: fontName, size: style.fontSize) != nil {
            return .custom(fontName, size: style.fontSize)
        }
        
        // Fallback to system font
        switch style.fontWeight {
        case .medium:
            return .system(size: style.fontSize, weight: .medium)
        case .bold:
            return .system(size: style.fontSize, weight: .bold)
        case .black:
            return .system(size: style.fontSize, weight: .black)
        }
    }
}

