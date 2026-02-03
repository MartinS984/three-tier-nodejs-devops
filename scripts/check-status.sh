#!/bin/bash

echo "=== THREE-TIER APP STATUS CHECK ==="
echo ""

echo "1. Checking Docker containers..."
docker-compose ps

echo ""
echo "2. Testing Backend API..."
if curl -s http://localhost:3001/health > /dev/null; then
    echo "   ✅ Backend is responding"
    curl -s http://localhost:3001/health | python3 -m json.tool
else
    echo "   ❌ Backend is not responding"
fi

echo ""
echo "3. Testing Frontend..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8080 | grep -q "200\|30"; then
    echo "   ✅ Frontend is responding"
else
    echo "   ❌ Frontend is not responding"
fi

echo ""
echo "4. Testing MongoDB Express..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:8081 | grep -q "200\|30"; then
    echo "   ✅ MongoDB Express is responding"
else
    echo "   ❌ MongoDB Express is not responding"
fi

echo ""
echo "=== ACCESS URLs ==="
echo "Frontend:        http://localhost:8080"
echo "Backend API:     http://localhost:3001/health"
echo "Backend Test:    http://localhost:3001/api/test"
echo "MongoDB Admin:   http://localhost:8081"
echo ""
echo "=== DOCKER COMMANDS ==="
echo "View logs:       docker-compose logs -f"
echo "Restart:         docker-compose restart"
echo "Stop:            docker-compose down"
echo "Rebuild:         docker-compose up -d --build"
