import React, { useState, useEffect } from 'react';
import {
  Container,
  Paper,
  Typography,
  Box,
  Button,
  Grid,
  Card,
  CardContent,
  CircularProgress,
  Alert,
} from '@mui/material';
import { useAuth } from '../context/AuthContext';
import { healthService } from '../services/api';

const Dashboard = () => {
  const { user, logout } = useAuth();
  const [healthStatus, setHealthStatus] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    checkHealth();
  }, []);

  const checkHealth = async () => {
    try {
      setLoading(true);
      const response = await healthService.check();
      setHealthStatus(response.data);
      setError('');
    } catch (err) {
      setError('Unable to connect to backend service');
    } finally {
      setLoading(false);
    }
  };

  const handleLogout = () => {
    logout();
    window.location.href = '/login';
  };

  return (
    <Container maxWidth="lg">
      <Box sx={{ mt: 4 }}>
        <Grid container spacing={3}>
          <Grid item xs={12}>
            <Paper elevation={3} sx={{ p: 3 }}>
              <Box display="flex" justifyContent="space-between" alignItems="center">
                <Typography variant="h4">
                  Welcome, {user?.username}!
                </Typography>
                <Button
                  variant="outlined"
                  color="error"
                  onClick={handleLogout}
                >
                  Logout
                </Button>
              </Box>
              <Typography color="textSecondary" sx={{ mt: 1 }}>
                Email: {user?.email} | Role: {user?.role}
              </Typography>
            </Paper>
          </Grid>

          <Grid item xs={12} md={6}>
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom>
                  Backend Service Health
                </Typography>
                
                {loading ? (
                  <Box display="flex" justifyContent="center" py={3}>
                    <CircularProgress />
                  </Box>
                ) : error ? (
                  <Alert severity="error">{error}</Alert>
                ) : healthStatus ? (
                  <Box>
                    <Typography>
                      Status: <span style={{ 
                        color: healthStatus.status === 'OK' ? 'green' : 'red',
                        fontWeight: 'bold'
                      }}>
                        {healthStatus.status}
                      </span>
                    </Typography>
                    <Typography>
                      Service: {healthStatus.service}
                    </Typography>
                    <Typography>
                      Timestamp: {new Date(healthStatus.timestamp).toLocaleString()}
                    </Typography>
                  </Box>
                ) : null}
                
                <Button
                  variant="contained"
                  onClick={checkHealth}
                  sx={{ mt: 2 }}
                  disabled={loading}
                >
                  Check Health
                </Button>
              </CardContent>
            </Card>
          </Grid>

          <Grid item xs={12} md={6}>
            <Card>
              <CardContent>
                <Typography variant="h6" gutterBottom>
                  System Information
                </Typography>
                <Typography>
                  Frontend: React.js with Vite
                </Typography>
                <Typography>
                  Backend: Node.js with Express
                </Typography>
                <Typography>
                  Database: MongoDB
                </Typography>
                <Typography>
                  Containerization: Docker & Kubernetes
                </Typography>
              </CardContent>
            </Card>
          </Grid>
        </Grid>
      </Box>
    </Container>
  );
};

export default Dashboard;
