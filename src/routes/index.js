const express = require('express');
const router = express.Router();
const userRoutes = require('./userRoutes');

// Mount user routes
router.use('/users', userRoutes);

// Health check endpoint
router.get('/health', (req, res) => {
  res.status(200).json({
    success: true,
    message: 'API is running',
    environment: process.env.NODE_ENV,
    timestamp: new Date().toISOString()
  });
});

module.exports = router;
