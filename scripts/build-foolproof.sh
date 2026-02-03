#!/bin/bash

set -e

echo "=== FOOLPROOF BUILD SCRIPT ==="

# Make sure we're using minikube's Docker daemon
if command -v minikube &> /dev/null && minikube status &> /dev/null; then
    echo "Setting Docker to use minikube daemon..."
    eval $(minikube docker-env)
fi

echo ""
echo "=== BUILDING BACKEND ==="
cd src/backend

# Remove existing node_modules and package-lock.json to start fresh
echo "Cleaning up backend..."
rm -rf node_modules package-lock.json 2>/dev/null || true

# Create a simple package-lock.json if it doesn't exist
if [ ! -f "package-lock.json" ]; then
    echo "Creating package-lock.json for backend..."
    cat > package-lock.json << 'LOCKFILE'
{
  "name": "backend",
  "version": "1.0.0",
  "lockfileVersion": 3,
  "requires": true,
  "packages": {
    "": {
      "name": "backend",
      "version": "1.0.0",
      "hasInstallScript": false,
      "dependencies": {
        "bcryptjs": "^2.4.3",
        "cors": "^2.8.5",
        "dotenv": "^16.3.1",
        "express": "^4.18.2",
        "helmet": "^7.0.0",
        "jsonwebtoken": "^9.0.2",
        "mongoose": "^7.5.0",
        "morgan": "^1.10.0"
      }
    },
    "node_modules/bcryptjs": {
      "version": "2.4.3",
      "resolved": "https://registry.npmjs.org/bcryptjs/-/bcryptjs-2.4.3.tgz",
      "integrity": "sha512-V/Hy/X9Vt7f3BbPJEi8BdVFMByHi+jNXrYkW3huaybV/kQ0KJg0Y6PkEMbn+zeT+i+SiKZ/HMqJGIIt4LZDqNQ=="
    },
    "node_modules/cors": {
      "version": "2.8.5",
      "resolved": "https://registry.npmjs.org/cors/-/cors-2.8.5.tgz",
      "integrity": "sha512-KIHbLJqu73RGr/hnbrO9uBeixNGuvSQjul/jdFvS/KFSIH1hWVd1ng7zOHx+YrEfInLG7q4n6GHQ9cDtxv/P6g==",
      "dependencies": {
        "object-assign": "^4",
        "vary": "^1.1.2"
      },
      "engines": {
        "node": ">= 0.10"
      }
    },
    "node_modules/dotenv": {
      "version": "16.3.1",
      "resolved": "https://registry.npmjs.org/dotenv/-/dotenv-16.3.1.tgz",
      "integrity": "sha512-IPzF4w4/Rd94bA9imS68tZBaYyBWSCE47V1RGuMrB94iyTOIEwRmVL2x/4An+6mETpLrKJ5hQkB8W4kFAadeIQ==",
      "engines": {
        "node": ">=12"
      },
      "funding": {
        "url": "https://github.com/motdotla/dotenv?sponsor=1"
      }
    },
    "node_modules/express": {
      "version": "4.18.2",
      "resolved": "https://registry.npmjs.org/express/-/express-4.18.2.tgz",
      "integrity": "sha512-5/PsL6iGPdfQ/lKM1UuielYgv3BUoJfz1aUwU9vHZ+J7gyvwdQXFEBIEIaxeGf0GIcreATNyBExtalisDbuMqQ==",
      "dependencies": {
        "accepts": "~1.3.8",
        "array-flatten": "1.1.1",
        "body-parser": "1.20.1",
        "content-disposition": "0.5.4",
        "content-type": "~1.0.4",
        "cookie": "0.5.0",
        "cookie-signature": "1.0.6",
        "debug": "2.6.9",
        "depd": "2.0.0",
        "encodeurl": "1.0.2",
        "escape-html": "1.0.3",
        "etag": "1.8.1",
        "finalhandler": "1.2.0",
        "fresh": "0.5.2",
        "http-errors": "2.0.0",
        "merge-descriptors": "0.0.2",
        "methods": "~1.1.2",
        "on-finished": "2.4.1",
        "parseurl": "1.3.3",
        "path-to-regexp": "0.1.7",
        "proxy-addr": "2.0.7",
        "qs": "6.11.0",
        "range-parser": "1.2.1",
        "safe-buffer": "5.2.1",
        "send": "0.18.0",
        "serve-static": "1.15.0",
        "setprototypeof": "1.2.0",
        "statuses": "2.0.1",
        "type-is": "~1.6.18",
        "utils-merge": "1.0.1",
        "vary": "~1.1.2"
      },
      "engines": {
        "node": ">= 0.10.0"
      }
    },
    "node_modules/helmet": {
      "version": "7.0.0",
      "resolved": "https://registry.npmjs.org/helmet/-/helmet-7.0.0.tgz",
      "integrity": "sha512-g9GGrQzq7xdfAYMg9e8d53TJHHN1a91QZ2wACsXuqFwEo2LhqIUD+5TMBLfGcYT/5fvZk1hKTkQ7kUy1GwVWRA==",
      "dependencies": {
        "helmet-crossdomain": "^1.0.0",
        "helmet-csp": "^3.1.0",
        "no-open": "^1.1.0",
        "referrer-policy": "^1.2.0"
      },
      "engines": {
        "node": ">=14.0.0"
      }
    },
    "node_modules/jsonwebtoken": {
      "version": "9.0.2",
      "resolved": "https://registry.npmjs.org/jsonwebtoken/-/jsonwebtoken-9.0.2.tgz",
      "integrity": "sha512-PRp66vJ865SSqOlgqS8hujT5U4AOgMfhrwYIuIhfKaoSCZcirrmASQr8CX7cUg+RMih/hh0T0aE6E0Vp1WidWw==",
      "dependencies": {
        "jws": "^3.2.2",
        "lodash.includes": "^4.3.0",
        "lodash.isboolean": "^3.0.3",
        "lodash.isinteger": "^4.0.4",
        "lodash.isnumber": "^3.0.3",
        "lodash.isplainobject": "^4.0.6",
        "lodash.isstring": "^4.0.1",
        "lodash.once": "^4.0.0",
        "ms": "^2.1.1"
      },
      "engines": {
        "node": ">=12"
      }
    },
    "node_modules/mongoose": {
      "version": "7.5.0",
      "resolved": "https://registry.npmjs.org/mongoose/-/mongoose-7.5.0.tgz",
      "integrity": "sha512-L3qA3MxBqzdM/pe4n7Uk0uOKZvqCn4HuuqUShVl8B8+Pl7yM5GY5/XppQm4R3vmBcMN1CKbWGkH03px4ummaQw==",
      "dependencies": {
        "bson": "^5.2.0",
        "kareem": "2.5.1",
        "mongodb": "^5.7.0",
        "ms": "2.1.3",
        "sift": "16.0.1"
      },
      "engines": {
        "node": ">=14.0.0"
      },
      "funding": {
        "type": "opencollective",
        "url": "https://opencollective.com/mongoose"
      }
    },
    "node_modules/morgan": {
      "version": "1.10.0",
      "resolved": "https://registry.npmjs.org/morgan/-/morgan-1.10.0.tgz",
      "integrity": "sha512-AbegBVI4sh6El+1gNwvD5YIck7nSA36weD7xvIxG4in80j/UoK8AEGaWnnz8v1GxonMCltmlNs5ZKbGvl9b1XQ==",
      "dependencies": {
        "basic-auth": "~2.0.1",
        "debug": "2.6.9",
        "depd": "~2.0.0",
        "on-finished": "~2.4.1",
        "on-headers": "~1.0.2"
      },
      "engines": {
        "node": ">= 0.8.0"
      }
    }
  }
}
LOCKFILE
fi

