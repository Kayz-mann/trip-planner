# TripPlanner

A SwiftUI application for planning and managing trips. This project was built to explore modern iOS development patterns, API integration, and creating a smooth user experience for trip planning.

## What This App Does

TripPlanner lets users create, view, and manage their travel plans. You start by selecting a destination city, picking travel dates, and filling in trip details. Once created, trips appear in a scrollable list where you can tap to view full details. Inside each trip, you can manage flights, hotels, and activities with an interactive card-based interface.

## Screenshots

### App Screenshots

<img src="TripPlanner/screenshots/Simulator Screenshot - iPhone 17 Pro - 2025-12-14 at 14.30.43.png" alt="Home Screen" width="300">

<img src="TripPlanner/screenshots/Simulator Screenshot - iPhone 17 Pro - 2025-12-14 at 14.30.54.png" alt="Trip Detail" width="300">

<img src="TripPlanner/screenshots/Simulator Screenshot - iPhone 17 Pro - 2025-12-14 at 14.31.04.png" alt="Trip Planning" width="300">

## The Journey

### Starting Point

The app began as a single-screen experience focused on the core trip creation flow. The main screen features a hero image at the top, an action card for planning trips that overlaps the image, and a section below showing all your trips.

### Building the Core Flow

The first challenge was getting the trip creation flow right. Users need to:

1. Select a destination city from a list
2. Pick start and end dates using a custom calendar
3. Fill in trip details like name, travel style, and description
4. See their new trip appear in the list immediately

I implemented this with multiple sheets that present over the main view. The city picker shows a list of countries and cities with map pin icons. The date picker uses a custom calendar component that lets users select date ranges visually. The create trip form pre-fills with the selected city and dates, then asks for the remaining details.

### API Integration Challenges

Initially, I planned to use Beeceptor as a mock API service. However, the free tier only allows two rules, which meant I could only set up GET and POST endpoints. This limitation meant I couldn't implement full CRUD operations like updating or deleting individual trips.

To work around this, I set up a local mock API server using json-server. This runs on localhost:3000 and provides full REST API functionality for development and testing. The app can switch between Beeceptor (for production-like testing) and the local server (for full feature development) by changing the base URL in APIConfiguration.swift.

The current setup uses Beeceptor at `https://trip-planner.free.beeceptor.com/api/trips` for GET and POST operations. The local mock server lives in the `mock-api` directory and can be started with the provided shell script.

### Trip Detail View

The trip detail screen became the most complex part of the app. It needed to show:

- A header with back navigation
- Trip overview card with image, dates, and action buttons
- Three planning cards for Activities, Hotels, and Flights
- Expandable itinerary sections for each category

The tricky part was implementing the card flip animations. Each itinerary section (Flights, Hotels, Activities) can be in two states: empty or filled. When you click "Add", the card flips to show detailed information. When you click "Remove", it flips back to the empty state. This uses SwiftUI's animation system with spring transitions for smooth flips.

The filled state cards show mock data that's stored as constants in the view. This keeps the implementation simple while still demonstrating the full UI. The data includes flight details with airline information, hotel cards with image carousels, and activity cards with ratings and descriptions.

### Image Handling

Remote images needed proper caching and loading states. I built a CachedAsyncImage component that uses an actor-based cache to store downloaded images. This prevents re-downloading the same images and provides loading indicators and error states. The component is used throughout the app wherever remote images are displayed.

### State Management

The app uses a combination of @State, @StateObject, and @Binding for state management. HomeView manages the trip list through TripListViewModel, which handles API calls and loading states. The trip creation flow uses local @State variables that get passed down to child views through bindings.

For the trip detail view, each itinerary section maintains its own state for whether it's expanded and whether it has content. The flip animations are controlled by boolean flags that trigger when add or remove actions occur.

## User Workflow

### Creating a Trip

1. Open the app to see the home screen with the hero image and action card
2. Tap "Where to" to open the city picker sheet
3. Select a city from the list (cities are displayed with country codes and map pin icons)
4. Tap the start date field to open the date range picker
5. Select start and end dates on the calendar
6. Tap "Create a Trip" button
7. If any field is missing, an alert appears asking to fill trip information
8. Once validated, the create trip form sheet appears with pre-filled city and dates
9. Enter trip name, select travel style, and optionally add a description
10. Submit the form to create the trip via API
11. The trip list refreshes and shows the new trip at the top

### Viewing Trip Details

1. Scroll through the "Your Trips" section on the home screen
2. Tap any trip card to navigate to the detail view
3. The detail view shows trip overview with image, dates, and action buttons
4. Scroll down to see planning cards for Activities, Hotels, and Flights
5. Tap any itinerary section header to expand or collapse it
6. In an empty state, tap "Add" to flip the card and see mock data
7. In a filled state, tap "Remove" to flip back to empty state

### Managing Itinerary Items

The itinerary sections work independently. Each one (Flights, Hotels, Activities) can be in an empty or filled state. The state is local to the view and doesn't persist - it's purely for demonstrating the UI interactions. When you add an item, it shows mock data. When you remove it, the card flips back to empty.

## Technical Decisions

### Why SwiftUI

The entire app is built with SwiftUI for modern declarative UI development. This made it easier to create the complex layouts, animations, and state management needed for the trip planning interface.

### Single Screen Architecture

I removed the bottom tab navigation to keep the app focused on a single main screen. This simplifies the navigation flow and keeps users focused on the core trip planning experience.

### Custom Components

