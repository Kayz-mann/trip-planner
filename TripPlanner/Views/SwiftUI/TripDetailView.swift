//
//  TripDetailView.swift
//  TripPlanner
//
//  Created by Balogun Kayode on 12/12/2025.
//

import SwiftUI

struct TripDetailView: View {
    let trip: Trip
    @Environment(\.dismiss) var dismiss
    
    // State for itinerary sections
    @State private var isFlightsExpanded = true
    @State private var isHotelsExpanded = true
    @State private var isActivitiesExpanded = true
    
    // State for empty/filled cards - start with empty states
    @State private var hasFlight = false
    @State private var hasHotel = false
    @State private var hasActivity = false
    
    // Data arrays - start empty, populated when "Add" is clicked
    @State private var flights: [Flight] = []
    @State private var hotels: [Hotel] = []
    @State private var activities: [Activity] = []
    
    // Mock data constants - used when "Add" button is clicked
    private let mockFlight = Flight(
        airline: "American Airlines",
        flightNumber: "AA-829",
        departureTime: "08:35",
        departureDate: "Sun, 20 Aug",
        departureCode: "LOS",
        arrivalTime: "09:55",
        arrivalDate: "Sun, 20 Aug",
        arrivalCode: "SIN",
        duration: "1h 45m",
        route: "LOS Direct SIN",
        price: "₦ 123,450.00"
    )
    
    private let mockHotel = Hotel(
        name: "Riviera Resort, Lekki",
        address: "18, Kenneth Agbakuru Street, Off Access Bank Admiralty Way, Lekki Phase1",
        imageUrls: [nil], // Will use local asset
        rating: 8.5,
        reviewCount: 436,
        roomType: "King size room",
        checkInDate: "20-04-2024",
        checkOutDate: "29-04-2024",
        price: "₦ 123,450.00",
        mapUrl: ""
    )
    
