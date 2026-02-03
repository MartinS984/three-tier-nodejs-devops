#!/bin/bash

set -e

echo "Setting up development environment for Three-Tier DevOps App..."

# Check if running in WSL
if grep -q Microsoft /proc/version; then
    echo "Detected WSL environment"
    IS_WSL=true
else
    IS_WSL=false
fi

# Check if minikube is already running
if ! minikube status | grep -q "Running"; then
    echo "Starting minikube..."
    minikube start --memory=4096 --cpus=4
    minikube addons enable ingress
else
    echo "Minikube is already running"
fi

# Enable ingress addon if not already enabled
if ! minikube addons list | grep -q "ingress.*enabled"; then
    echo "Enabling ingress addon..."
    minikube addons enable ingress
else
    echo "Ingress addon is already enabled"
fi

# Create namespace
echo "Creating namespace..."
kubectl create namespace three-tier-app --dry-run=client -o yaml | kubectl apply -f -

# Wait for ingress controller to be ready
echo "Waiting for Nginx Ingress Controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# Set up local Docker registry
echo "Setting up local Docker registry..."
if ! docker ps | grep -q registry; then
    docker run -d -p 5000:5000 --name registry registry:2
else
    echo "Local registry is already running"
fi

# Update /etc/hosts for local development
echo "Updating /etc/hosts..."
if ! grep -q "three-tier-app.local" /etc/hosts; then
    sudo bash -c 'echo "$(minikube ip) three-tier-app.local" >> /etc/hosts'
else
    echo "Host entry already exists"
fi

# Set Docker to use minikube's Docker daemon
eval $(minikube docker-env)

echo ""
echo "Development environment setup completed!"
echo ""
echo "Minikube IP: $(minikube ip)"
echo "To access the application after deployment:"
echo "- Frontend: http://three-tier-app.local"
echo "- Backend API: http://three-tier-app.local/api"
echo ""
echo "Next steps:"
echo "1. Build images: ./scripts/build-images.sh"
echo "2. Deploy to k8s: ./scripts/deploy-k8s.sh dev"
echo "3. Port forward: ./scripts/port-forward.sh dev"
echo "4. Dashboard: minikube dashboard"
