//
//  AppCard.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 14/12/2025.
//

import SwiftUI

struct AppCard<Content: View>: View {
    let content: Content
    var padding: CGFloat = 20
    var cornerRadius: CGFloat = 12
    var shadowRadius: CGFloat = 8
    var shadowOpacity: Double = 0.08
    
    init(
        padding: CGFloat = 20,
        cornerRadius: CGFloat = 12,
        shadowRadius: CGFloat = 8,
        shadowOpacity: Double = 0.08,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowOpacity = shadowOpacity
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(padding)
            .background(Color.appWhite)
            .cornerRadius(cornerRadius)
            .shadow(
                color: Color.black.opacity(shadowOpacity),
                radius: shadowRadius,
                x: 0,
                y: 2
            )
    }
}

#Preview {
    AppCard {
        VStack(alignment: .leading, spacing: 12) {
            Text("Card Title")
                .font(.appFont(style: .b2SemiBold))
            
            Text("Card content goes here")
                .font(.appFont(style: .b3Medium))
                .foregroundColor(.secondaryText)
        }
    }
    .padding()
}