    private let mockActivity = Activity(
        name: "The Museum of Modern Art",
        description: "Works from Van Gogh to Warhol & beyond plus a sculpture garden, 2 cafes & The modern restaurant",
        location: "Melbourne, Australia",
        imageUrls: [nil], // Will use local asset
        rating: 8.5,
        reviewCount: 436,
        duration: "1 hour",
        time: "10:30 AM",
        date: "Mar 19",
        dayInfo: "Day 1 (Activity 1)",
        price: "₦ 123,450.00"
    )

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header with back button and title
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(.primaryText)
                    }
                    
                    Spacer()
                    
                    Text("Plan a Trip")
                        .font(.appFont(style: .b2SemiBold))
                        .foregroundColor(.primaryText)
                    
                    Spacer()
                    
                    // Placeholder for alignment
                    Color.clear.frame(width: 20)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(Color.lightBackground)
                
                // Trip Overview Card
                VStack(spacing: 0) {
                    // Background with bahamas image
                    ZStack {
                        Color.lightBackground

                        VStack {
                            Spacer()
                            // Use local bahamas image - can be extended to use trip.imageUrl if added to model
                            Image("bahamas-family-trip")
                                .resizable()
                                .scaledToFill()
                                .frame(height: 150)
                                .clipped()
                        }
                    }
                    .frame(height: 200)

                    // Trip details card
                VStack(alignment: .leading, spacing: 16) {
                    // Date Range
                    HStack(spacing: 8) {
                        Image(systemName: "calendar")
                            .font(.system(size: 16))
                            .foregroundColor(.tertiaryText)

                        if let startDate = trip.startDate, let endDate = trip.endDate {
                            Text("\(startDate) → \(endDate)")
                                .font(.appFont(style: .b3Medium))
                                .foregroundColor(.tertiaryText)
                        }
                    }

                    // Trip Name
                    Text(trip.name)
                        .font(.appFont(style: .b1SemiBold))
                        .foregroundColor(.primaryText)

                    // Destination and Travel Style
                    HStack {
                            Text(trip.destination)
                            .font(.appFont(style: .b3Medium))
                            .foregroundColor(.tertiaryText)

                        Text("|")
                            .foregroundColor(.tertiaryText)

                        if let travelStyle = trip.travelStyle {
                            Text("\(travelStyle) Trip")
                                .font(.appFont(style: .b3Medium))
                                .foregroundColor(.tertiaryText)
                        }
                    }

                        // Action Buttons
                    HStack(spacing: 12) {
                        Button(action: {
                            // Trip collaboration action
                        }) {
                            HStack(spacing: 6) {
                                Image("trip-collaboration")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)

                                Text("Trip Collaboration")
                                    .font(.appFont(style: .b4Medium))
                                    .foregroundColor(.primaryBlue)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.8)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 8)
                            .background(Color.appWhite)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.primaryBlueBorder, lineWidth: 1)
                            )
                        }

                        Button(action: {
                            // Share trip action
                        }) {
                            HStack(spacing: 6) {
                                Image("share-trip")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 16, height: 16)

                                Text("Share Trip")
                                    .font(.appFont(style: .b4Medium))
                                    .foregroundColor(.primaryBlue)
                                    .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 8)
                            .background(Color.appWhite)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.primaryBlueBorder, lineWidth: 1)
                            )
                        }

                        Button(action: {
                            // More options
                        }) {
                            Image(systemName: "ellipsis")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.primaryText)
                                .frame(width: 44, height: 44)
                                .background(Color.appWhite)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                        }
                    }
                    }
                    .padding(20)
                    .background(Color.appWhite)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                
                // Planning Cards Section
                VStack(spacing: 16) {
                    // Activities Card
                    PlanningCardView(
                        title: "Activities",
                        icon: "activities-icon",
                        description: "Build, personalize, and optimize your itineraries with our trip planner.",
                        buttonText: "Add Activities",
                        headerColor: .activitiesCardDarkBackground,
                        emptyStateImage: "activities-image-empty",
                        onButtonTap: {
                            // Add activities action
                        }
                    )
                    
                    // Hotels Card
                    PlanningCardView(
                        title: "Hotels",
                        icon: "hotel-icon",
                        description: "Build, personalize, and optimize your itineraries with our trip planner.",
                        buttonText: "Add Hotels",
                        headerColor: .hotelsCardBackground,
                        emptyStateImage: "hotels-image-empty",
                        onButtonTap: {
                            // Add hotels action
                        }
                    )
                    
                    // Flights Card
                    PlanningCardView(
                        title: "Flights",
                        icon: "flight-icon",
                        description: "Build, personalize, and optimize your itineraries with our trip planner.",
                        buttonText: "Add Flights",
                        headerColor: Color(hex: "#E5E7EB"), // Light gray for flights
                        emptyStateImage: "flights-image-empty",
                        onButtonTap: {
                            // Add flights action
                        }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)

                // Trip Itineraries Section
                        VStack(alignment: .leading, spacing: 16) {
                    // Section Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Trip itineraries")
                                .font(.appFont(style: .b2SemiBold))
                            .foregroundColor(.primaryText)
                        
                        Text("Your trip itineraries are placed here")
                            .font(.appFont(style: .b4Medium))
                            .foregroundColor(.tertiaryText)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    
                    // Flights Section
                    ItinerarySectionView(
                        title: "Flights",
                        icon: "flight-icon",
                        isExpanded: $isFlightsExpanded,
                        hasItem: $hasFlight,
                        cardBackgroundColor: Color(hex: "#F3F4F6"), // Light gray for flights
                        items: flights,
                        emptyStateView: {
                            FlightEmptyStateView(onAdd: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    flights = [mockFlight]
                                    hasFlight = true
                                }
                            })
                        },
                        filledStateView: { flight in
                            FlightCardView(
                                flight: flight,
                                onRemove: {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        flights = []
                                        hasFlight = false
                                    }
                                }
                            )
                        }
                    )
                    
                    // Hotels Section
                    ItinerarySectionView(
                        title: "Hotels",
                        icon: "hotel-icon",
                        isExpanded: $isHotelsExpanded,
                        hasItem: $hasHotel,
                        cardBackgroundColor: .hotelsCardBackground, // Dark gray for hotels
                        items: hotels,
                        emptyStateView: {
                            HotelEmptyStateView(onAdd: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    hotels = [mockHotel]
                                    hasHotel = true
                                }
                            })
                        },
                        filledStateView: { hotel in
                            HotelCardView(
                                hotel: hotel,
                                onRemove: {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        hotels = []
                                        hasHotel = false
                                    }
                                }
                            )
                        }
                    )
                    
                    // Activities Section
                    ItinerarySectionView(
                        title: "Activities",
                        icon: "activities-icon",
                        isExpanded: $isActivitiesExpanded,
                        hasItem: $hasActivity,
                        cardBackgroundColor: .activitiesCardBackground, // Blue for activities
                        items: activities,
                        emptyStateView: {
                            ActivityEmptyStateView(onAdd: {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    activities = [mockActivity]
                                    hasActivity = true
                                }
                            })
                        },
                        filledStateView: { activity in
                            ActivityCardView(
                                activity: activity,
                                onRemove: {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        activities = []
                                        hasActivity = false
                                    }
                                }
                            )
                        }
                    )
                }
                .padding(.bottom, 32)
            }
        }
        .background(Color.lightBackground)
        .navigationBarHidden(true)
    }
}

