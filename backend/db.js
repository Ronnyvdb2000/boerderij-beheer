const { Pool } = require('pg');

// DATABASE_URL = Supabase connection string (Project Settings -> Database -> Connection string)
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

module.exports = { pool };
