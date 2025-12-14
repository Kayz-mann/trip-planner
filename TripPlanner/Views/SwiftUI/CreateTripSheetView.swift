//
//  CreateTripSheetView.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 13/12/2025.
//

import SwiftUI

struct CreateTripSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    // Payload from PlanTripActionCardView
    let selectedCity: String
    let startDate: Date?
    let endDate: Date?
    
    // Callback when trip is created
    var onTripCreated: (String, String, String) -> Void
    
    // Form fields
    @State private var tripName: String = ""
    @State private var travelStyle: String = ""
    @State private var tripDescription: String = ""
    @State private var showTravelStylePicker: Bool = false
    @State private var showValidationAlert: Bool = false
    @State private var validationMessage: String = ""
    
    let travelStyles = ["Solo", "Couple", "Family", "Group"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // White background
                Color.appWhite
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header - white rounded card with background pattern
                    ZStack {
                        // Background pattern image (subtle grid pattern)
                        Image("plan-a-trip")
                            .resizable()
//                            .scaledToFill()
                            .opacity(1.08)
                            .clipped()
                            .padding(.bottom, 10)
                        
                        // Header content
                        VStack(spacing: 12) {
                            // Top row with icon and close button
                            HStack {
                                // Plant icon on left
                                Image("plant-image")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48, height: 48)
                                
                                Spacer()
                                
                                // Close button on right
                                Button(action: {
                                    dismiss()
                                }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.primaryText)
                                }
                            }
                            
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 26)
                        .padding(.bottom, 20)
                    }
                    .frame(height: 140)
                    .background(Color.appWhite)
                    .cornerRadius(16, corners: [.bottomLeft, .bottomRight])
                    
                    // Title and subtitle centered
                    VStack(spacing: 4) {
                        Text("Create a Trip")
                            .font(.appFont(style: .b2SemiBold))
                            .foregroundColor(.primaryText)
                        
                        Text("Let's Go! Build Your Next Adventure")
                            .font(.appFont(style: .b4Medium))
                            .foregroundColor(.secondaryText)
                    }

                    
                    // Form content
                    VStack(alignment: .leading, spacing: 20) {
                        

                        
                        // Trip Name field
                        AppTextField(
                            title: "Trip Name",
                            placeholder: "Enter the trip name",
                            text: $tripName
                        )
                        
                        // Travel Style field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Travel Style")
                                .font(.appFont(style: .b3Medium))
                                .foregroundColor(.primaryText)
                            
                            Button(action: {
                                withAnimation {
                                    showTravelStylePicker.toggle()
                                }
                            }) {
                                HStack {
                                    Text(travelStyle.isEmpty ? "Select your travel style" : travelStyle)
                                        .font(.appFont(style: .b3Medium))
                                        .foregroundColor(travelStyle.isEmpty ? .tertiaryText : .primaryText)
                                    
                                    Spacer()
                                    
                                    Image(systemName: showTravelStylePicker ? "chevron.up" : "chevron.down")
                                        .font(.system(size: 14))
                                        .foregroundColor(.tertiaryText)
                                }
                                .padding(16)
                                .background(Color.appWhite)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                            
                            // Travel style options
                            if showTravelStylePicker {
                                VStack(spacing: 0) {
                                    ForEach(travelStyles, id: \.self) { style in
                                        Button(action: {
                                            withAnimation {
                                                travelStyle = style
                                                showTravelStylePicker = false
                                            }
                                        }) {
                                            HStack {
                                                Text(style)
                                                    .font(.appFont(style: .b3Medium))
                                                    .foregroundColor(.primaryText)
                                                
                                                Spacer()
                                                
                                                if travelStyle == style {
                                                    Image(systemName: "checkmark")
                                                        .font(.system(size: 14, weight: .semibold))
                                                        .foregroundColor(.primaryBlue)
                                                }
                                            }
                                            .padding(16)
                                            .background(travelStyle == style ? Color.primaryBlue.opacity(0.1) : Color.appWhite)
                                        }
                                        
                                        if style != travelStyles.last {
                                            Divider()
                                                .padding(.leading, 16)
                                        }
                                    }
                                }
                                .background(Color.appWhite)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            }
                        }
                        
                        // Trip Description field
                        AppTextEditor(
                            title: "Trip Description",
                            placeholder: "Enter trip description",
                            text: $tripDescription
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    
                    Spacer()
                    
                    // Next button
                    VStack {
                        AppButton(
                            title: "Next",
                            style: .primary,
                            isEnabled: isFormValid,
                            action: {
                                validateAndProceed()
                            }
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
        }
        .alert("Validation Error", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(validationMessage)
        }
    }
    
    private var isFormValid: Bool {
        !tripName.trimmingCharacters(in: .whitespaces).isEmpty && !travelStyle.isEmpty
    }
    
    private func validateAndProceed() {
        if tripName.trimmingCharacters(in: .whitespaces).isEmpty {
            validationMessage = "Please enter a trip name"
            showValidationAlert = true
            return
        }
        
        if travelStyle.isEmpty {
            validationMessage = "Please select a travel style"
            showValidationAlert = true
            return
        }
        
        // All validations passed - create trip
        onTripCreated(tripName, travelStyle, tripDescription)
        dismiss()
    }
}

#Preview {
    CreateTripSheetView(
        selectedCity: "Paris, France",
        startDate: Date(),
        endDate: Date().addingTimeInterval(86400 * 7),
        onTripCreated: { _, _, _ in }
    )
}

