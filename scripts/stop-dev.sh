#!/bin/bash

set -e

echo "Stopping development environment..."

# Kill port-forward processes
pkill -f "kubectl port-forward" || true

# Teardown k8s deployment
./scripts/teardown-k8s.sh dev

# Stop minikube
echo "Stopping minikube..."
minikube stop

echo "Development environment stopped!"
