#!/bin/bash

set -e

echo "Building Docker images..."

# Make sure we're using minikube's Docker daemon
eval $(minikube docker-env)

# Build backend
echo "Building backend image..."
cd src/backend
docker build -t localhost:5000/backend:latest .

# Build frontend
echo "Building frontend image..."
cd ../frontend
docker build -t localhost:5000/frontend:latest .

# Push to local registry
echo "Pushing images to local registry..."
docker push localhost:5000/backend:latest
docker push localhost:5000/frontend:latest

cd ../..

echo "Images built and pushed successfully!"
