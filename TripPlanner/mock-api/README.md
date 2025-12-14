# Local Mock API Server

This directory contains a local mock API server setup for TripPlanner development and testing. I set this up to work around the Beeceptor free tier limitation of only two API rules.

## Why This Exists

When building the app, I needed a way to test full CRUD operations (Create, Read, Update, Delete) for trips. Beeceptor's free tier only allows two rules, which meant I could only set up GET and POST endpoints. This local server provides all the REST API functionality needed for development.

## Setup

First, install json-server globally if you haven't already:

```bash
npm install -g json-server
```

Then start the server using the provided script:

```bash
./start-server.sh
```

Or run it manually:

```bash
json-server --watch db.json --port 3000 --routes routes.json
```

## API Endpoint

Once running, the server is available at:

- Base URL: `http://localhost:3000/api/trips`

The routes.json file maps `/api/trips` to the `trips` resource in db.json, so the endpoint structure matches what the app expects.

## Available Endpoints

The json-server provides these endpoints, but note that the app only uses GET and POST due to Beeceptor limitations:

- `GET /api/trips` - Fetch all trips (used in app)
- `GET /api/trips/:id` - Fetch a single trip by ID (not used in app)
- `POST /api/trips` - Create a new trip (used in app)
- `PUT /api/trips/:id` - Update an entire trip (not used in app)
- `PATCH /api/trips/:id` - Partially update a trip (not used in app)
- `DELETE /api/trips/:id` - Delete a trip (not used in app)

The app handles trip updates and itinerary item management through local state manipulation instead of API calls.

## Data Storage

All data is stored in `db.json`. When you make changes through the API, json-server updates this file. If you restart the server, it loads the current state of db.json. To reset to initial data, you'd need to restore db.json from version control or manually edit it.

## Testing the API

You can test endpoints using curl:

```bash
# Get all trips
curl http://localhost:3000/api/trips

# Get a specific trip
curl http://localhost:3000/api/trips/1

# Create a new trip
curl -X POST http://localhost:3000/api/trips \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Trip","destination":"Tokyo","start_date":"2024-01-01","end_date":"2024-01-05","duration":4,"travel_style":"Solo"}'

# Update a trip
curl -X PUT http://localhost:3000/api/trips/1 \
  -H "Content-Type: application/json" \
  -d '{"name":"Updated Trip","destination":"Paris","start_date":"2024-02-01","end_date":"2024-02-05","duration":4}'

# Delete a trip
curl -X DELETE http://localhost:3000/api/trips/1
```

## Switching Between APIs

To use the local mock server instead of Beeceptor, update `APIConfiguration.swift`:

```swift
static let baseURL: String = "http://localhost:3000/api/trips"
```

To switch back to Beeceptor:

```swift
static let baseURL: String = "https://trip-planner.free.beeceptor.com/api/trips"
```

## Device Considerations

If you're running the app on an iOS Simulator, `localhost` works fine. If you're testing on a physical device, you'll need to use your Mac's IP address instead of `localhost`. Find your Mac's IP address in System Settings under Network, then use:

```swift
static let baseURL: String = "http://192.168.1.XXX:3000/api/trips"
```

Replace XXX with your actual IP address.

## Initial Data

The `db.json` file contains initial trip data that matches what's configured in Beeceptor. This ensures consistent data whether you're using the local server or the remote endpoint.
