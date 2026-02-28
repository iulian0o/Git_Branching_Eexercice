const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const config = require('./config/config');
const db = require('./config/database');
const routes = require('./routes');

const app = express();

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Request logging middleware
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  next();
});

// API routes
app.use('/api', routes);

// Root endpoint
app.get('/', (req, res) => {
  res.json({
    message: 'Welcome to NodeJS PostgreSQL API',
    environment: config.env,
    version: '1.0.0',
    endpoints: {
      health: '/api/health',
      users: {
        getAll: 'GET /api/users',
        getById: 'GET /api/users/:id',
        create: 'POST /api/users',
        update: 'PUT /api/users/:id',
        delete: 'DELETE /api/users/:id'
      }
    }
  });
});

// 404 handler
app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Route not found'
  });
});

// Error handling middleware
app.use((err, req, res, next) => {
  console.error('Error:', err.stack);
  res.status(500).json({
    success: false,
    error: 'Something went wrong!'
  });
});

// Initialize database and start server
const startServer = async () => {
  try {
    // Initialize database schema
    await db.initDatabase();
    
    // Start listening
    app.listen(config.port, () => {
      console.log('='.repeat(50));
      console.log(`🚀 Server running in ${config.env.toUpperCase()} mode`);
      console.log(`📡 Listening on port ${config.port}`);
      console.log(`🔗 API URL: http://localhost:${config.port}`);
      console.log(`💾 Database: ${config.database.database}`);
      console.log('='.repeat(50));
    });
  } catch (err) {
    console.error('Failed to start server:', err);
    process.exit(1);
  }
};

startServer();

module.exports = app;
