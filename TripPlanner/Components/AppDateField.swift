//
//  AppDateField.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 14/12/2025.
//

import SwiftUI

struct AppDateField: View {
    let title: String
    let date: Date?
    let onTap: () -> Void
    var dateFormat: String = "MMM d, yyyy"
    
    private var displayText: String {
        guard let date = date else {
            return "Enter Date"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "calendar")
                        .font(.system(size: 14))
                        .foregroundColor(.tertiaryText)
                    
                    Text(title)
                        .font(.appFont(style: .b4Medium))
                        .foregroundColor(.secondaryText)
                }
                
                Text(displayText)
                    .font(.appFont(style: .b4Medium))
                    .foregroundColor(date == nil ? .tertiaryText : .primaryText)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color.cardBackground)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 16) {
        AppDateField(
            title: "Start Date",
            date: Date(),
            onTap: {}
        )
        
        AppDateField(
            title: "End Date",
            date: nil,
            onTap: {}
        )
    }
    .padding()
}

