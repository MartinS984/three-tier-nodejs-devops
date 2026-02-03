# 🚀 Three-Tier DevOps Application

[![GitHub last commit](https://img.shields.io/github/last-commit/MartinS984/three-tier-nodejs-devops)](https://github.com/MartinS984/three-tier-nodejs-devops)
[![GitHub repo size](https://img.shields.io/github/repo-size/MartinS984/three-tier-nodejs-devops)](https://github.com/MartinS984/three-tier-nodejs-devops)
[![GitHub license](https://img.shields.io/github/license/MartinS984/three-tier-nodejs-devops)](LICENSE)
[![Docker](https://img.shields.io/badge/Docker-Containerized-2496ED?logo=docker)](https://www.docker.com/)
[![Node.js](https://img.shields.io/badge/Node.js-18.x-339933?logo=node.js)](https://nodejs.org/)
[![MongoDB](https://img.shields.io/badge/MongoDB-6.0-47A248?logo=mongodb)](https://www.mongodb.com/)
[![Three-Tier](https://img.shields.io/badge/Architecture-Three--Tier-blue)]()

A production-ready three-tier microservices application demonstrating modern DevOps practices with complete Docker containerization, ready for Kubernetes deployment.

## 📋 Table of Contents
- [✨ Features](#-features)
- [🏗️ Architecture](#️-architecture)
- [🚀 Quick Start](#-quick-start)
- [📁 Project Structure](#-project-structure)
- [🔧 Installation](#-installation)
- [💻 Usage](#-usage)
- [🧪 Testing](#-testing)
- [📊 Monitoring](#-monitoring)
- [🧰 DevOps Tools](#-devops-tools)
- [🔐 Security](#-security)
- [📈 Performance](#-performance)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [🙏 Acknowledgments](#-acknowledgments)

## ✨ Features

### 🎨 Frontend Tier
- **Modern Dashboard**: Real-time service monitoring and health checks
- **Responsive Design**: Works on desktop and mobile devices
- **Service Controls**: Start/stop and test individual services
- **Live Status Updates**: Automatic polling and status indicators

### ⚙️ Backend Tier
- **RESTful API**: Clean, documented endpoints with proper HTTP methods
- **JWT Ready**: Authentication framework implemented
- **Health Checks**: Comprehensive service health monitoring
- **CORS Enabled**: Cross-origin resource sharing configured
- **Error Handling**: Structured error responses and logging

### 🗄️ Database Tier
- **MongoDB**: NoSQL database with persistent storage
- **Data Models**: User and product schemas with validation
- **Admin Interface**: MongoDB Express web UI for database management
- **Connection Pooling**: Optimized database connections

### 🔧 DevOps Infrastructure
- **Docker Containerization**: All services in isolated containers
- **Docker Compose**: Multi-container orchestration for development
- **Kubernetes Ready**: Complete manifests for production deployment
- **CI/CD Pipeline**: GitHub Actions workflows for automated testing and deployment
- **Health Checks**: Container-level health monitoring
- **Logging**: Structured logging across all services

## 🏗️ Architecture
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│ Presentation │ │ Application │ │ Data │
│ Tier │────▶│ Tier │────▶│ Tier │
│ │ │ │ │ │
│ • Frontend │ │ • Backend API │ │ • MongoDB │
│ • Nginx (8080) │ │ • Node.js(3001)│ │ • Admin UI(8081)│
│ • Dashboard │ │ • Express │ │ • Persistent │
└─────────────────┘ └─────────────────┘ └─────────────────┘


### Technology Stack
| Tier | Technology | Purpose | Port |
|------|------------|---------|------|
| **Frontend** | Nginx, HTML5, JavaScript | User interface, service dashboard | 8080 |
| **Backend** | Node.js, Express, CORS | REST API, business logic | 3001 |
| **Database** | MongoDB, Mongoose ODM | Data persistence, modeling | 27017 |
| **Admin** | MongoDB Express | Database management UI | 8081 |

## 🚀 Quick Start

### Prerequisites
- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/)
- [Node.js 18+](https://nodejs.org/) (for development)
- [Git](https://git-scm.com/)

### One-Command Deployment
```bash
# Clone the repository
git clone https://github.com/MartinS984/three-tier-nodejs-devops.git
cd three-tier-nodejs-devops

# Start all services
docker-compose -f docker-compose.working.yml up -d

# Run comprehensive test
./scripts/final-comprehensive-test.sh

Access Points
🌐 Dashboard: http://localhost:8080

⚙️ Backend API: http://localhost:3001/health

🗄️ Database Admin: http://admin:admin123@localhost:8081

📁 Project Structure
text
three-tier-nodejs-devops/
├── src/                          # Source code
│   ├── backend/                  # Node.js Express backend
│   │   ├── controllers/         # Request handlers
│   │   ├── models/              # MongoDB schemas
│   │   ├── routes/              # API routes
│   │   ├── middleware/          # Express middleware
│   │   ├── tests/               # Unit and integration tests
│   │   ├── server.js           # Entry point
│   │   ├── Dockerfile          # Production container
│   │   └── package.json        # Dependencies
│   └── frontend/                # Static frontend
│       ├── dist/               # Compiled assets
│       ├── nginx.conf          # Nginx configuration
│       └── Dockerfile          # Frontend container
├── k8s/                         # Kubernetes manifests
│   ├── base/                   # Base configurations
│   ├── overlays/               # Environment-specific
│   └── common/                 # Shared resources
├── scripts/                     # Utility scripts
│   ├── restart-app.sh          # Restart all services
│   ├── check-status.sh         # Service status check
│   ├── final-comprehensive-test.sh # Complete test suite
│   └── test-cors-fix.sh        # CORS troubleshooting
├── .github/workflows/          # CI/CD pipelines
│   ├── ci.yml                  # Continuous integration
│   └── cd.yml                  # Continuous deployment
├── docker-compose.working.yml  # Production compose file
├── docker-compose.yml          # Development compose file
├── QUICK-START.md             # Quick reference guide
├── DEPLOYMENT-REPORT.md       # Deployment documentation
└── LICENSE                    # MIT License
🔧 Installation
Development Environment
bash
# 1. Clone repository
git clone https://github.com/MartinS984/three-tier-nodejs-devops.git
cd three-tier-nodejs-devops

# 2. Install dependencies
npm install
cd src/backend && npm install
cd ../frontend && npm install

# 3. Start development services
docker-compose up -d

# 4. Access development endpoints
#    Frontend: http://localhost:5173
#    Backend:  http://localhost:3001
#    MongoDB:  http://localhost:8081
Production Deployment
bash
# Using Docker Compose (recommended for small deployments)
docker-compose -f docker-compose.working.yml up -d

# Using Kubernetes (for production scaling)
kubectl apply -k k8s/overlays/production
💻 Usage
API Endpoints
Method	Endpoint	Description	Authentication
GET	/health	Service health check	None
GET	/api/test	Test endpoint	None
POST	/api/v1/users/register	User registration	None
POST	/api/v1/users/login	User login	None
GET	/api/v1/users/profile	User profile	Required
Example API Calls
bash
# Health check
curl http://localhost:3001/health

# Register a user
curl -X POST http://localhost:3001/api/v1/users/register \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","email":"test@example.com","password":"password123"}'

# Login
curl -X POST http://localhost:3001/api/v1/users/login \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"password123"}'
🧪 Testing
Running Tests
bash
# Run all tests
npm test

# Backend tests only
cd src/backend && npm test

# Frontend tests only
cd src/frontend && npm test

# Integration tests
./scripts/final-comprehensive-test.sh
📊 Monitoring
Built-in Monitoring
bash
# View service logs
docker-compose -f docker-compose.working.yml logs -f

# Check container resources
docker stats

# Monitor API performance
curl -w "@curl-format.txt" -o /dev/null -s http://localhost:3001/health
Health Check Endpoints
http://localhost:3001/health - Backend health

http://localhost:8080/health - Frontend health

http://localhost:8081 - Database admin health

🧰 DevOps Tools
Utility Scripts
Script	Purpose	Usage
restart-app.sh	Restart all services	./scripts/restart-app.sh
check-status.sh	Check service status	./scripts/check-status.sh
final-comprehensive-test.sh	Run complete test suite	./scripts/final-comprehensive-test.sh
test-cors-fix.sh	Debug CORS issues	./scripts/test-cors-fix.sh
🔐 Security
Implemented Security Measures
✅ JWT Authentication: Token-based authentication system

✅ Password Hashing: bcrypt for secure password storage

✅ CORS Configuration: Controlled cross-origin requests

✅ Security Headers: Helmet.js for Express security

✅ Input Validation: Request validation and sanitization

✅ Dependency Scanning: Regular vulnerability checks

✅ Secrets Management: Environment variables for sensitive data

📈 Performance
Optimization Features
Connection Pooling: MongoDB connection reuse

Caching Ready: Redis integration points prepared

Compression: Gzip compression for API responses

Load Balancing: Ready for horizontal scaling

Resource Limits: Container CPU/memory limits configured

🤝 Contributing
We welcome contributions! Please see our Contributing Guidelines for details.

Development Workflow
Fork the repository

Create a feature branch (git checkout -b feature/amazing-feature)

Commit your changes (git commit -m 'Add amazing feature')

Push to the branch (git push origin feature/amazing-feature)

Open a Pull Request

📄 License
This project is licensed under the MIT License - see the LICENSE file for details.

🙏 Acknowledgments
Express.js - Fast, unopinionated web framework for Node.js

MongoDB - The database for modern applications

Docker - Container platform

Kubernetes - Container orchestration

Nginx - High performance web server

GitHub Actions - CI/CD automation

---

### 🏆 Project Stats

**Built with ❤️ by [MartinS984](https://github.com/MartinS984)**

[![Star History Chart](https://api.star-history.com/svg?repos=MartinS984/three-tier-nodejs-devops&type=Date)](https://star-history.com/#MartinS984/three-tier-nodejs-devops&Date)

---

⭐ **Star this repository** if you find it useful!
