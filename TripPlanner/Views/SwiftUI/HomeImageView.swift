//
//  HomeImageView.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 13/12/2025.
//

import SwiftUI

struct HomeImageView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Title text section at top
            VStack(alignment: .leading, spacing: 12) {
                Text("Plan Your Dream Trip in Minutes")
                    .font(.appFont(style: .b1SemiBold))
                    .foregroundColor(.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("Build, personalize, and optimize your itineraries with our trip planner. Perfect for getaways, remote workcations, and any spontaneous escapade.")
                    .font(.appFont(style: .b3Medium))
                    .foregroundColor(.tertiaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 20)
            .padding(.top, 80)

            // Hotel images section - layered and properly sized
            ZStack(alignment: .bottomLeading) {
                // Base hotel image (background) - full width at the bottom
                Image("base-hotel-image")
                    .resizable()
//                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150) // adjust base height as needed
                    .clipped()
                    .padding(.top, 5)

                // Foreground: hotel and cloud
                HStack {
                    Image("hotel-image")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 400, alignment: .leading)
                        .frame(height: 450) // adjust as needed
                        .padding(.bottom, 30) // lift the hotel so its bottom sits right above the base

                    Spacer(minLength: 0)

                    Image("cloud")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 16)
                        .padding(.trailing, 60)
                        .padding(.bottom, 220) // roughly base height + small offset
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 20)

            // "Where to? Select City" card - overlays on bottom of images
//            Button(action: {
//                showPlanTripModal = true
//            }) {
//                HStack(spacing: 12) {
//                    Image(systemName: "location")
//                        .font(.system(size: 24))
//                        .foregroundColor(.tertiaryText)
//
//                    VStack(alignment: .leading, spacing: 4) {
//                        Text("Where to ?")
//                            .font(.appFont(style: .b4Medium))
//                            .foregroundColor(.secondaryText)
//
//                        Text("Select City")
//                            .font(.appFont(style: .b3Bold))
//                            .foregroundColor(.tertiaryText)
//                    }
//
//                    Spacer()
//                }
//                .padding(20)
//                .frame(maxWidth: .infinity)
//                .background(Color.appWhite)
//                .cornerRadius(12)
//                .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
//            }
//            .padding(.horizontal, 20)
//            .offset(y: -40) // Overlap onto hotel images

//            Spacer()
        }
    }
}

#Preview {
    HomeImageView()
}