// MARK: - Planning Card View
struct PlanningCardView: View {
    let title: String
    let icon: String
    let description: String
    let buttonText: String
    let headerColor: Color
    let emptyStateImage: String
    let onButtonTap: () -> Void
    
    // Determine text color based on header color brightness
    private var headerTextColor: Color {
        // For light gray (flights), use dark text; for dark backgrounds, use white
        if headerColor == Color(hex: "#E5E7EB") {
            return .primaryText
        } else {
            return .white
        }
    }
    
    private var iconColor: Color {
        if headerColor == Color(hex: "#E5E7EB") {
            return .primaryText
        } else {
            return .white
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Section
            HStack(spacing: 12) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(iconColor)
                
                Text(title)
                    .font(.appFont(style: .b2SemiBold))
                    .foregroundColor(headerTextColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(headerColor)
            .cornerRadius(12, corners: [.topLeft, .topRight])
            
            // Content Section (White Background)
            VStack(spacing: 24) {
                Text(description)
                                .font(.appFont(style: .b3Medium))
                    .foregroundColor(.tertiaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)
                
                // Empty State Icon
                ZStack {
                    Circle()
                        .fill(Color.primaryBlue.opacity(0.1))
                        .frame(width: 120, height: 120)
                    
                    Image(emptyStateImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                
                Text("No request yet")
                    .font(.appFont(style: .b3Medium))
                    .foregroundColor(.tertiaryText)
                
                Button(action: onButtonTap) {
                    Text(buttonText)
                                    .font(.appFont(style: .b3SemiBold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.primaryBlue)
                                    .cornerRadius(8)
                            }
                .padding(.bottom, 8)
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
            .frame(minHeight: 320)
            .background(Color.appWhite)
            .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
        }
        .background(Color.appWhite)
                    .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Itinerary Section View
struct ItinerarySectionView<Item: Identifiable, EmptyView: View, FilledView: View>: View {
    let title: String
    let icon: String
    @Binding var isExpanded: Bool
    @Binding var hasItem: Bool
    let cardBackgroundColor: Color
    let items: [Item]
    let emptyStateView: () -> EmptyView
    let filledStateView: (Item) -> FilledView
    
    // Determine text color based on background color
    private var headerTextColor: Color {
        // Light gray background uses dark text, dark/blue backgrounds use white text
        if cardBackgroundColor == Color(hex: "#F3F4F6") {
            return .primaryText
        } else {
            return .white
        }
    }
    
    private var iconColor: Color {
        if cardBackgroundColor == Color(hex: "#F3F4F6") {
            return .primaryText
        } else {
            return .white
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Card with header and content
            VStack(spacing: 0) {
                // Header inside the colored card
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        Image(icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundColor(iconColor)
                        
                        Text(title)
                            .font(.appFont(style: .b3SemiBold))
                            .foregroundColor(headerTextColor)
                        
                        Spacer()
                        
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(headerTextColor)
                }
                .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                }

                // Content with flip animation
                if isExpanded {
                    ZStack {
                        if hasItem && !items.isEmpty {
                            // Filled state
                            VStack(spacing: 16) {
                                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                                    filledStateView(item)
                                        .padding(.horizontal, 16)
                                }
                            }
                            .padding(.top, 16)
                            .padding(.bottom, 24)
                            .transition(.asymmetric(
                                insertion: .scale.combined(with: .opacity),
                                removal: .scale.combined(with: .opacity)
                            ))
                        } else {
                            // Empty state
                            emptyStateView()
                                .padding(.horizontal, 16)
                                .padding(.vertical, 24)
                                .transition(.asymmetric(
                                    insertion: .scale.combined(with: .opacity),
                                    removal: .scale.combined(with: .opacity)
                                ))
                        }
                    }
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: hasItem)
                }
            }
            .background(cardBackgroundColor)
            .cornerRadius(12)
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
    }
}

// MARK: - Empty State Views
struct FlightEmptyStateView: View {
    let onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.primaryBlue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image("flights-image-empty")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            }
            
            Text("No request yet")
                                .font(.appFont(style: .b3Medium))
                                .foregroundColor(.tertiaryText)

            Button(action: onAdd) {
                Text("Add Flight")
                    .font(.appFont(style: .b3SemiBold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.primaryBlue)
                    .cornerRadius(8)
            }
        }
        .padding(24)
        .background(Color.appWhite)
        .cornerRadius(12)
    }
}

struct HotelEmptyStateView: View {
    let onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.primaryBlue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                            Image("hotels-image-empty")
                                .resizable()
                                .scaledToFit()
                    .frame(width: 80, height: 80)
            }
            
            Text("No request yet")
                .font(.appFont(style: .b3Medium))
                .foregroundColor(.tertiaryText)
            
            Button(action: onAdd) {
                Text("Add Hotel")
                                    .font(.appFont(style: .b3SemiBold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.primaryBlue)
                                    .cornerRadius(8)
                            }
                        }
        .padding(24)
        .background(Color.appWhite)
                    .cornerRadius(12)
                }
}

struct ActivityEmptyStateView: View {
    let onAdd: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.primaryBlue.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image("activities-image-empty")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            }
            
