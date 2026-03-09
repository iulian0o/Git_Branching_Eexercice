const dotenv = require('dotenv');
const path = require('path');

const env = process.env.NODE_ENV || 'dev';

if (env !== 'production') {
  const envFile = `.env.${env}`;
  const result = dotenv.config({ path: path.resolve(__dirname, '..', '..', envFile) });

  if (result.error) {
    console.error(`Error loading ${envFile}:`, result.error);
    throw result.error;
  }

  console.log(`✓ Loaded configuration for: ${env.toUpperCase()} environment`);
} else {
  console.log(`✓ Using environment variables for: ${env.toUpperCase()} environment`);
}

module.exports = {
  env: process.env.NODE_ENV,
  port: parseInt(process.env.PORT, 10) || 3000,
  database: {
    host: process.env.DB_HOST,
    port: parseInt(process.env.DB_PORT, 10) || 5432,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    max: parseInt(process.env.DB_MAX_CONNECTIONS, 10) || 50
  }
};
