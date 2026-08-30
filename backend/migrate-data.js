// Eenmalig migratiescript: laadt alle geëxporteerde CSV-bestanden (map ./data) in Supabase/Postgres.
//
// GEBRUIK:
//   1. npm install
//   2. Voer eerst schema.sql uit in de Supabase SQL Editor (maakt alle 125 tabellen aan).
//   3. Zet DATABASE_URL in een .env-bestand (zie .env.example).
//   4. node migrate-data.js
//
// Gebruikt Postgres' COPY-commando (via pg-copy-streams) — veel sneller dan losse
// INSERT-statements, nodig omdat sommige tabellen (bv. "13 voeders degrave") ruim
// 100.000 rijen bevatten.
//
// Het script kan opnieuw gedraaid worden op een tabel die nog leeg is; als een tabel al
// rijen bevat, wordt die overgeslagen (zo raak je niet per ongeluk gedupliceerd).

require('dotenv').config();
const fs = require('fs');
const path = require('path');
const { Pool } = require('pg');
const copyFrom = require('pg-copy-streams').from;
const tables = require('./tables-config.json');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

function quote(id) {
  return '"' + String(id).replace(/"/g, '""') + '"';
}

function csvBestandsnaam(tableName) {
  return tableName.replace(/ /g, '_').replace(/'/g, '').replace(/\//g, '_') + '.csv';
}

async function tabelIsLeeg(client, tableName) {
  const res = await client.query(`SELECT COUNT(*) FROM ${quote(tableName)}`);
  return Number(res.rows[0].count) === 0;
}

async function laadTabel(client, table) {
  const bestandsnaam = csvBestandsnaam(table.name);
  const csvPad = path.join(__dirname, 'data', bestandsnaam);

  if (!fs.existsSync(csvPad)) {
    console.log(`  overgeslagen (geen CSV-bestand gevonden: ${bestandsnaam})`);
    return;
  }

  if (!(await tabelIsLeeg(client, table.name))) {
    console.log('  overgeslagen (tabel bevat al data)');
    return;
  }

  // Kolommen die effectief in de CSV staan = alle kolommen behalve een eventuele
  // synthetische row_id (die bestond niet in Access en staat dus niet in de CSV).
  const csvKolommen = table.columns
    .filter(c => !(table.syntheticPk && c.name === 'row_id'))
    .map(c => c.name);

  const kolomLijst = csvKolommen.map(quote).join(', ');
  const copySql = `COPY ${quote(table.name)} (${kolomLijst}) FROM STDIN WITH (FORMAT csv, HEADER true, NULL '')`;

  await new Promise((resolve, reject) => {
    const stream = client.query(copyFrom(copySql));
    const fileStream = fs.createReadStream(csvPad);
    fileStream.on('error', reject);
    stream.on('error', reject);
    stream.on('finish', resolve);
    fileStream.pipe(stream);
  });

  const aantalRes = await client.query(`SELECT COUNT(*) FROM ${quote(table.name)}`);
  console.log(`  ${aantalRes.rows[0].count} rijen geladen.`);
}

async function herstelSequence(client, table) {
  // Enkel relevant voor tabellen met een SERIAL-kolom in de primary key
  // (autonumber-kolommen uit Access).
  const serialKolom = table.columns.find(c => /serial/i.test(c.type) || (table.syntheticPk && c.name === 'row_id'));
  if (!serialKolom) return;
  // Bekende eigenaardigheid van Postgres' pg_get_serial_sequence(): het eerste argument
  // (tabelnaam) moet aangehaald worden als een SQL-identifier (nodig voor namen met
  // spaties), maar het tweede argument (kolomnaam) moet juist NIET aangehaald worden —
  // dat wordt altijd letterlijk gelezen. Zie de Postgres-documentatie/mailinglijst hierover.
  await client.query(
    `SELECT setval(pg_get_serial_sequence($1, $2), COALESCE((SELECT MAX(${quote(serialKolom.name)}) FROM ${quote(table.name)}), 1))`,
    [quote(table.name), serialKolom.name]
  );
}

async function main() {
  if (!process.env.DATABASE_URL) {
    console.error('DATABASE_URL ontbreekt in .env');
    process.exit(1);
  }

  const client = await pool.connect();
  try {
    for (const table of tables) {
      console.log(`\n--- ${table.name} ---`);
      await laadTabel(client, table);
      await herstelSequence(client, table);
    }
    console.log('\nMigratie voltooid. Controleer enkele tabellen in het Supabase Table Editor.');
  } catch (err) {
    console.error('\nFOUT tijdens migratie:', err);
    process.exitCode = 1;
  } finally {
    client.release();
    await pool.end();
  }
}

main();