            Text("No request yet")
                .font(.appFont(style: .b3Medium))
                        .foregroundColor(.tertiaryText)

            Button(action: onAdd) {
                Text("Add Activity")
                    .font(.appFont(style: .b3SemiBold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.primaryBlue)
                    .cornerRadius(8)
            }
        }
        .padding(24)
        .background(Color.appWhite)
        .cornerRadius(12)
    }
}

// MARK: - Filled State Views
struct FlightCardView: View {
    let flight: Flight
    let onRemove: () -> Void
    
    var body: some View {
                    VStack(alignment: .leading, spacing: 16) {
            // Airline and Flight Number
            HStack(spacing: 12) {
                Image("american-airlines")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("American Airlines")
                        .font(.appFont(style: .b4Medium))
                        .foregroundColor(.primaryText)
                    
                    Text(flight.flightNumber)
                        .font(.appFont(style: .b4Medium))
                        .foregroundColor(.primaryText)
                }
                
                Spacer()
            }

            // Flight Route Details
                        HStack(spacing: 16) {
                // Departure
                            VStack(alignment: .leading, spacing: 4) {
                    Text(flight.departureTime)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primaryText)
                    
                    Text(flight.departureDate)
                                    .font(.appFont(style: .b4Medium))
                        .foregroundColor(.tertiaryText)

                    Text(flight.departureCode)
                                    .font(.appFont(style: .b4Medium))
                        .foregroundColor(.primaryText)
                        .fontWeight(.semibold)
                            }
                .frame(minWidth: 80)

                // Center section with progress bar
                            VStack(spacing: 8) {
                    // Duration with airplane icons
                    HStack(spacing: 8) {
                        // Departure airplane icon
                                Image("airplane-takeoff")
                                    .resizable()
                                    .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.tertiaryText)

                        // Duration with length icon
                        HStack(spacing: 4) {
                            Image("length-icon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 12, height: 12)
                                .foregroundColor(.tertiaryText)

                            Text(flight.duration)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.tertiaryText)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        
                        // Arrival airplane icon (landing)
                        Image("airplane-takeoff")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.tertiaryText)
                            .rotationEffect(.degrees(180))
                    }
                    
                    // Horizontal Progress Bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background bar
                            Rectangle()
                                .fill(Color.primaryBlue.opacity(0.1))
                                .frame(height: 4)
                                .cornerRadius(2)
                            
                            // Filled portion (approximately 2/3)
                            Rectangle()
                                .fill(Color.primaryBlue)
                                .frame(width: geometry.size.width * 0.67, height: 4)
                                .cornerRadius(2)
                        }
                    }
                    .frame(height: 4)
                    
                    // Route (LOS Direct SIN)
                    HStack(spacing: 4) {
                        Text(flight.departureCode)
                            .font(.appFont(style: .b4Medium))
                            .foregroundColor(.primaryText)
                            .fontWeight(.semibold)

                                Text("Direct")
                                    .font(.appFont(style: .b4Medium))
                            .foregroundColor(.tertiaryText)
                        
                        Text(flight.arrivalCode)
                            .font(.appFont(style: .b4Medium))
                            .foregroundColor(.primaryText)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
                
                // Arrival
                            VStack(alignment: .trailing, spacing: 4) {
                    Text(flight.arrivalTime)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.primaryText)
                    
                    Text(flight.arrivalDate)
                                    .font(.appFont(style: .b4Medium))
                        .foregroundColor(.tertiaryText)

                    Text(flight.arrivalCode)
                                    .font(.appFont(style: .b4Medium))
                        .foregroundColor(.primaryText)
                        .fontWeight(.semibold)
                            }
                .frame(minWidth: 80)
                        }

            // Divider
            Divider()
                .background(Color.gray.opacity(0.3))
            
            // Action Links - Centered and justified
                        HStack(spacing: 12) {
                Spacer()
                
                            Button(action: {}) {
                                Text("Flight details")
                        .font(.appFont(style: .b4Medium))
                                    .foregroundColor(.primaryBlue)
                            }

                            Button(action: {}) {
                                Text("Price details")
                        .font(.appFont(style: .b4Medium))
                                    .foregroundColor(.primaryBlue)
                            }

                            Button(action: {}) {
                                Text("Edit details")
                        .font(.appFont(style: .b4Medium))
                                    .foregroundColor(.primaryBlue)
                            }
                
                            Spacer()
                        }

            // Divider
            Divider()
                .background(Color.gray.opacity(0.3))
            
            // Price
                        HStack {
                Text(flight.price)
                                .font(.appFont(style: .b3SemiBold))
                    .foregroundColor(.primaryText)
                Spacer()
            }

            // Remove Button - Centered and wide
            Button(action: onRemove) {
                HStack(spacing: 4) {
                                    Text("Remove")
                                .font(.appFont(style: .b4Medium))
                                    Image(systemName: "xmark")
                                        .font(.system(size: 12))
                                }
                                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                                .background(Color.removeBackground)
                .cornerRadius(8)
                        }
                    }
                    .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.appWhite)
                    .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }
}

