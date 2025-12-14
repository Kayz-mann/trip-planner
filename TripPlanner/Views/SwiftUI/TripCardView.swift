//
//  TripCardView.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 13/12/2025.
//

import SwiftUI

struct TripCardView: View {
    let trip: Trip
    var onViewTap: () -> Void
    
    // For now, using local asset. Can be extended to use trip.imageUrl if added to model
    private var imageUrl: URL? {
        // If Trip model has imageUrl, use it here
        // return trip.imageUrl.flatMap { URL(string: $0) }
        return nil // Using local asset for now
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Image with city overlay
            ZStack(alignment: .topTrailing) {
                if let url = imageUrl {
                    // Use cached async image for remote URLs
                    CachedAsyncImage(url: url, contentMode: .fill) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()
                    } placeholder: {
                        Image("family-trip")
                            .resizable()
                            .scaledToFill()
                            .frame(height: 250)
                            .clipped()
                    }
                } else {
                    // Use local asset
                    Image("family-trip")
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .clipped()
                }
                
                // City overlay
                Text(trip.destination)
                    .font(.appFont(style: .b3SemiBold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.black.opacity(0.25))
                    .cornerRadius(8)
                    .padding(12)
            }
            
            // Trip details
            VStack(alignment: .leading, spacing: 18) {
                // Trip name
                Text(trip.name)
                    .font(.appFont(style: .b2SemiBold))
                    .foregroundColor(.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Date and duration
                HStack {
                    if let startDate = trip.startDate {
                        Text(startDate)
                            .font(.appFont(style: .b3Medium))
                            .foregroundColor(.primaryText)
                    }
                    
                    Spacer()
                    
                    if let duration = trip.duration {
                        Text("\(duration) Days")
                            .font(.appFont(style: .b3Medium))
                            .foregroundColor(.primaryText)
                    }
                }
                
                // View button
                AppButton(
                    title: "View",
                    style: .primary,
                    action: onViewTap
                )
            }
            .padding(20)
        }
        .background(Color.appWhite)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    TripCardView(
        trip: Trip(
            name: "Bahamas Family Trip",
            destination: "Paris",
            startDate: "19th April 2024",
            duration: 5
        ),
        onViewTap: {}
    )
    .padding()
}

