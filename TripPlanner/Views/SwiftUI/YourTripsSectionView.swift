//
//  YourTripsSectionView.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 13/12/2025.
//

import SwiftUI

struct YourTripsSectionView: View {
    let trips: [Trip]
    var onTripTap: (Trip) -> Void
    
    @State private var isPlannedTripsExpanded = true
    
    var body: some View {
        VStack(alignment: .leading, spacing: 40) {
            // Header
            VStack(alignment: .leading, spacing: 16) {
                Text("Your Trips")
                    .font(.appFont(style: .b1SemiBold))
                    .foregroundColor(.primaryText)
                
                Text("Your trip itineraries and planned trips are placed here")
                    .font(.appFont(style: .b4Medium))
                    .foregroundColor(.tertiaryText)
            }
            .padding(.horizontal, 20)
            .padding(.top, 40)
            .padding(.bottom, 20)
            
            // Planned Trips collapsible section
            VStack(spacing: 0) {
                // Collapsible header
                Button(action: {
                    withAnimation {
                        isPlannedTripsExpanded.toggle()
                    }
                }) {
                    HStack {
                        Text("Planned Trips")
                            .font(.appFont(style: .b2SemiBold))
                            .foregroundColor(.primaryText)
                        
                        Spacer()
                        
                        Image(systemName: isPlannedTripsExpanded ? "chevron.down" : "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.primaryText)
                    }
                    .padding(20)
                    .background(Color.appWhite)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                
                // Trip cards or empty state
                if isPlannedTripsExpanded {
                    if trips.isEmpty {
                        // Empty state
                        VStack(spacing: 20) {
                            Image(systemName: "airplane.departure")
                                .font(.system(size: 48))
                                .foregroundColor(.tertiaryText)
                            
                            Text("No trips planned yet")
                                .font(.appFont(style: .b2SemiBold))
                                .foregroundColor(.primaryText)
                            
                            Text("Start planning your next adventure!")
                                .font(.appFont(style: .b4Medium))
                                .foregroundColor(.tertiaryText)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 60)
                        .padding(.horizontal, 20)
                    } else {
                        VStack(spacing: 28) {
                            ForEach(trips) { trip in
                                TripCardView(trip: trip) {
                                    onTripTap(trip)
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        .padding(.top, 32)
                        .padding(.bottom, 60)
                    }
                }
            }
            .padding(.bottom, 50)
        }
        .frame(maxWidth: .infinity)
        .background(Color.appWhite)
        .padding(.top, 30)
        .padding(.bottom, 100)
    }
}

#Preview {
    YourTripsSectionView(
        trips: [
            Trip(
                name: "Bahamas Family Trip",
                destination: "Paris",
                startDate: "19th April 2024",
                duration: 5
            ),
            Trip(
                name: "Bahamas Family Trip",
                destination: "Paris",
                startDate: "19th April 2024",
                duration: 5
            )
        ],
        onTripTap: { _ in }
    )
    .background(Color.lightBackground)
}

