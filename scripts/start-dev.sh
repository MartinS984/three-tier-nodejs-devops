#!/bin/bash

set -e

echo "Starting development environment..."

# Start minikube if not running
if ! minikube status | grep -q "Running"; then
    echo "Starting minikube..."
    minikube start
fi

# Set docker env to minikube
eval $(minikube docker-env)

# Build and push images
./scripts/build-images.sh

# Deploy to local k8s
./scripts/deploy-k8s.sh dev

# Port forward services
./scripts/port-forward.sh dev
