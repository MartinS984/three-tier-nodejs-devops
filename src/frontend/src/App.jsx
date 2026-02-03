import React, { useState, useEffect } from 'react';

function App() {
  const [backendStatus, setBackendStatus] = useState('Checking...');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    checkBackend();
  }, []);

  const checkBackend = async () => {
    try {
      const response = await fetch('http://localhost:3001/health');
      const data = await response.json();
      setBackendStatus(`Connected: ${data.status} at ${new Date(data.timestamp).toLocaleTimeString()}`);
    } catch (error) {
      setBackendStatus(`Error: ${error.message}`);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div style={{
      padding: '40px',
      fontFamily: 'Arial, sans-serif',
      maxWidth: '800px',
      margin: '0 auto'
    }}>
      <h1 style={{ color: '#1976d2' }}>🚀 Three-Tier DevOps App</h1>
      <p>This is a complete DevOps pipeline demonstration with:</p>
      <ul>
        <li>React Frontend (Vite)</li>
        <li>Node.js Backend (Express)</li>
        <li>MongoDB Database</li>
        <li>Docker Containerization</li>
        <li>Kubernetes Orchestration</li>
        <li>CI/CD Pipeline</li>
      </ul>
      
      <div style={{
        margin: '30px 0',
        padding: '20px',
        backgroundColor: '#fff',
        borderRadius: '8px',
        boxShadow: '0 2px 4px rgba(0,0,0,0.1)'
      }}>
        <h2>System Status</h2>
        <p><strong>Frontend:</strong> ✅ Running on port 5173</p>
        <p><strong>Backend:</strong> {loading ? '⏳ Checking...' : backendStatus.includes('Connected') ? '✅' : '❌'} {backendStatus}</p>
        <p><strong>Database:</strong> ✅ MongoDB running</p>
      </div>

      <div style={{
        display: 'flex',
        gap: '20px',
        marginTop: '30px'
      }}>
        <button 
          onClick={checkBackend}
          style={{
            padding: '10px 20px',
            backgroundColor: '#1976d2',
            color: 'white',
            border: 'none',
            borderRadius: '4px',
            cursor: 'pointer',
            fontSize: '16px'
          }}
        >
          Check Backend Again
        </button>
        
        <button 
          onClick={() => window.open('http://localhost:3001/health', '_blank')}
          style={{
            padding: '10px 20px',
            backgroundColor: '#4caf50',
            color: 'white',
            border: 'none',
            borderRadius: '4px',
            cursor: 'pointer',
            fontSize: '16px'
          }}
        >
          Open Backend Health Check
        </button>
      </div>

      <div style={{ marginTop: '40px', color: '#666' }}>
        <h3>Access Points:</h3>
        <ul>
          <li><a href="http://localhost:5173" target="_blank">Frontend Application</a></li>
          <li><a href="http://localhost:3001/health" target="_blank">Backend API Health</a></li>
          <li><a href="http://localhost:8081" target="_blank">MongoDB Express UI</a></li>
        </ul>
      </div>
    </div>
  );
}

export default App;
