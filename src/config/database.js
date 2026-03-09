const { Pool } = require('pg');
const config = require('./config');

// Determine connection settings
const isProduction = process.env.NODE_ENV === 'production';

const pool = new Pool({
  // 1. Prioritize the connection string from Render/Environment
  connectionString: process.env.DATABASE_URL || config.database.connectionString,
  
  // 2. Fallback for local dev if you aren't using a connection string there
  ...(process.env.DATABASE_URL ? {} : config.database),

  // 3. SSL is usually required for cloud-hosted databases
  ssl: isProduction ? { rejectUnauthorized: false } : false
});

const initDatabase = async () => {
  const client = await pool.connect();
  try {
    await client.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        username VARCHAR(50) UNIQUE NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        full_name VARCHAR(100),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);
    
    console.log('✓ Database schema initialized');
  } catch (err) {
    console.error('Error initializing database:', err);
    throw err;
  } finally {
    client.release();
  }
};

module.exports = {
  pool,
  initDatabase,
  query: (text, params) => pool.query(text, params)
};
