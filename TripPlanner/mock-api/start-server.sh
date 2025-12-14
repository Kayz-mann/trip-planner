#!/bin/bash

# Start json-server for TripPlanner mock API
# This creates a local REST API at http://localhost:3000/api/trips

echo "Starting TripPlanner Mock API Server..."
echo "API will be available at: http://localhost:3000/api/trips"
echo ""
echo "Press Ctrl+C to stop the server"
echo ""

json-server --watch db.json --port 3000 --routes routes.json

