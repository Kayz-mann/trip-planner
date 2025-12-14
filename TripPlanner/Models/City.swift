//
//  City.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 13/12/2025.
//

import Foundation

struct City: Identifiable {
    let id = UUID()
    let name: String
    let country: String
    let location: String // District or specific location
    let countryCode: String
    let flagImageName: String
}

