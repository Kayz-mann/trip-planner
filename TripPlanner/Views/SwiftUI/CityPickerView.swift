//
//  CityPickerView.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 13/12/2025.
//

import SwiftUI

struct CityPickerView: View {
    @Binding var selectedCity: String
    @Binding var isPresented: Bool
    @State private var searchText: String = ""
    
    private let cities: [City] = {
        var allCities: [City] = []
        
        // Laghouat, Algeria - duplicate multiple times
        for _ in 0..<5 {
            allCities.append(City(
                name: "Laghouat",
                country: "Algeria",
                location: "Laghouat",
                countryCode: "DZ",
                flagImageName: "algeria-flag"
            ))
        }
        
        // Lagos, Nigeria - duplicate multiple times
        for _ in 0..<5 {
            allCities.append(City(
                name: "Lagos",
                country: "Nigeria",
                location: "Muritala Muhammed",
                countryCode: "NG",
                flagImageName: "nigeria-flag"
            ))
        }
        
        // Doha, Qatar - duplicate multiple times
        for _ in 0..<8 {
            allCities.append(City(
                name: "Doha",
                country: "Qatar",
                location: "Doha",
                countryCode: "QA",
                flagImageName: "qatar-flag"
            ))
        }
        
        return allCities
    }()
    
    private var filteredCities: [City] {
        if searchText.isEmpty {
            return cities
        }
        return cities.filter { city in
            city.name.localizedCaseInsensitiveContains(searchText) ||
            city.country.localizedCaseInsensitiveContains(searchText) ||
            city.location.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Please select a city")
                        .font(.appFont(style: .b3Medium))
                        .foregroundColor(.tertiaryText)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    
                    TextField("", text: $searchText)
                        .font(.appFont(style: .b3Medium))
                        .foregroundColor(.primaryText)
                        .padding(16)
                        .background(Color.appWhite)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.primaryBlue, lineWidth: 2)
                        )
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                }
                .background(Color.lightBackground)
                
                // City list
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(filteredCities) { city in
                            Button(action: {
                                selectedCity = "\(city.name), \(city.country)"
                                isPresented = false
                            }) {
                                HStack(spacing: 12) {
                                    // Map pin icon - left side
                                    Image("map-pin")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    
                                    // City info
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("\(city.name), \(city.country)")
                                            .font(.appFont(style: .b3SemiBold))
                                            .foregroundColor(.primaryText)
                                        
                                        Text(city.location)
                                            .font(.appFont(style: .b4Medium))
                                            .foregroundColor(.tertiaryText)
                                    }
                                    
                                    Spacer()
                                    
                                    // Flag and country code - right side
                                    HStack(spacing: 8) {
                                        Image(city.flagImageName)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 24)
                                        
                                        Text(city.countryCode)
                                            .font(.appFont(style: .b4Medium))
                                            .foregroundColor(.tertiaryText)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.vertical, 16)
                                .background(Color.appWhite)
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            Divider()
                                .padding(.leading, 52)
                        }
                    }
                }
                .background(Color.appWhite)
            }
            .background(Color.lightBackground)
            .navigationTitle("Select City")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        isPresented = false
                    }
                    .foregroundColor(.primaryBlue)
                }
            }
        }
    }
}

#Preview {
    CityPickerView(
        selectedCity: .constant(""),
        isPresented: .constant(true)
    )
}

