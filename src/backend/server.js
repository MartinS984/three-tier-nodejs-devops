const express = require('express');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3001;

// Enable CORS for all origins (for development)
app.use(cors({
    origin: ['http://localhost:8080', 'http://localhost:3001', 'http://localhost:5173'],
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true
}));

// Middleware
app.use(express.json());

// Health endpoint
app.get('/health', (req, res) => {
    console.log('Health check requested from:', req.headers.origin || req.headers.host);
    res.json({ 
        status: 'OK', 
        timestamp: new Date().toISOString(),
        service: 'backend',
        environment: process.env.NODE_ENV || 'development',
        cors: 'enabled'
    });
});

// Test endpoint
app.get('/api/test', (req, res) => {
    res.json({ 
        message: 'Backend API is working!',
        success: true,
        data: { 
            example: 'This is test data',
            timestamp: new Date().toISOString()
        }
    });
});

// Root endpoint
app.get('/', (req, res) => {
    res.json({
        message: 'Welcome to Three-Tier DevOps Backend API',
        version: '1.0.0',
        endpoints: {
            health: '/health',
            test: '/api/test',
            docs: 'Coming soon...'
        },
        cors: 'enabled'
    });
});

// Handle preflight requests
app.options('*', cors());

// Start server
app.listen(PORT, () => {
    console.log(`✅ Backend server running on port ${PORT}`);
    console.log(`📊 Health check available at http://localhost:${PORT}/health`);
    console.log(`🌐 CORS enabled for: localhost:8080, localhost:3001, localhost:5173`);
});

// Handle uncaught errors
process.on('uncaughtException', (err) => {
    console.error('Uncaught Exception:', err);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});
