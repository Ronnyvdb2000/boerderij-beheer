// Voert schema.sql rechtstreeks uit tegen Supabase — vermijdt problemen met de
// web-SQL-editor bij het plakken van heel lange scripts (bv. tabelnamen met een
// apostrof zoals "10 verlies'" kunnen daar verkeerd verwerkt worden door
// automatische haakjes/aanhalingstekens-afsluiting van de browser-editor).
//
// GEBRUIK:
//   1. npm install
//   2. .env-bestand met DATABASE_URL (zie .env.example)
//   3. node run-schema.js

require('dotenv').config();
const fs = require('fs');
const path = require('path');
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

async function main() {
  if (!process.env.DATABASE_URL) {
    console.error('DATABASE_URL ontbreekt in .env');
    process.exit(1);
  }

  const sql = fs.readFileSync(path.join(__dirname, 'schema.sql'), 'utf-8');
  console.log(`schema.sql ingelezen (${sql.length} tekens). Uitvoeren...`);

  try {
    await pool.query(sql);
    console.log('Schema succesvol aangemaakt (alle 125 tabellen).');
  } catch (err) {
    console.error('FOUT bij uitvoeren schema:', err.message);
    process.exitCode = 1;
  } finally {
    await pool.end();
  }
}

main();
