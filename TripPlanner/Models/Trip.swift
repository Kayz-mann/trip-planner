//
//  Trip.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 12/12/2025.
//

import Foundation

struct Trip: Codable, Identifiable, Hashable {
    let id: String?
    var name: String
    var destination: String
    var startDate: String?
    var endDate: String?
    var duration: Int? // in days
    var travelStyle: String?
    var description: String?
    var createdAt: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case destination
        case startDate = "start_date"
        case endDate = "end_date"
        case duration
        case travelStyle = "travel_style"
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(id: String? = nil,
         name: String,
         destination: String,
         startDate: String? = nil,
         endDate: String? = nil,
         duration: Int? = nil,
         travelStyle: String? = nil,
         description: String? = nil,
         createdAt: String? = nil,
         updatedAt: String? = nil) {
        self.id = id
        self.name = name
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.duration = duration
        self.travelStyle = travelStyle
        self.description = description
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Trip Response Models
struct TripResponse: Codable {
    let data: [Trip]
}

struct SingleTripResponse: Codable {
    let data: Trip
}

// MARK: - Trip Creation/Update Request
struct TripRequest: Codable {
    let name: String
    let destination: String
    let startDate: String?
    let endDate: String?
    let duration: Int?
    let travelStyle: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case destination
        case startDate = "start_date"
        case endDate = "end_date"
        case duration
        case travelStyle = "travel_style"
        case description
    }
}

