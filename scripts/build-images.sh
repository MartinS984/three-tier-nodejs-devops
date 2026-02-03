#!/bin/bash

set -e

echo "Building Docker images..."

# Build backend
echo "Building backend image..."
docker build -t localhost:5000/backend:latest ./src/backend

# Build frontend
echo "Building frontend image..."
docker build -t localhost:5000/frontend:latest ./src/frontend

# Push to local registry
echo "Pushing images to local registry..."
docker push localhost:5000/backend:latest
docker push localhost:5000/frontend:latest

echo "Images built and pushed successfully!"
