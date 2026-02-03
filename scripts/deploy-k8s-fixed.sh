#!/bin/bash

set -e

ENVIRONMENT=${1:-dev}
NAMESPACE="three-tier-app"

echo "Deploying to ${ENVIRONMENT} environment..."

# Create namespace if it doesn't exist
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

# For local development, we need to set imagePullPolicy to Never
# since we're using locally built images
if [ "${ENVIRONMENT}" = "dev" ]; then
    echo "Creating development deployment with local images..."
    
    # Create config maps
    cat > k8s/overlays/dev/local-patches.yaml << 'LOCALPATCH'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  template:
    spec:
      containers:
      - name: backend
        image: localhost:5000/backend:latest
        imagePullPolicy: Never
        env:
        - name: NODE_ENV
          value: "development"
        - name: MONGODB_URI
          value: "mongodb://admin:admin123@mongodb:27017/devops-app?authSource=admin"
        - name: JWT_SECRET
          value: "dev-secret-key-change-in-production"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  template:
    spec:
      containers:
      - name: frontend
        image: localhost:5000/frontend:latest
        imagePullPolicy: Never
        env:
        - name: VITE_API_URL
          value: "/api/v1"
LOCALPATCH
    
    # Deploy MongoDB
    kubectl apply -n ${NAMESPACE} -f - << 'MONGODB'
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mongodb
spec:
  serviceName: mongodb
  replicas: 1
  selector:
    matchLabels:
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
      - name: mongodb
        image: mongo:6
        ports:
        - containerPort: 27017
        env:
        - name: MONGO_INITDB_ROOT_USERNAME
          value: "admin"
        - name: MONGO_INITDB_ROOT_PASSWORD
          value: "admin123"
        - name: MONGO_INITDB_DATABASE
          value: "devops-app"
        volumeMounts:
        - name: mongodb-data
          mountPath: /data/db
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
  volumeClaimTemplates:
  - metadata:
      name: mongodb-data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
---
apiVersion: v1
kind: Service
metadata:
  name: mongodb
spec:
  selector:
    app: mongodb
  ports:
  - port: 27017
    targetPort: 27017
MONGODB
    
    # Wait for MongoDB to be ready
    echo "Waiting for MongoDB to be ready..."
    kubectl wait -n ${NAMESPACE} --for=condition=ready pod -l app=mongodb --timeout=120s
    
    # Deploy backend
    kubectl apply -n ${NAMESPACE} -f - << 'BACKEND'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: localhost:5000/backend:latest
        imagePullPolicy: Never
        ports:
        - containerPort: 3001
        env:
        - name: NODE_ENV
          value: "development"
        - name: MONGODB_URI
          value: "mongodb://admin:admin123@mongodb:27017/devops-app?authSource=admin"
        - name: JWT_SECRET
          value: "dev-secret-key-change-in-production"
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3001
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 3001
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: backend
spec:
  selector:
    app: backend
  ports:
  - port: 80
    targetPort: 3001
BACKEND
    
    # Deploy frontend
    kubectl apply -n ${NAMESPACE} -f - << 'FRONTEND'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
      - name: frontend
        image: localhost:5000/frontend:latest
        imagePullPolicy: Never
        ports:
        - containerPort: 80
        env:
        - name: VITE_API_URL
          value: "/api/v1"
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "250m"
---
apiVersion: v1
kind: Service
metadata:
  name: frontend
spec:
  selector:
    app: frontend
  ports:
  - port: 80
    targetPort: 80
FRONTEND
    
    # Create ingress
    kubectl apply -n ${NAMESPACE} -f - << 'INGRESS'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: main-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
    nginx.ingress.kubernetes.io/ssl-redirect: "false"
spec:
  ingressClassName: nginx
  rules:
  - host: three-tier-app.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend
            port:
              number: 80
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: backend
            port:
              number: 80
INGRESS
    
    # Wait for deployments to be ready
    echo "Waiting for deployments to be ready..."
    kubectl wait -n ${NAMESPACE} --for=condition=available deployment/backend --timeout=300s
    kubectl wait -n ${NAMESPACE} --for=condition=available deployment/frontend --timeout=300s
    
    echo "Deployment completed successfully!"
    echo ""
    echo "To access the application:"
    echo "1. Frontend: http://three-tier-app.local"
    echo "2. Backend API: http://three-tier-app.local/api"
    echo ""
    echo "To view logs:"
    echo "  kubectl logs -n ${NAMESPACE} deployment/backend"
    echo "  kubectl logs -n ${NAMESPACE} deployment/frontend"
else
    echo "Production deployment not implemented yet"
    exit 1
fi