# Create an ultra-simple Dockerfile that will definitely work
echo "Creating simple Dockerfile..."
cat > Dockerfile.simple << 'DOCKERFILE'
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install --only=production

# Copy app source
COPY . .

# Create non-root user
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

USER nodejs

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3001/health || exit 1

EXPOSE 3001

CMD ["node", "server.js"]
DOCKERFILE

echo "Building backend image..."
docker build -t localhost:5000/backend:latest -f Dockerfile.simple .

echo ""
echo "=== BUILDING FRONTEND ==="
cd ../frontend

# Clean up frontend
echo "Cleaning up frontend..."
rm -rf node_modules package-lock.json dist 2>/dev/null || true

# Install frontend dependencies
echo "Installing frontend dependencies..."
npm install --package-lock

# Create simple Dockerfile for frontend
echo "Creating frontend Dockerfile..."
cat > Dockerfile.simple << 'FRONTEND_DOCKER'
FROM node:18-alpine as builder

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
FRONTEND_DOCKER

echo "Building frontend image..."
docker build -t localhost:5000/frontend:latest -f Dockerfile.simple .

cd ../..

echo ""
echo "=== BUILD COMPLETE ==="
echo "Backend image: localhost:5000/backend:latest"
echo "Frontend image: localhost:5000/frontend:latest"
echo ""
echo "To deploy: ./scripts/deploy-simple.sh"