struct HotelCardView: View {
    let hotel: Hotel
    let onRemove: () -> Void
    
    // Local image array for hotels
    private let hotelImages = ["hotels-image", "hotel-image", "base-hotel-image", "bahamas-family-trip", "family-trip"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Image Carousel
            ImageCarouselView(imageNames: hotelImages)
            
            // Hotel Name
            Text(hotel.name)
                .font(.appFont(style: .b3SemiBold))
                .foregroundColor(.primaryText)
            
            // Address
            if !hotel.address.isEmpty {
                Text(hotel.address)
                    .font(.appFont(style: .b4Medium))
                    .foregroundColor(.tertiaryText)
                    .lineLimit(2)
            }
            
            // Details Row
            HStack(spacing: 16) {
                if !hotel.mapUrl.isEmpty {
                            Button(action: {}) {
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle")
                                .font(.system(size: 14))
                            Text("Show in map")
                                .font(.appFont(style: .b4Medium))
                        }
                        .foregroundColor(.primaryBlue)
                    }
                }
                
                if let rating = hotel.rating {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                                        .font(.system(size: 12))
                            .foregroundColor(.orange)
                        Text("\(rating, specifier: "%.1f") (\(hotel.reviewCount))")
                            .font(.appFont(style: .b4Medium))
                            .foregroundColor(.primaryText)
                    }
                }
                
