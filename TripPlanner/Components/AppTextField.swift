//
//  AppTextField.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 14/12/2025.
//

import SwiftUI

struct AppTextField: View {
    let title: String?
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization = .sentences
    
    init(
        title: String? = nil,
        placeholder: String,
        text: Binding<String>,
        isSecure: Bool = false,
        keyboardType: UIKeyboardType = .default,
        autocapitalization: TextInputAutocapitalization = .sentences
    ) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.keyboardType = keyboardType
        self.autocapitalization = autocapitalization
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let title = title {
                Text(title)
                    .font(.appFont(style: .b3Medium))
                    .foregroundColor(.primaryText)
            }
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(.appFont(style: .b3Medium))
            .foregroundColor(.primaryText)
            .keyboardType(keyboardType)
            .textInputAutocapitalization(autocapitalization)
            .padding(16)
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
    VStack(spacing: 20) {
        AppTextField(
            title: "Trip Name",
            placeholder: "Enter the trip name",
            text: .constant("")
        )
        
        AppTextField(
            title: "Email",
            placeholder: "Enter your email",
            text: .constant(""),
            keyboardType: .emailAddress
        )
        
        AppTextField(
            placeholder: "No title field",
            text: .constant("")
        )
    }
    .padding()
}

