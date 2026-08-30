const express = require('express');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const { pool } = require('./db');

const app = express();
app.use(cors());
app.use(express.json());

app.use((req, res, next) => {
  console.log(`${req.method} ${req.path}`);
  next();
});

// Tabelconfiguratie (kolommen, primary key, categorie) — dit is de whitelist.
// Enkel tabellen/kolommen die hierin staan mogen bevraagd worden; zo kan een
// tabelnaam uit de URL nooit gebruikt worden om willekeurige SQL te injecteren.
const TABLES_CONFIG = JSON.parse(fs.readFileSync(path.join(__dirname, 'tables-config.json'), 'utf-8'));
const TABLES_BY_NAME = new Map(TABLES_CONFIG.map(t => [t.name, t]));

function quote(id) {
  return '"' + String(id).replace(/"/g, '""') + '"';
}

function getTableOr404(req, res) {
  const table = TABLES_BY_NAME.get(req.params.table);
  if (!table) {
    res.status(404).json({ error: `Onbekende tabel: ${req.params.table}` });
    return null;
  }
  return table;
}

function valideerKolommen(table, obj) {
  const geldigeNamen = new Set(table.columns.map(c => c.name));
  const fout = Object.keys(obj).find(k => !geldigeNamen.has(k));
  return fout || null;
}

// LOGIN (zelfde eenvoudige patroon als bij Beste)
app.post('/api/login', (req, res) => {
  const { username, password } = req.body;
  const correctUser = process.env.APP_USER || 'admin';
  const correctPass = process.env.APP_PASS || 'changeme';
  if (username === correctUser && password === correctPass) {
    res.json({ success: true });
  } else {
    res.status(401).json({ success: false });
  }
});

// LIJST VAN ALLE TABELLEN + METADATA (voor de navigatie en dynamische formulieren)
app.get('/api/tables', (req, res) => {
  res.json(TABLES_CONFIG.map(t => ({
    name: t.name,
    categorie: t.categorie,
    columns: t.columns,
    primaryKey: t.primaryKey,
    syntheticPk: t.syntheticPk
  })));
});

// RIJEN OPHALEN (met paginering + optioneel zoeken over alle tekstkolommen)
app.get('/api/data/:table', async (req, res) => {
  const table = getTableOr404(req, res);
  if (!table) return;

  const limit = Math.min(Number(req.query.limit) || 50, 500);
  const offset = Number(req.query.offset) || 0;
  const zoek = (req.query.q || '').trim();

  try {
    let whereClause = '';
    let args = [];
    if (zoek) {
      const tekstKolommen = table.columns
        .filter(c => /char|text/i.test(c.type))
        .map(c => quote(c.name));
      if (tekstKolommen.length > 0) {
        whereClause = 'WHERE ' + tekstKolommen.map((c, i) => `${c}::text ILIKE $${i + 1}`).join(' OR ');
        args = tekstKolommen.map(() => `%${zoek}%`);
      }
    }

    const totaalRes = await pool.query(`SELECT COUNT(*) FROM ${quote(table.name)} ${whereClause}`, args);
    const dataSql = `SELECT * FROM ${quote(table.name)} ${whereClause} ORDER BY ${table.primaryKey.map(quote).join(', ')} LIMIT $${args.length + 1} OFFSET $${args.length + 2}`;
    const dataRes = await pool.query(dataSql, [...args, limit, offset]);

    res.json({ rows: dataRes.rows, totaal: Number(totaalRes.rows[0].count) });
  } catch (err) {
    console.error('FOUT bij ophalen data:', err);
    res.status(500).json({ error: err.message });
  }
});

// RIJ TOEVOEGEN
app.post('/api/data/:table', async (req, res) => {
  const table = getTableOr404(req, res);
  if (!table) return;

  const fout = valideerKolommen(table, req.body);
  if (fout) return res.status(400).json({ error: `Onbekende kolom: ${fout}` });

  const kolommen = Object.keys(req.body);
  if (kolommen.length === 0) return res.status(400).json({ error: 'Geen gegevens meegegeven' });

  try {
    const placeholders = kolommen.map((_, i) => `$${i + 1}`).join(', ');
    const sql = `INSERT INTO ${quote(table.name)} (${kolommen.map(quote).join(', ')}) VALUES (${placeholders}) RETURNING *`;
    const result = await pool.query(sql, Object.values(req.body));
    res.json(result.rows[0]);
  } catch (err) {
    console.error('FOUT bij toevoegen:', err);
    res.status(500).json({ error: err.message });
  }
});

// RIJ BIJWERKEN (identificatie via de primary key-kolommen van de tabel)
app.put('/api/data/:table', async (req, res) => {
  const table = getTableOr404(req, res);
  if (!table) return;

  const { sleutel, wijzigingen } = req.body;
  if (!sleutel || !wijzigingen) {
    return res.status(400).json({ error: 'Verwacht { sleutel, wijzigingen } in de request body' });
  }

  const foutSleutel = table.primaryKey.find(k => !(k in sleutel));
  if (foutSleutel) return res.status(400).json({ error: `Ontbrekende sleutelwaarde: ${foutSleutel}` });

  const fout = valideerKolommen(table, wijzigingen);
  if (fout) return res.status(400).json({ error: `Onbekende kolom: ${fout}` });

  const kolommen = Object.keys(wijzigingen);
  if (kolommen.length === 0) return res.status(400).json({ error: 'Geen wijzigingen meegegeven' });

  try {
    const setClause = kolommen.map((k, i) => `${quote(k)} = $${i + 1}`).join(', ');
    const whereClause = table.primaryKey.map((k, i) => `${quote(k)} = $${kolommen.length + i + 1}`).join(' AND ');
    const sql = `UPDATE ${quote(table.name)} SET ${setClause} WHERE ${whereClause} RETURNING *`;
    const args = [...kolommen.map(k => wijzigingen[k]), ...table.primaryKey.map(k => sleutel[k])];
    const result = await pool.query(sql, args);
    if (result.rows.length === 0) return res.status(404).json({ error: 'Rij niet gevonden' });
    res.json(result.rows[0]);
  } catch (err) {
    console.error('FOUT bij bijwerken:', err);
    res.status(500).json({ error: err.message });
  }
});

// RIJ VERWIJDEREN
app.delete('/api/data/:table', async (req, res) => {
  const table = getTableOr404(req, res);
  if (!table) return;

  const sleutel = req.body;
  const foutSleutel = table.primaryKey.find(k => !(k in sleutel));
  if (foutSleutel) return res.status(400).json({ error: `Ontbrekende sleutelwaarde: ${foutSleutel}` });

  try {
    const whereClause = table.primaryKey.map((k, i) => `${quote(k)} = $${i + 1}`).join(' AND ');
    const sql = `DELETE FROM ${quote(table.name)} WHERE ${whereClause}`;
    const result = await pool.query(sql, table.primaryKey.map(k => sleutel[k]));
    res.json({ status: 'ok', verwijderd: result.rowCount });
  } catch (err) {
    console.error('FOUT bij verwijderen:', err);
    res.status(500).json({ error: err.message });
  }
});

app.listen(3000, () => {
  console.log('Backend draait op http://localhost:3000');
});
