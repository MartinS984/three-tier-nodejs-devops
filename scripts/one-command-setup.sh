#!/bin/bash

set -e

echo "=== ONE COMMAND SETUP ==="
echo "This script will set up everything with minimal complexity"

# Step 1: Start minikube if not running
if ! minikube status | grep -q "Running"; then
    echo "Starting minikube..."
    minikube start --memory=4096 --cpus=4
fi

# Step 2: Enable ingress
minikube addons enable ingress

# Step 3: Use Docker Compose (much simpler!)
echo ""
echo "=== USING DOCKER COMPOSE (SIMPLER) ==="
cd $(dirname "$0")/..

echo "Starting services with Docker Compose..."
docker-compose up -d

echo ""
echo "=== SETUP COMPLETE ==="
echo ""
echo "Services are now running with Docker Compose:"
echo "1. Frontend: http://localhost:5173"
echo "2. Backend API: http://localhost:3001"
echo "3. MongoDB Express UI: http://localhost:8081"
echo ""
echo "To test backend: curl http://localhost:3001/health"
echo "To view logs: docker-compose logs -f"
echo "To stop: docker-compose down"
