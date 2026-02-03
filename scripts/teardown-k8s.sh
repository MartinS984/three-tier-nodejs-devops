#!/bin/bash

set -e

ENVIRONMENT=${1:-dev}
NAMESPACE="three-tier-app"

echo "Tearing down ${ENVIRONMENT} environment..."

# Delete using kustomize
kustomize build k8s/overlays/${ENVIRONMENT} | kubectl delete -f -

# Delete namespace if empty
kubectl delete namespace ${NAMESPACE} --ignore-not-found=true

echo "Teardown completed successfully!"
