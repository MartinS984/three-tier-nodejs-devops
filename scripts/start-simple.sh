#!/bin/bash

set -e

echo "Starting Three-Tier DevOps App..."

# Build images
./scripts/build-simple.sh

# Deploy to Kubernetes
./scripts/deploy-k8s-fixed.sh dev

echo ""
echo "Application deployed successfully!"
echo ""
echo "To access:"
echo "1. Frontend: http://three-tier-app.local"
echo "2. Backend API: http://three-tier-app.local/api"
echo ""
echo "To view logs:"
echo "  kubectl logs -n three-tier-app deployment/backend"
echo "  kubectl logs -n three-tier-app deployment/frontend"
echo ""
echo "To update after code changes:"
echo "1. ./scripts/build-simple.sh"
echo "2. kubectl rollout restart deployment/backend -n three-tier-app"
echo "3. kubectl rollout restart deployment/frontend -n three-tier-app"
