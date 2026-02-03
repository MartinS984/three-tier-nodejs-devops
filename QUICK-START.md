# 🚀 Three-Tier DevOps App - Quick Start Guide

## 📋 APPLICATION OVERVIEW
A complete three-tier microservices application demonstrating modern DevOps practices:

- **🎨 Frontend Tier**: Static dashboard (port 8080)
- **⚙️ Backend Tier**: Node.js Express API (port 3001)  
- **🗄️ Database Tier**: MongoDB + Admin UI (ports 27017, 8081)
- **🔧 Infrastructure**: Docker containers, ready for Kubernetes

## 🌐 ACCESS URLs

### Primary Access Points:
1. **Main Dashboard**: http://localhost:8080
2. **Backend API Health**: http://localhost:3001/health
3. **Backend Test API**: http://localhost:3001/api/test
4. **MongoDB Admin UI**: http://admin:admin123@localhost:8081

### Alternative URLs:
- MongoDB Admin with embedded credentials: http://admin:admin123@localhost:8081
- Backend through proxy: http://localhost:8080/api/health

## 🛠️ MANAGEMENT COMMANDS

### Docker Compose Commands:
\`\`\`bash
# View all services
docker-compose -f docker-compose.working.yml ps

# View logs (all services)
docker-compose -f docker-compose.working.yml logs -f

# View specific service logs
docker-compose -f docker-compose.working.yml logs backend
docker-compose -f docker-compose.working.yml logs frontend

# Restart services
docker-compose -f docker-compose.working.yml restart

# Stop all services
docker-compose -f docker-compose.working.yml down

# Rebuild and restart
docker-compose -f docker-compose.working.yml up -d --build

# Run comprehensive test
./scripts/final-comprehensive-test.sh
\`\`\`

### Utility Scripts:
\`\`\`bash
# Quick status check
./scripts/check-status.sh

# Test CORS configuration  
./scripts/test-cors-fix.sh

# Final comprehensive test
./scripts/final-comprehensive-test.sh

# Restart everything
./scripts/restart-app.sh
\`\`\`

## 🔧 TROUBLESHOOTING

### If Backend Shows "Failed to fetch":
1. **Check if backend is running**:
   \`\`\`bash
   curl http://localhost:3001/health
   \`\`\`

2. **Check Docker logs**:
   \`\`\`bash
   docker-compose -f docker-compose.working.yml logs backend
   \`\`\`

3. **Restart backend**:
   \`\`\`bash
   docker-compose -f docker-compose.working.yml restart backend
   \`\`\`

4. **Open backend directly** in browser: http://localhost:3001/health

### If MongoDB Admin Shows 401:
- Use credentials: \`admin\` / \`admin123\`
- Or access via: http://admin:admin123@localhost:8081

## 📁 PROJECT STRUCTURE
\`\`\`
three-tier-nodejs-devops/
├── src/
│   ├── backend/                 # Node.js Express backend
│   │   ├── server.js           # Main server file
│   │   ├── package.json        # Dependencies
│   │   └── Dockerfile          # Backend container
│   └── frontend/               # Static frontend
│       ├── dist/               # Compiled frontend
│       ├── nginx.conf          # Nginx configuration
│       └── Dockerfile          # Frontend container
├── docker-compose.working.yml   # Main compose file
├── scripts/                     # Utility scripts
├── k8s/                        # Kubernetes manifests
└── README.md                   # Project documentation
\`\`\`

## 🚀 NEXT STEPS

### Immediate Actions:
1. **Open the dashboard**: http://localhost:8080
2. **Test the API**: http://localhost:3001/health
3. **Access MongoDB Admin**: http://admin:admin123@localhost:8081

### Enhancement Ideas:
- Add user authentication to backend
- Convert frontend to React/Vue.js
- Deploy to Kubernetes
- Set up CI/CD pipeline
- Add monitoring and logging

## 🎉 CONGRATULATIONS!
You have successfully built and deployed a complete three-tier DevOps application! 🚀
