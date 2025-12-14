//
//  APIConfiguration.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 12/12/2025.
//

import Foundation

struct APIConfiguration {
    // Beeceptor endpoint (free tier - 2 rules max)
    // GET and POST are configured
    static let baseURL: String = "https://trip-planner.free.beeceptor.com/api/trips"
    
    // Alternative: Local mock API server (run: ./mock-api/start-server.sh)
    // static let baseURL: String = "http://localhost:3000/api/trips"
}
