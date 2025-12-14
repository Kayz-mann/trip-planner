//
//  TripListViewModel.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 12/12/2025.
//

import Foundation
import Combine

@MainActor
class TripListViewModel: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showError = false
    
    private let apiService: APIService
    
    init(apiService: APIService = APIService.shared) {
        self.apiService = apiService
    }
    
    func loadTrips() async {
        isLoading = true
        errorMessage = nil
        showError = false
        
        do {
            trips = try await apiService.fetchTrips()
        } catch {
            errorMessage = error.localizedDescription
            showError = true
        }
        
        isLoading = false
    }
    
    func deleteTrip(at indexSet: IndexSet) async {
        guard let index = indexSet.first, index < trips.count else { return }
        let trip = trips[index]
        guard let id = trip.id else { return }
        
        do {
            try await apiService.deleteTrip(id: id)
            await loadTrips() // Reload list
        } catch {
            errorMessage = "Failed to delete trip: \(error.localizedDescription)"
            showError = true
        }
    }
    
    func deleteTrip(id: String) async {
        do {
            try await apiService.deleteTrip(id: id)
            await loadTrips() // Reload list
        } catch {
            errorMessage = "Failed to delete trip: \(error.localizedDescription)"
            showError = true
        }
    }
    
    /// Add a trip to the list (for optimistic updates)
    func addTrip(_ trip: Trip) {
        trips.insert(trip, at: 0) // Add at the top
    }
}

