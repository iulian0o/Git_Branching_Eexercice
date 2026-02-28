const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const config = require('./config/config');
const db = require('./config/database');
const routes = require('./routes');

const app = express();

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  next();
});

app.use('/api', routes);

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

app.use((req, res) => {
  res.status(404).json({
    success: false,
    error: 'Route not found'
  });
});

app.use((err, req, res, next) => {
  console.error('Error:', err.stack);
  res.status(500).json({
    success: false,
    error: 'Something went wrong!'
  });
});

const startServer = async () => {
  try {
    await db.initDatabase();
    
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