                if !hotel.roomType.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "bed.double")
                            .font(.system(size: 14))
                        Text(hotel.roomType)
                                .font(.appFont(style: .b4Medium))
                    }
                    .foregroundColor(.primaryText)
                }
            }
            
            // Dates
            HStack(spacing: 16) {
                if !hotel.checkInDate.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12))
                        Text("In: \(hotel.checkInDate)")
                            .font(.appFont(style: .b4Medium))
                    }
                .foregroundColor(.tertiaryText)
                }
                
                if !hotel.checkOutDate.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12))
                        Text("Out: \(hotel.checkOutDate)")
                            .font(.appFont(style: .b4Medium))
                    }
                    .foregroundColor(.tertiaryText)
                }
            }
            
            // Action Links
            HStack(spacing: 8) {
                Button(action: {}) {
                    Text("Hotel details")
                        .font(.appFont(style: .b4Medium))
                        .foregroundColor(.primaryBlue)
                }
                
                Button(action: {}) {
                    Text("Price details")
                        .font(.appFont(style: .b4Medium))
                        .foregroundColor(.primaryBlue)
                }
                
                Button(action: {}) {
                    Text("Edit details")
                            .font(.appFont(style: .b4Medium))
                        .foregroundColor(.primaryBlue)
                }
            }
            
            // Price
            HStack {
                Spacer()
                Text(hotel.price)
                    .font(.appFont(style: .b4Medium))
                    .foregroundColor(.primaryText)
            }
            
            // Remove Button - Centered and wide
            Button(action: onRemove) {
                HStack(spacing: 4) {
                    Text("Remove")
                            .font(.appFont(style: .b4Medium))
                    Image(systemName: "xmark")
                        .font(.system(size: 12))
                }
                            .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.removeBackground)
                .cornerRadius(8)
            }
        }
        .padding(20)
        .background(Color.appWhite)
        .cornerRadius(12)
    }
}

struct ActivityCardView: View {
    let activity: Activity
    let onRemove: () -> Void
    
