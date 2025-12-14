//
//  APIService.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 12/12/2025.
//

import Foundation

enum APIError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case decodingError(Error)
    case encodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let code):
            return "HTTP Error: \(code)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

class APIService {
    static let shared = APIService()
    
    // Replace with your Beeceptor endpoint
    // Format: https://{random}.beeceptor.com/api/trips
    private let baseURL: String
    
    private let session: URLSession
    
    init(baseURL: String? = nil, session: URLSession = URLSession.shared) {
        // Use configured base URL or fallback
        self.baseURL = baseURL ?? APIConfiguration.baseURL
        self.session = session
    }
    
    // MARK: - CRUD Operations
    
    /// GET /api/trips - Fetch all trips
    func fetchTrips() async throws -> [Trip] {
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await session.data(for: request)
            try validateResponse(response)
            
            // Beeceptor returns array directly or wrapped in data
            if let trips = try? JSONDecoder().decode([Trip].self, from: data) {
                return trips
            } else if let response = try? JSONDecoder().decode(TripResponse.self, from: data) {
                return response.data
            } else {
                // Try to decode as single object in array format
                return []
            }
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    /// GET /api/trips/:id - Fetch single trip
    func fetchTrip(id: String) async throws -> Trip {
        let url = URL(string: "\(baseURL)/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await session.data(for: request)
            try validateResponse(response)
            
            if let trip = try? JSONDecoder().decode(Trip.self, from: data) {
                return trip
            } else if let response = try? JSONDecoder().decode(SingleTripResponse.self, from: data) {
                return response.data
            } else {
                throw APIError.decodingError(NSError(domain: "APIService", code: -1))
            }
        } catch let error as APIError {
            throw error
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    /// POST /api/trips - Create new trip
    func createTrip(_ trip: TripRequest) async throws -> Trip {
        let url = URL(string: baseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(trip)
            
            let (data, response) = try await session.data(for: request)
            try validateResponse(response)
            
            // Try to decode as Trip
            if let decodedTrip = try? JSONDecoder().decode(Trip.self, from: data) {
                return decodedTrip
            }
            
            // Try to decode as SingleTripResponse
            if let tripResponse = try? JSONDecoder().decode(SingleTripResponse.self, from: data) {
                return tripResponse.data
            }
            
            // Beeceptor returns template responses with {{$variables}} - handle this case
            if let responseString = String(data: data, encoding: .utf8),
               responseString.contains("{{$") {
                // Beeceptor template response - create a Trip from the request data
                // This is a workaround for Beeceptor's template response format
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                
                // Generate a simple ID (Beeceptor would do this)
                let generatedId = UUID().uuidString
                
                // Format dates for display if available
                var formattedStartDate: String? = nil
                var formattedEndDate: String? = nil
                
                if let startDate = trip.startDate {
                    if let date = formatter.date(from: startDate) {
                        formattedStartDate = DateHelper.formatDateForTrip(date)
                    } else {
                        formattedStartDate = startDate
                    }
                }
                
                if let endDate = trip.endDate {
                    if let date = formatter.date(from: endDate) {
                        formattedEndDate = DateHelper.formatDateForTrip(date)
                    } else {
                        formattedEndDate = endDate
                    }
                }
                
                // Create Trip from request data
                return Trip(
                    id: generatedId,
                    name: trip.name,
                    destination: trip.destination,
                    startDate: formattedStartDate,
                    endDate: formattedEndDate,
                    duration: trip.duration,
                    travelStyle: trip.travelStyle,
                    description: trip.description,
                    createdAt: ISO8601DateFormatter().string(from: Date()),
                    updatedAt: ISO8601DateFormatter().string(from: Date())
                )
            }
            
            // If all decoding attempts fail, throw decoding error
            throw APIError.decodingError(NSError(
                domain: "APIService",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to decode trip response. Response: \(String(data: data, encoding: .utf8) ?? "Unable to read response")"]
            ))
        } catch let error as APIError {
            throw error
        } catch {
            if error is EncodingError {
                throw APIError.encodingError(error)
            }
            throw APIError.networkError(error)
        }
    }
    
    /// PUT /api/trips/:id - Update entire trip
    func updateTrip(id: String, _ trip: TripRequest) async throws -> Trip {
        let url = URL(string: "\(baseURL)/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(trip)
            
            let (data, response) = try await session.data(for: request)
            try validateResponse(response)
            
            if let trip = try? JSONDecoder().decode(Trip.self, from: data) {
                return trip
            } else if let response = try? JSONDecoder().decode(SingleTripResponse.self, from: data) {
                return response.data
            } else {
                throw APIError.decodingError(NSError(domain: "APIService", code: -1))
            }
        } catch let error as APIError {
            throw error
        } catch {
            if error is EncodingError {
                throw APIError.encodingError(error)
            }
            throw APIError.networkError(error)
        }
    }
    
    /// PATCH /api/trips/:id - Partially update trip
    func patchTrip(id: String, _ trip: TripRequest) async throws -> Trip {
        let url = URL(string: "\(baseURL)/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            request.httpBody = try encoder.encode(trip)
            
            let (data, response) = try await session.data(for: request)
            try validateResponse(response)
            
            if let trip = try? JSONDecoder().decode(Trip.self, from: data) {
                return trip
            } else if let response = try? JSONDecoder().decode(SingleTripResponse.self, from: data) {
                return response.data
            } else {
                throw APIError.decodingError(NSError(domain: "APIService", code: -1))
            }
        } catch let error as APIError {
            throw error
        } catch {
            if error is EncodingError {
                throw APIError.encodingError(error)
            }
            throw APIError.networkError(error)
        }
    }
    
    /// DELETE /api/trips/:id - Delete trip
    func deleteTrip(id: String) async throws {
        let url = URL(string: "\(baseURL)/\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await session.data(for: request)
        try validateResponse(response)
    }
    
    // MARK: - Helper Methods
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(httpResponse.statusCode)
        }
    }
    
    /// Configure the base URL for the API
    func configure(baseURL: String) {
        // This would typically update the baseURL
        // For now, we'll use a shared instance approach
    }
}

