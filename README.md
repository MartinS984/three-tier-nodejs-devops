# Three-Tier Node.js App with DevOps SDLC

A complete DevOps pipeline project with:
- Frontend: React.js
- Backend: Express.js API
- Database: MongoDB
- Infrastructure: Docker, Kubernetes, CI/CD

## Tech Stack
- Node.js
- React
- Express
- MongoDB
- Docker
- Kubernetes (minikube)
- GitHub Actions
- Nginx

## Project Structure
└── three-tier-nodejs-devops/
    ├── src/
    │   ├── frontend/     # React application
    │   ├── backend/      # Express.js API server
    │   └── api/          # Microservices (optional)
    ├── k8s/             # Kubernetes manifests
    ├── docker-compose/  # Local development
    ├── scripts/         # Build/deploy scripts
    └── tests/           # Test suites

# Three-Tier Node.js App with DevOps SDLC

A complete DevOps pipeline project demonstrating modern software development practices with:
- **Frontend**: React.js with Vite
- **Backend**: Express.js API with MongoDB
- **Infrastructure**: Docker, Kubernetes, CI/CD
- **DevOps**: GitHub Actions, Monitoring, Security Scanning

## 📋 Tech Stack

### Application
- **Frontend**: React 18, Vite, Material-UI, React Router
- **Backend**: Node.js 18, Express.js, MongoDB, JWT Authentication
- **Database**: MongoDB with Mongoose ODM

### Infrastructure
- **Containerization**: Docker, Docker Compose
- **Orchestration**: Kubernetes (minikube), Kustomize
- **CI/CD**: GitHub Actions, Docker Buildx
- **Security**: Trivy vulnerability scanning

### Development
- **Environment**: Windows 11 with WSL2 (Ubuntu)
- **Tools**: VS Code, Docker Desktop, minikube, kubectl
- **Testing**: Jest, Vitest, Supertest

## 🚀 Quick Start

### Prerequisites
- Windows 11 with WSL2 (Ubuntu)
- Docker Desktop with WSL2 integration
- VS Code with Remote - WSL extension
- Git

### Option 1: Docker Compose (Simplest)
```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/three-tier-nodejs-devops.git
cd three-tier-nodejs-devops

# Start all services
docker-compose up -d

# Access the application:
# - Frontend: http://localhost:5173
# - Backend API: http://localhost:3001
# - MongoDB Express: http://localhost:8081
