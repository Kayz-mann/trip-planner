//
//  AppButton.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 14/12/2025.
//

import SwiftUI

enum AppButtonStyle {
    case primary
    case secondary
    case danger
    case outline
}

struct AppButton: View {
    let title: String
    let style: AppButtonStyle
    var isEnabled: Bool = true
    var isFullWidth: Bool = true
    var verticalPadding: CGFloat = 16
    var action: () -> Void
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return isEnabled ? Color.primaryBlue : Color.primaryBlue.opacity(0.5)
        case .secondary:
            return isEnabled ? Color.gray.opacity(0.2) : Color.gray.opacity(0.1)
        case .danger:
            return isEnabled ? Color.red : Color.red.opacity(0.5)
        case .outline:
            return Color.clear
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary, .danger:
            return .white
        case .secondary:
            return .primaryText
        case .outline:
            return .primaryBlue
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .outline:
            return .primaryBlue
        default:
            return .clear
        }
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appFont(style: .b3SemiBold))
                .foregroundColor(foregroundColor)
                .frame(maxWidth: isFullWidth ? .infinity : nil)
                .padding(.vertical, verticalPadding)
                .background(backgroundColor)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(borderColor, lineWidth: style == .outline ? 1 : 0)
                )
        }
        .disabled(!isEnabled)
    }
}

#Preview {
    VStack(spacing: 16) {
        AppButton(title: "Primary Button", style: .primary, action: {})
        AppButton(title: "Disabled Button", style: .primary, isEnabled: false, action: {})
        AppButton(title: "Secondary Button", style: .secondary, action: {})
        AppButton(title: "Danger Button", style: .danger, action: {})
        AppButton(title: "Outline Button", style: .outline, action: {})
    }
    .padding()
}