Several custom components were built to match the design:

- CachedAsyncImage for optimized image loading
- DateRangePickerView with custom calendar
- CityPickerView with country/city list
- PlanningCardView for the itinerary planning cards
- ItinerarySectionView for expandable sections with flip animations

### API Service Pattern

The APIService uses a singleton pattern and handles all network requests. It's configured through APIConfiguration which allows switching between Beeceptor and local mock server. The service handles JSON encoding/decoding and error handling.

## Use Cases

### Primary Use Case: Quick Trip Creation

A user wants to quickly plan a weekend trip. They open the app, select a nearby city, pick dates for next weekend, fill in basic details, and create the trip. The trip appears in their list immediately.

### Use Case: Browsing Existing Trips

A user has several trips planned and wants to review them. They scroll through the trip list on the home screen, seeing destination images, dates, and travel styles. They can tap any trip to see full details.

### Use Case: Planning Trip Details

A user opens a trip detail view and wants to add flights, hotels, and activities. They expand each itinerary section, add items to see what the filled state looks like, and remove them if needed. The card flip animations provide visual feedback for these actions.

## Workarounds and Limitations

### Beeceptor Two-Rule Limit

The free tier of Beeceptor only allows two API rules. This means only GET and POST endpoints are available. To work around this, I created a local mock API server using json-server that provides full CRUD operations. The app can switch between the two by changing the base URL.

### Date Format Handling

The API expects dates in "yyyy-MM-dd" format, but the UI displays dates in a more readable format like "19th April 2024". The DateHelper utility handles conversions between these formats and calculates trip durations.

### Image Caching

Since remote images are used throughout the app, I implemented a custom caching solution using Swift actors. This ensures images are downloaded once and reused, improving performance and reducing network usage.

### Local State for Itinerary Items

Due to the free tier API limitations, all itinerary item management (flights, hotels, activities) is handled through local state manipulation. When you click "Add" on an empty itinerary card, it populates local @State arrays with mock data constants. When you click "Remove", it clears those arrays. This means:

- No API calls are made for adding/removing flights, hotels, or activities
- The state is purely local to the TripDetailView
- Changes don't persist between app sessions
- This was a deliberate workaround to demonstrate the UI without needing additional API endpoints

The mock data is stored as constants in TripDetailView and provides realistic examples of what the filled states would look like with real data.

## Project Structure

- `Views/SwiftUI/` - All SwiftUI views including HomeView, TripDetailView, and various picker views
- `Views/UIKit/` - UIKit view controllers demonstrating programmatic UIKit patterns (CreateTripViewController, TripListViewController)
- `ViewModels/` - View models for managing state and API calls
- `Models/` - Data models like Trip, Flight, Hotel, Activity
- `Services/` - APIService for network requests
- `Components/` - Reusable components like CachedAsyncImage, AppTextField, AppButton, AppCard
- `Utilities/` - Helper functions like DateHelper
- `DesignSystem/` - Colors, fonts, and design tokens
- `Configuration/` - API configuration and environment settings
- `mock-api/` - Local mock API server setup with json-server

## Technology Coverage

### SwiftUI

The main app is built entirely with SwiftUI, demonstrating modern declarative UI patterns:

- Complex animations and transitions
- State management with @State, @StateObject, @Binding
- Navigation with NavigationStack
- Custom reusable components

### UIKit

The project includes UIKit view controllers in `Views/UIKit/` that demonstrate programmatic UIKit patterns:

- `CreateTripViewController` - Programmatic form with Auto Layout
- `TripListViewController` - UITableView with Combine bindings

These UIKit implementations showcase:

- Programmatic UI construction (no storyboards)
- Auto Layout constraints
- Combine for reactive programming
- MVVM architecture with UIKit

While the main app flow uses SwiftUI, these UIKit views are available as reference implementations and can be integrated if needed.

## Running the App

1. Open the project in Xcode
2. Select your target device or simulator
3. Build and run the project
4. The app will fetch trips from the configured API endpoint on launch

## Using the Local Mock API

If you want to use the local mock API server instead of Beeceptor:

1. Install json-server: `npm install -g json-server`
2. Navigate to the mock-api directory
3. Run `./start-server.sh` or manually: `json-server --watch db.json --port 3000 --routes routes.json`
4. Update `APIConfiguration.swift` to use `http://localhost:3000/api/trips`
5. For iOS Simulator, use `localhost`. For physical devices, use your Mac's IP address

## Current API Endpoint

The app is currently configured to use Beeceptor:

- Base URL: `https://trip-planner.free.beeceptor.com/api/trips`
- Available operations: GET (fetch all trips), POST (create trip)
- Limited to two rules on free tier

### What's Not Implemented

Because of the free tier limitation, the following operations are not implemented in the app:

- `GET /api/trips/:id` - Fetch single trip by ID (not used)
- `PUT /api/trips/:id` - Update trip (code exists but not used in SwiftUI views)
- `PATCH /api/trips/:id` - Partially update trip (code exists but not used)
- `DELETE /api/trips/:id` - Delete trip (code exists but not used)

Instead, all trip data manipulation beyond creating and viewing is handled through local state. The itinerary items (flights, hotels, activities) in TripDetailView are managed entirely with @State variables and mock data constants.

## Future Considerations

- Implement full CRUD operations when API limitations are removed
- Add persistence for itinerary item states
- Integrate real flight, hotel, and activity booking APIs
- Add trip sharing and collaboration features
- Implement offline support with local data persistence
