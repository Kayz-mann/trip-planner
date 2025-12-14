//
//  AppTextEditor.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 14/12/2025.
//

import SwiftUI

struct AppTextEditor: View {
    let title: String?
    let placeholder: String
    @Binding var text: String
    var height: CGFloat = 120
    
    init(
        title: String? = nil,
        placeholder: String,
        text: Binding<String>,
        height: CGFloat = 120
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.height = height
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = title {
                Text(title)
                    .font(.appFont(style: .b3Medium))
                    .foregroundColor(.primaryText)
            }
            
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .font(.appFont(style: .b3Medium))
                        .foregroundColor(.tertiaryText)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 8)
                }
                
                TextEditor(text: $text)
                    .font(.appFont(style: .b3Medium))
                    .foregroundColor(.primaryText)
                    .frame(height: height)
                    .padding(4)
            }
            .padding(12)
            .background(Color.appWhite)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
}

#Preview {
    AppTextEditor(
        title: "Trip Description",
        placeholder: "Enter trip description",
        text: .constant("")
    )
    .padding()
}

