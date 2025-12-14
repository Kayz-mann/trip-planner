//
//  HomeView.swift
//  TripPlanner
//
//  Created by Claude Code on 12/13/2025.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTrip: Trip? = nil
    @StateObject private var viewModel = TripListViewModel()
    
    // Central state for the trip planning
    @State private var selectedCity: String = ""
    @State private var startDate: Date? = nil
    @State private var endDate: Date? = nil
    @State private var showCreateTripForm: Bool = false
    @State private var showCityPicker: Bool = false
    @State private var showDatePicker: Bool = false
    @State private var showValidationAlert: Bool = false
    
    // Computed property for trips from API
    private var allTrips: [Trip] {
        viewModel.trips
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.lightBackground
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HomeImageView()
                    
                    // Action card positioned to overlap the image
                    PlanTripActionCardView(
                        selectedCity: $selectedCity,
                        startDate: $startDate,
                        endDate: $endDate,
                        onCityTap: {
                            showCityPicker = true
                        },
                        onStartDateTap: {
                            showDatePicker = true
                        },
                        onEndDateTap: {
                            showDatePicker = true
                        },
                        onCreateTrip: {
                            validateAndCreateTrip()
                        },
                        onDismiss: { dismiss() }
                    )
                    .padding(.horizontal, 20)
                    .offset(y: -320) // Overlap onto the image area
                    
                    // Your Trips Section - brought up to reduce gap
                    if viewModel.isLoading {
                        ProgressView()
                            .padding(.top, 100)
                            .offset(y: -320)
                    } else {
                        YourTripsSectionView(trips: allTrips) { trip in
                            selectedTrip = trip
                        }
                        .offset(y: -320) // Bring it up closer to the action card
                    }
                    
                    // Spacing at bottom - reduced
                    Color.clear
                        .frame(height: 20)
                }
                .background(Color.clear)
            }
            .background(Color.clear)
            .ignoresSafeArea(edges: .top)
        }
        .sheet(isPresented: $showCityPicker) {
            CityPickerView(selectedCity: $selectedCity, isPresented: $showCityPicker)
        }
        .sheet(isPresented: $showDatePicker) {
            DateRangePickerView(
                startDate: $startDate,
                endDate: $endDate,
                isPresented: $showDatePicker
            )
        }
        .sheet(isPresented: $showCreateTripForm) {
            CreateTripSheetView(
                selectedCity: selectedCity,
                startDate: startDate,
                endDate: endDate,
                onTripCreated: { tripName, travelStyle, tripDescription in
                    createNewTrip(
                        name: tripName,
                        travelStyle: travelStyle,
                        description: tripDescription
                    )
                }
            )
        }
        .alert("Please fill trip information", isPresented: $showValidationAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Please select a city, start date, and end date to create a trip.")
        }
        .navigationBarHidden(true)
        .navigationDestination(item: $selectedTrip) { trip in
            TripDetailView(trip: trip)
        }
        .task {
            await viewModel.loadTrips()
        }
        .alert("Error", isPresented: $viewModel.showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "An error occurred")
        }
        }
    }
    
    private func validateAndCreateTrip() {
        if selectedCity.isEmpty || startDate == nil || endDate == nil {
            showValidationAlert = true
        } else {
            showCreateTripForm = true
        }
    }
    
    private func createNewTrip(name: String, travelStyle: String, description: String) {
        guard let startDate = startDate, let endDate = endDate else { return }
        
        // Calculate duration
        let duration = DateHelper.daysBetween(startDate, endDate)
        
        // Format dates for API (ISO format or simple format)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formattedStartDate = dateFormatter.string(from: startDate)
        let formattedEndDate = dateFormatter.string(from: endDate)
        
        // Extract city name from selectedCity (format: "City, Country")
        let destination = selectedCity.components(separatedBy: ",").first?.trimmingCharacters(in: .whitespaces) ?? selectedCity
        
        // Create trip request for API
        let tripRequest = TripRequest(
            name: name,
            destination: destination,
            startDate: formattedStartDate,
            endDate: formattedEndDate,
            duration: duration,
            travelStyle: travelStyle,
            description: description.isEmpty ? nil : description
        )
        
        // Create trip via API with structured concurrency
        Task { @MainActor in
            do {
                let createdTrip = try await APIService.shared.createTrip(tripRequest)
                
                // Optimistic update: Add trip to local list immediately
                // This works around Beeceptor free tier limitation (no data persistence)
                // Beeceptor's GET endpoint returns static data, so new trips won't appear there
                viewModel.addTrip(createdTrip)
                
                // Also try to reload trips from API (in case API does persist)
                // Note: This will replace the list, but since Beeceptor doesn't persist,
                // we keep the optimistic update above
                await viewModel.loadTrips()
                
                // Re-add the created trip if it's not in the fetched list
                // (Beeceptor free tier doesn't persist, so it won't be there)
                if !viewModel.trips.contains(where: { $0.id == createdTrip.id }) {
                    viewModel.addTrip(createdTrip)
                }

                // Reset form fields
                self.selectedCity = ""
                self.startDate = nil
                self.endDate = nil
            } catch let apiError as APIError {
                viewModel.errorMessage = apiError.errorDescription ?? "Failed to create trip"
                viewModel.showError = true
            } catch {
                viewModel.errorMessage = "Failed to create trip: \(error.localizedDescription)"
                viewModel.showError = true
            }
        }
    }
}


#Preview {
    HomeView()
}
