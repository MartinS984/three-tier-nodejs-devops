#!/bin/bash

set -e

ENVIRONMENT=${1:-dev}
NAMESPACE="three-tier-app"

echo "Setting up port forwarding for ${ENVIRONMENT} environment..."

# Kill existing port-forward processes
pkill -f "kubectl port-forward" || true

# Port forward services
kubectl port-forward -n ${NAMESPACE} svc/frontend 80:80 &
kubectl port-forward -n ${NAMESPACE} svc/backend 3001:80 &
kubectl port-forward -n ${NAMESPACE} svc/mongodb 27017:27017 &

if [ "${ENVIRONMENT}" = "dev" ]; then
    kubectl port-forward -n ${NAMESPACE} svc/mongo-express 8081:8081 &
fi

echo "Port forwarding set up successfully!"
echo ""
echo "Access points:"
echo "1. Frontend: http://localhost"
echo "2. Backend API: http://localhost:3001"
echo "3. MongoDB: localhost:27017"
if [ "${ENVIRONMENT}" = "dev" ]; then
    echo "4. MongoDB Express: http://localhost:8081"
fi
echo ""
echo "Press Ctrl+C to stop port forwarding"
wait
