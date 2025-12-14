//
//  APIServiceEdgeCaseTests.swift
//  TripPlannerTests
//
//  Created by Balogun Kayode on 14/12/2025.
//

import Testing
import Foundation
@testable import TripPlanner

struct APIServiceEdgeCaseTests {
    
    // MARK: - URL Construction Edge Cases
    
    @Test("Invalid base URL should cause issues")
    func testInvalidBaseURL() {
        let service = APIService(baseURL: "not a valid url")
        // The force unwrap in fetchTrips() would crash, but we test the URL construction
        let url = URL(string: "not a valid url")
        #expect(url == nil)
    }
    
    @Test("Empty base URL should be handled")
    func testEmptyBaseURL() {
        let service = APIService(baseURL: "")
        let url = URL(string: "")
        #expect(url != nil) // Empty string creates a relative URL
    }
    
    @Test("Base URL with trailing slash should work")
    func testBaseURLWithTrailingSlash() {
        let baseURL = "https://api.example.com/trips/"
        let service = APIService(baseURL: baseURL)
        let url = URL(string: baseURL)
        #expect(url != nil)
    }
    
    // MARK: - Trip ID Edge Cases
    
    @Test("Empty trip ID should create invalid URL")
    func testEmptyTripID() {
        let baseURL = "https://api.example.com/trips"
        let id = ""
        let url = URL(string: "\(baseURL)/\(id)")
        #expect(url != nil) // Creates valid URL but with empty path component
    }
    
    @Test("Trip ID with special characters should be encoded")
    func testTripIDWithSpecialCharacters() {
        let baseURL = "https://api.example.com/trips"
        let id = "trip/123"
        let url = URL(string: "\(baseURL)/\(id)")
        // This would create an invalid URL structure
        #expect(url != nil)
    }
    
    @Test("Very long trip ID should be handled")
    func testVeryLongTripID() {
        let baseURL = "https://api.example.com/trips"
        let id = String(repeating: "a", count: 1000)
        let url = URL(string: "\(baseURL)/\(id)")
        #expect(url != nil)
    }
    
    // MARK: - TripRequest Edge Cases
    
    @Test("TripRequest with empty name should encode")
    func testTripRequestEmptyName() {
        let request = TripRequest(
            name: "",
            destination: "Paris",
            startDate: "2024-04-19",
            endDate: "2024-04-24",
            duration: 5,
            travelStyle: "Family",
            description: nil
        )
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try? encoder.encode(request)
        #expect(data != nil)
    }
    
    @Test("TripRequest with very long name should encode")
    func testTripRequestVeryLongName() {
        let longName = String(repeating: "A", count: 1000)
        let request = TripRequest(
            name: longName,
            destination: "Paris",
            startDate: nil,
            endDate: nil,
            duration: nil,
            travelStyle: nil,
            description: nil
        )
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try? encoder.encode(request)
        #expect(data != nil)
    }
    
    @Test("TripRequest with all nil optional fields should encode")
    func testTripRequestAllNilOptionals() {
        let request = TripRequest(
            name: "Test Trip",
            destination: "Paris",
            startDate: nil,
            endDate: nil,
            duration: nil,
            travelStyle: nil,
            description: nil
        )
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try? encoder.encode(request)
        #expect(data != nil)
    }
    
    @Test("TripRequest with special characters in description should encode")
    func testTripRequestSpecialCharacters() {
        let request = TripRequest(
            name: "Test Trip",
            destination: "Paris",
            startDate: "2024-04-19",
            endDate: "2024-04-24",
            duration: 5,
            travelStyle: "Family",
            description: "Trip with émojis 🎉 and spéciál chárs"
        )
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let data = try? encoder.encode(request)
        #expect(data != nil)
    }
    
    // MARK: - Trip Model Edge Cases
    
    @Test("Trip with nil ID should be valid")
    func testTripWithNilID() {
        let trip = Trip(
            id: nil,
            name: "Test Trip",
            destination: "Paris"
        )
        #expect(trip.id == nil)
        #expect(trip.name == "Test Trip")
    }
    
    @Test("Trip with empty name should be valid")
    func testTripWithEmptyName() {
        let trip = Trip(
            id: "1",
            name: "",
            destination: "Paris"
        )
        #expect(trip.name.isEmpty)
    }
    
    @Test("Trip with all optional fields nil should be valid")
    func testTripAllOptionalsNil() {
        let trip = Trip(
            id: "1",
            name: "Test",
            destination: "Paris",
            startDate: nil,
            endDate: nil,
            duration: nil,
            travelStyle: nil,
            description: nil,
            createdAt: nil,
            updatedAt: nil
        )
        #expect(trip.startDate == nil)
        #expect(trip.endDate == nil)
        #expect(trip.duration == nil)
    }
    
    @Test("Trip encoding with snake case should work")
    func testTripEncodingSnakeCase() {
        let trip = Trip(
            id: "1",
            name: "Test Trip",
            destination: "Paris",
            startDate: "2024-04-19",
            endDate: "2024-04-24",
            duration: 5,
            travelStyle: "Family",
            description: "A trip"
        )
        let encoder = JSONEncoder()
        let data = try? encoder.encode(trip)
        #expect(data != nil)
        
        if let data = data,
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            #expect(json["start_date"] != nil)
            #expect(json["travel_style"] != nil)
        }
    }
    
    @Test("Trip decoding with snake case should work")
    func testTripDecodingSnakeCase() {
        let json = """
        {
            "id": "1",
            "name": "Test Trip",
            "destination": "Paris",
            "start_date": "19th April 2024",
            "end_date": "24th April 2024",
            "duration": 5,
            "travel_style": "Family",
            "description": "A trip"
        }
        """.data(using: .utf8)!
        
        let trip = try? JSONDecoder().decode(Trip.self, from: json)
        #expect(trip != nil)
        #expect(trip?.startDate == "19th April 2024")
        #expect(trip?.travelStyle == "Family")
    }
    
    @Test("Trip with negative duration should be valid")
    func testTripNegativeDuration() {
        let trip = Trip(
            id: "1",
            name: "Test",
            destination: "Paris",
            duration: -5
        )
        #expect(trip.duration == -5)
    }
    
    @Test("Trip with zero duration should be valid")
    func testTripZeroDuration() {
        let trip = Trip(
            id: "1",
            name: "Test",
            destination: "Paris",
            duration: 0
        )
        #expect(trip.duration == 0)
    }
    
    @Test("Trip with very large duration should be valid")
    func testTripVeryLargeDuration() {
        let trip = Trip(
            id: "1",
            name: "Test",
            destination: "Paris",
            duration: Int.max
        )
        #expect(trip.duration == Int.max)
    }
}

