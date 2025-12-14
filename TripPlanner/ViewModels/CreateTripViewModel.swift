//
//  CreateTripViewModel.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 12/12/2025.
//

import Foundation
import Combine

@MainActor
class CreateTripViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var destination: String = ""
    @Published var startDate: String = ""
    @Published var endDate: String = ""
    @Published var duration: String = ""
    @Published var travelStyle: String = ""
    @Published var description: String = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    @Published var showSuccess = false
    @Published var successMessage: String?
    
    // Validation
    @Published var nameError: String?
    @Published var destinationError: String?
    
    private let apiService: APIService
    var editingTrip: Trip?
    
    init(apiService: APIService = APIService.shared, editingTrip: Trip? = nil) {
        self.apiService = apiService
        self.editingTrip = editingTrip
        
        if let trip = editingTrip {
            name = trip.name
            destination = trip.destination
            startDate = trip.startDate ?? ""
            endDate = trip.endDate ?? ""
            duration = trip.duration.map { String($0) } ?? ""
            travelStyle = trip.travelStyle ?? ""
            description = trip.description ?? ""
        }
    }
    
    func validate() -> Bool {
        var isValid = true
        
        // Validate name
        if name.trimmingCharacters(in: .whitespaces).isEmpty {
            nameError = "Trip name is required"
            isValid = false
        } else {
            nameError = nil
        }
        
        // Validate destination
        if destination.trimmingCharacters(in: .whitespaces).isEmpty {
            destinationError = "Destination is required"
            isValid = false
        } else {
            destinationError = nil
        }
        
        return isValid
    }
    
    func saveTrip() async -> Bool {
        guard validate() else {
            return false
        }
        
        isLoading = true
        errorMessage = nil
        showError = false
        showSuccess = false
        
        let tripRequest = TripRequest(
            name: name.trimmingCharacters(in: .whitespaces),
            destination: destination.trimmingCharacters(in: .whitespaces),
            startDate: startDate.isEmpty ? nil : startDate,
            endDate: endDate.isEmpty ? nil : endDate,
            duration: Int(duration),
            travelStyle: travelStyle.isEmpty ? nil : travelStyle,
            description: description.isEmpty ? nil : description
        )
        
        do {
            if let tripId = editingTrip?.id {
                // Update existing trip
                _ = try await apiService.updateTrip(id: tripId, tripRequest)
                successMessage = "Trip updated successfully"
            } else {
                // Create new trip
                _ = try await apiService.createTrip(tripRequest)
                successMessage = "Trip created successfully"
            }
            showSuccess = true
            isLoading = false
            return true
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            isLoading = false
            return false
        }
    }
}

