//
//  PlanTripActionCardView.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 13/12/2025.
//

import SwiftUI

struct PlanTripActionCardView: View {
    @Binding var selectedCity: String
    @Binding var startDate: Date?
    @Binding var endDate: Date?
    var onCityTap: () -> Void
    var onStartDateTap: () -> Void
    var onEndDateTap: () -> Void
    var onCreateTrip: () -> Void
    var onDismiss: () -> Void
    
    
    var body: some View {
        VStack(spacing: 20) {
            // Plant/Travel icon
//            HStack {
//                ZStack {
//                    Circle()
//                        .fill(Color.primaryBlue.opacity(0.1))
//                        .frame(width: 48, height: 48)
//
//                    Image(systemName: "airplane")
//                        .font(.system(size: 20))
//                        .foregroundColor(.primaryBlue)
//                }
//
//                Spacer()
//
//                Button(action: {
//                    onDismiss()                }) {
//                    Image(systemName: "xmark")
//                        .font(.system(size: 16))
//                        .foregroundColor(.primaryText)
//                }
//            }

//            VStack(alignment: .leading, spacing: 8) {
//                Text("Create a Trip")
//                    .font(.appFont(style: .b3SemiBold))
//                    .foregroundColor(.primaryText)
//
//                Text("Let's Go! Build Your Next Adventure")
//                    .font(.appFont(style: .b4Medium))
//                    .foregroundColor(.secondaryText)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//
//            Divider()

            // Where to? Selection
            Button(action: {
                onCityTap()
            }) {
                HStack {
                    Image(systemName: "mappin.circle")
                        .font(.system(size: 18))
                        .foregroundColor(.tertiaryText)

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Where to ?")
                            .font(.appFont(style: .b4Medium))
                            .foregroundColor(.secondaryText)

                        Text(selectedCity.isEmpty ? "Select  City" : selectedCity)
                            .font(.appFont(style: .b3Bold))
                            .foregroundColor(selectedCity.isEmpty ? .tertiaryText : .primaryText)
                    }

                    Spacer()
                }
                .padding(18)
                .background(Color.cardBackground)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
            }

            // Date Selection
            HStack(spacing: 10) {
                // Start Date
                AppDateField(
                    title: "Start Date",
                    date: startDate,
                    onTap: onStartDateTap
                )
                
                // End Date
                AppDateField(
                    title: "End Date",
                    date: endDate,
                    onTap: onEndDateTap
                )
            }

            // Create a Trip Button
            AppButton(
                title: "Create a Trip",
                style: .primary,
                verticalPadding: 18,
                action: onCreateTrip
            )
        }
        .padding(24)
        .background(Color.appWhite)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)

    }
}



#Preview {
    PlanTripActionCardView(
        selectedCity: .constant("Paris"),
        startDate: .constant(nil),
        endDate: .constant(nil),
        onCityTap: { print("City tapped") },
        onStartDateTap: { print("Start date tapped") },
        onEndDateTap: { print("End date tapped") },
        onCreateTrip: { print("Create trip") },
        onDismiss: { print("Dismiss") }
    )
}
