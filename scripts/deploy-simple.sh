#!/bin/bash

set -e

echo "=== SIMPLE DEPLOYMENT ==="

# Make sure minikube is running
if ! minikube status | grep -q "Running"; then
    echo "Starting minikube..."
    minikube start --memory=4096 --cpus=4
fi

# Set Docker to use minikube
eval $(minikube docker-env)

# Create namespace
kubectl create namespace three-tier-app --dry-run=client -o yaml | kubectl apply -f -

echo ""
echo "=== DEPLOYING MONGODB ==="
kubectl apply -n three-tier-app -f - << 'MONGODB'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongodb
spec:
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
        - name: data
          mountPath: /data/db
      volumes:
      - name: data
        emptyDir: {}
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

echo "Waiting for MongoDB..."
kubectl wait -n three-tier-app --for=condition=ready pod -l app=mongodb --timeout=120s

echo ""
echo "=== DEPLOYING BACKEND ==="
kubectl apply -n three-tier-app -f - << 'BACKEND'
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

echo ""
echo "=== DEPLOYING FRONTEND ==="
kubectl apply -n three-tier-app -f - << 'FRONTEND'
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

echo ""
echo "=== CREATING INGRESS ==="
kubectl apply -n three-tier-app -f - << 'INGRESS'
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
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

echo ""
echo "=== WAITING FOR DEPLOYMENTS ==="
kubectl wait -n three-tier-app --for=condition=available deployment/backend --timeout=180s
kubectl wait -n three-tier-app --for=condition=available deployment/frontend --timeout=180s

echo ""
echo "=== DEPLOYMENT COMPLETE ==="
echo ""
echo "To access the application:"
echo "1. Get the minikube IP: minikube ip"
echo "2. Update /etc/hosts: sudo sed -i '/three-tier-app.local/d' /etc/hosts && sudo bash -c 'echo \"\$(minikube ip) three-tier-app.local\" >> /etc/hosts'"
echo "3. Access at: http://three-tier-app.local"
echo ""
echo "Or use port-forwarding:"
echo "  kubectl port-forward -n three-tier-app svc/frontend 8080:80"
echo "  Then access: http://localhost:8080"
echo ""
echo "To view logs:"
echo "  kubectl logs -n three-tier-app deployment/backend"
echo "  kubectl logs -n three-tier-app deployment/frontend"
