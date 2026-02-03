#!/bin/bash

set -e

ENVIRONMENT=${1:-dev}
NAMESPACE="three-tier-app"

echo "Deploying to ${ENVIRONMENT} environment..."

# Load environment variables
if [ -f .env.${ENVIRONMENT} ]; then
    export $(cat .env.${ENVIRONMENT} | xargs)
fi

# Create namespace if it doesn't exist
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

# Deploy using kustomize
kustomize build k8s/overlays/${ENVIRONMENT} | kubectl apply -f -

# Wait for deployments to be ready
echo "Waiting for deployments to be ready..."
kubectl wait --namespace ${NAMESPACE} --for=condition=available --timeout=300s deployment/backend
kubectl wait --namespace ${NAMESPACE} --for=condition=available --timeout=300s deployment/frontend
kubectl wait --namespace ${NAMESPACE} --for=condition=ready --timeout=300s pod -l app=mongodb

echo "Deployment completed successfully!"
echo ""
echo "To access the application:"
echo "1. Frontend: http://localhost"
echo "2. Backend API: http://localhost/api"
echo "3. MongoDB Express (dev only): http://localhost:8081"
echo ""
echo "To view logs:"
echo "  kubectl logs -n ${NAMESPACE} deployment/backend"
echo "  kubectl logs -n ${NAMESPACE} deployment/frontend"