    // Local image array for activities
    private let activityImages = ["activities-image", "plant-image", "bahamas-family-trip", "family-trip", "plan-a-trip"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Image Carousel
            ImageCarouselView(imageNames: activityImages)
            
            // Activity Name
            Text(activity.name)
                .font(.appFont(style: .b3SemiBold))
                .foregroundColor(.primaryText)

                // Description
            if !activity.description.isEmpty {
                Text(activity.description)
                    .font(.appFont(style: .b4Medium))
                    .foregroundColor(.tertiaryText)
                    .lineLimit(3)
            }
            
            // Location
            if !activity.location.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle")
                        .font(.system(size: 14))
                    Text(activity.location)
                        .font(.appFont(style: .b4Medium))
                }
                .foregroundColor(.tertiaryText)
            }
            
            // Rating & Duration
            HStack(spacing: 16) {
                if let rating = activity.rating {
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                        Text("\(rating, specifier: "%.1f") (\(activity.reviewCount))")
                            .font(.appFont(style: .b4Medium))
                            .foregroundColor(.primaryText)
                    }
                }
                
                if !activity.duration.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.system(size: 14))
                        Text(activity.duration)
                            .font(.appFont(style: .b4Medium))
                    }
                    .foregroundColor(.primaryText)
                }
            }
            
            // Time & Date
            if !activity.time.isEmpty && !activity.date.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    Button(action: {}) {
                        Text("Change time")
                            .font(.appFont(style: .b4Medium))
                            .foregroundColor(.primaryBlue)
                    }
                    
                    Text("\(activity.time) on \(activity.date)")
                        .font(.appFont(style: .b4Medium))
                        .foregroundColor(.primaryText)
                    
                    if !activity.dayInfo.isEmpty {
                        Text(activity.dayInfo)
                            .font(.appFont(style: .b4Medium))
                            .foregroundColor(.tertiaryText)
                    }
                }
            }
            
            // Action Links
            HStack(spacing: 8) {
                Button(action: {}) {
                    Text("Activity details")
                        .font(.appFont(style: .b4Medium))
                        .foregroundColor(.primaryBlue)
                }
                
                Button(action: {}) {
                    Text("Price details")
                        .font(.appFont(style: .b4Medium))
                        .foregroundColor(.primaryBlue)
                }
                
                Button(action: {}) {
                    Text("Edit details")
                        .font(.appFont(style: .b4Medium))
                        .foregroundColor(.primaryBlue)
                }
            }
            
            // Price
                    HStack {
                Spacer()
                Text(activity.price)
                    .font(.appFont(style: .b4Medium))
            .foregroundColor(.primaryText)
            }
            
            // Remove Button - Centered and wide
            Button(action: onRemove) {
                HStack(spacing: 4) {
                    Text("Remove")
                        .font(.appFont(style: .b4Medium))
                    Image(systemName: "xmark")
                        .font(.system(size: 12))
                }
                .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .background(Color.removeBackground)
                    .cornerRadius(8)
                }
            }
            .padding(20)
        .background(Color.appWhite)
        .cornerRadius(12)
    }
}

// MARK: - Models
struct Flight: Identifiable {
    let id = UUID()
    let airline: String
    let flightNumber: String
    let departureTime: String
    let departureDate: String
    let departureCode: String
    let arrivalTime: String
    let arrivalDate: String
    let arrivalCode: String
    let duration: String
    let route: String
    let price: String
}

struct Hotel: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let imageUrls: [String?]
    let rating: Double?
    let reviewCount: Int
    let roomType: String
    let checkInDate: String
    let checkOutDate: String
    let price: String
    let mapUrl: String
    
    init(
        name: String,
        address: String = "",
        imageUrls: [String?] = [],
        rating: Double? = nil,
        reviewCount: Int = 0,
        roomType: String = "",
        checkInDate: String = "",
        checkOutDate: String = "",
        price: String = "",
        mapUrl: String = ""
    ) {
        self.name = name
        self.address = address
        self.imageUrls = imageUrls
        self.rating = rating
        self.reviewCount = reviewCount
        self.roomType = roomType
        self.checkInDate = checkInDate
        self.checkOutDate = checkOutDate
        self.price = price
        self.mapUrl = mapUrl
    }
}

struct Activity: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let location: String
    let imageUrls: [String?]
    let rating: Double?
    let reviewCount: Int
    let duration: String
    let time: String
    let date: String
    let dayInfo: String
    let price: String
    
    init(
        name: String,
        description: String = "",
        location: String = "",
        imageUrls: [String?] = [],
        rating: Double? = nil,
        reviewCount: Int = 0,
        duration: String = "",
        time: String = "",
        date: String = "",
        dayInfo: String = "",
        price: String = ""
    ) {
        self.name = name
        self.description = description
        self.location = location
        self.imageUrls = imageUrls
        self.rating = rating
        self.reviewCount = reviewCount
        self.duration = duration
        self.time = time
        self.date = date
        self.dayInfo = dayInfo
        self.price = price
    }
}

#Preview {
    TripDetailView(
        trip: Trip(
            name: "Bahamas Family Trip",
            destination: "New York, United States of America",
            startDate: "21st March 2024",
            endDate: "21st April 2024",
            duration: 31,
            travelStyle: "Solo"
        )
    )
}
