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

# Install dependencies
echo "Installing dependencies..."

# Update package list
sudo apt-get update

# Install curl, git, etc.
sudo apt-get install -y curl git wget unzip

# Install Node.js 18 if not installed
if ! command -v node &> /dev/null; then
    echo "Installing Node.js 18..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# Install Docker if not installed
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
fi

# Install Docker Compose if not installed
if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# Install kubectl if not installed
if ! command -v kubectl &> /dev/null; then
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
fi

# Install minikube if not installed
if ! command -v minikube &> /dev/null; then
    echo "Installing minikube..."
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
fi

# Install Helm if not installed
if ! command -v helm &> /dev/null; then
    echo "Installing Helm..."
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# Install kustomize if not installed
if ! command -v kustomize &> /dev/null; then
    echo "Installing kustomize..."
    curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
    sudo mv kustomize /usr/local/bin/
fi

# Start minikube
echo "Starting minikube..."
if [ "$IS_WSL" = true ]; then
    # WSL2 specific setup
    minikube config set driver docker
    minikube start --memory=4096 --cpus=4
else
    minikube start --memory=4096 --cpus=4
fi

# Enable ingress addon
minikube addons enable ingress

# Create namespace
kubectl create namespace three-tier-app --dry-run=client -o yaml | kubectl apply -f -

# Install Nginx Ingress Controller
echo "Installing Nginx Ingress Controller..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/cloud/deploy.yaml

# Wait for ingress controller to be ready
echo "Waiting for Nginx Ingress Controller to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=120s

# Set up local Docker registry
echo "Setting up local Docker registry..."
docker run -d -p 5000:5000 --name registry registry:2

# Update /etc/hosts for local development
echo "Updating /etc/hosts..."
sudo bash -c 'echo "127.0.0.1 localhost three-tier-app.local" >> /etc/hosts'

echo ""
echo "Development environment setup completed!"
echo ""
echo "Next steps:"
echo "1. Start minikube dashboard: minikube dashboard"
echo "2. Build and push images: ./scripts/build-images.sh"
echo "3. Deploy to local k8s: ./scripts/deploy-k8s.sh dev"
echo "4. Port forward: ./scripts/port-forward.sh dev"
echo ""
echo "To access the application:"
echo "- Frontend: http://three-tier-app.local"
echo "- Backend API: http://three-tier-app.local/api"
echo "- Minikube dashboard: minikube dashboard"
