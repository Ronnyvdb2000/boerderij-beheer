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

// Vult verplichte (NOT NULL) BOOLEAN-kolommen die niet zijn meegegeven aan met "false"
// (= aankruisvakje niet aangevinkt). Access liet nooit een leeg aankruisvakje toe, dus
// dit is de juiste standaardwaarde bij het aanmaken van een nieuwe rij.
function vulVerplichteBooleansAan(tableConfig, waarden) {
  const aangevuld = { ...waarden };
  tableConfig.columns.forEach(c => {
    if (!c.nullable && /BOOLEAN/i.test(c.type) && !(c.name in aangevuld)) {
      aangevuld[c.name] = false;
    }
  });
  return aangevuld;
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
  const klantnrFilter = req.query.klantnr;

  try {
    const whereDelen = [];
    let args = [];

    if (zoek) {
      const tekstKolommen = table.columns
        .filter(c => /char|text/i.test(c.type))
        .map(c => quote(c.name));
      if (tekstKolommen.length > 0) {
        whereDelen.push('(' + tekstKolommen.map((c, i) => `${c}::text ILIKE $${args.length + i + 1}`).join(' OR ') + ')');
        args.push(...tekstKolommen.map(() => `%${zoek}%`));
      }
    }

    // Herbruikbaar voor alle klant-gekoppelde schermen (mestbank, sanitair, enz.):
    // filter op klantnr indien de tabel die kolom heeft en er een waarde is meegegeven.
    if (klantnrFilter !== undefined && table.columns.some(c => c.name === 'klantnr')) {
      whereDelen.push(`${quote('klantnr')} = $${args.length + 1}`);
      args.push(Number(klantnrFilter));
    }

    const whereClause = whereDelen.length > 0 ? 'WHERE ' + whereDelen.join(' AND ') : '';

    const totaalRes = await pool.query(`SELECT COUNT(*) FROM ${quote(table.name)} ${whereClause}`, args);
    const dataSql = `SELECT * FROM ${quote(table.name)} ${whereClause} ORDER BY ${table.primaryKey.map(quote).join(', ')} LIMIT $${args.length + 1} OFFSET $${args.length + 2}`;
    const dataRes = await pool.query(dataSql, [...args, limit, offset]);

    res.json({ rows: dataRes.rows, totaal: Number(totaalRes.rows[0].count) });
  } catch (err) {
    console.error('FOUT bij ophalen data:', err);
    res.status(500).json({ error: err.message });
  }
});

// GENERIEKE KEUZELIJST: alle rijen van eender welke (whitelisted) tabel, zonder paginering.
// Herbruikbaar voor lookup-tabellen (diersoorten, staltypes, enz.) bij nieuwe schermen.
app.get('/api/lijsten/tabel/:table', async (req, res) => {
  const table = getTableOr404(req, res);
  if (!table) return;
  try {
    const result = await pool.query(`SELECT * FROM ${quote(table.name)} ORDER BY ${table.primaryKey.map(quote).join(', ')} LIMIT 5000`);
    res.json(result.rows);
  } catch (err) {
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

// ============================================================================
// SPECIFIEK SCHERM: "Algemene gegevens" (nabouw van het Access-formulier)
// Combineert "00 adresessen" + "02 sanitaire gegevens" (gekoppeld via klantnr),
// met keuzelijsten uit "01 gemeenten" en "000 vertegenwoordiger".
// ============================================================================

// Lichte lijst van alle klanten (voor de scrollende lijst links in het scherm)
app.get('/api/klanten', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT klantnr, naam FROM "00 adresessen" WHERE naam IS NOT NULL ORDER BY naam`
    );
    res.json(result.rows);
  } catch (err) {
    console.error('FOUT bij ophalen klantenlijst:', err);
    res.status(500).json({ error: err.message });
  }
});

// Keuzelijst gemeenten (voor de dropdown)
app.get('/api/lijsten/gemeenten', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT gemeente_id, postcode, gemeente FROM "01 gemeenten" WHERE gemeente IS NOT NULL ORDER BY gemeente`
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Keuzelijst vertegenwoordigers (voor de dropdown) — LET OP: in Access is de
// gekoppelde waarde "volgnr", niet de interne autonummer-sleutel "vertegenwoordiger".
app.get('/api/lijsten/vertegenwoordigers', async (req, res) => {
  try {
    const result = await pool.query(
      `SELECT volgnr, naam FROM "000 vertegenwoordiger" WHERE naam IS NOT NULL ORDER BY volgnr`
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Eén klant ophalen (adresgegevens + sanitaire gegevens samengevoegd)
app.get('/api/klanten/:klantnr', async (req, res) => {
  const klantnr = Number(req.params.klantnr);
  try {
    const adresRes = await pool.query(
      `SELECT * FROM "00 adresessen" WHERE klantnr = $1 LIMIT 1`, [klantnr]
    );
    if (adresRes.rows.length === 0) return res.status(404).json({ error: 'Klant niet gevonden' });

    const sanitairRes = await pool.query(
      `SELECT * FROM "02 sanitaire gegevens" WHERE klantnr = $1 LIMIT 1`, [klantnr]
    );

    res.json({
      algemeen: adresRes.rows[0],
      sanitair: sanitairRes.rows[0] || null
    });
  } catch (err) {
    console.error('FOUT bij ophalen klant:', err);
    res.status(500).json({ error: err.message });
  }
});

// Klant bijwerken (beide tabellen tegelijk, in één transactie)
app.put('/api/klanten/:klantnr', async (req, res) => {
  const klantnr = Number(req.params.klantnr);
  const { algemeen, sanitair } = req.body;
  const client = await pool.connect();
  try {
    await client.query('BEGIN');

    if (algemeen) {
      const kolommen = Object.keys(algemeen).filter(k => k !== 'klantnr' && k !== 'adres_id');
      if (kolommen.length > 0) {
        const setClause = kolommen.map((k, i) => `${quote(k)} = $${i + 1}`).join(', ');
        await client.query(
          `UPDATE "00 adresessen" SET ${setClause} WHERE klantnr = $${kolommen.length + 1}`,
          [...kolommen.map(k => algemeen[k]), klantnr]
        );
      }
    }

    if (sanitair) {
      const bestaatRes = await client.query(
        `SELECT adres_id FROM "02 sanitaire gegevens" WHERE klantnr = $1`, [klantnr]
      );
      const kolommen = Object.keys(sanitair).filter(k => k !== 'klantnr' && k !== 'adres_id');
      if (bestaatRes.rows.length > 0) {
        if (kolommen.length > 0) {
          const setClause = kolommen.map((k, i) => `${quote(k)} = $${i + 1}`).join(', ');
          await client.query(
            `UPDATE "02 sanitaire gegevens" SET ${setClause} WHERE klantnr = $${kolommen.length + 1}`,
            [...kolommen.map(k => sanitair[k]), klantnr]
          );
        }
      } else if (kolommen.length > 0) {
        const sanitairConfig = TABLES_BY_NAME.get('02 sanitaire gegevens');
        const volledigeWaarden = vulVerplichteBooleansAan(sanitairConfig, sanitair);

        const alleKolommen = ['klantnr', ...Object.keys(volledigeWaarden)];
        const alleWaarden = [klantnr, ...Object.values(volledigeWaarden)];
        const placeholders = alleWaarden.map((_, i) => `$${i + 1}`).join(', ');
        await client.query(
          `INSERT INTO "02 sanitaire gegevens" (${alleKolommen.map(quote).join(', ')}) VALUES (${placeholders})`,
          alleWaarden
        );
      }
    }

    await client.query('COMMIT');
    res.json({ status: 'ok' });
  } catch (err) {
    await client.query('ROLLBACK');
    console.error('FOUT bij bijwerken klant:', err);
    res.status(500).json({ error: err.message });
  } finally {
    client.release();
  }
});

// Nieuwe klant aanmaken (klantnr wordt automatisch het eerstvolgende nummer)
app.post('/api/klanten', async (req, res) => {
  const { algemeen } = req.body;
  try {
    const volgendeRes = await pool.query(`SELECT COALESCE(MAX(klantnr), 0) + 1 AS volgende FROM "00 adresessen"`);
    const nieuwKlantnr = volgendeRes.rows[0].volgende;

    const adresessenConfig = TABLES_BY_NAME.get('00 adresessen');
    const volledigeWaarden = vulVerplichteBooleansAan(adresessenConfig, algemeen || {});

    const kolommen = ['klantnr', ...Object.keys(volledigeWaarden)];
    const waarden = [nieuwKlantnr, ...Object.values(volledigeWaarden)];
    const placeholders = waarden.map((_, i) => `$${i + 1}`).join(', ');

    await pool.query(
      `INSERT INTO "00 adresessen" (${kolommen.map(quote).join(', ')}) VALUES (${placeholders})`,
      waarden
    );

    res.json({ klantnr: nieuwKlantnr });
  } catch (err) {
    console.error('FOUT bij aanmaken klant:', err);
    res.status(500).json({ error: err.message });
  }
});

app.listen(3000, () => {
  console.log('Backend draait op http://localhost:3000');
});

// ============================================================================
// SPECIFIEK SCHERM: "Mestbankgegevens" (nabouw van "011 Mestbankaangifte dieren")
// 7 subformulieren, allemaal gekoppeld via klantnr.
// ============================================================================

const HUIDIG_JAAR_MIN_1 = new Date().getFullYear() - 1;

app.get('/api/mestbank/:klantnr', async (req, res) => {
  const klantnr = Number(req.params.klantnr);
  try {
    const [
      identificatie, ner, stalbezetting, rv, dieren, stockVoeder, andereVoeders
    ] = await Promise.all([
      pool.query(`SELECT * FROM "03 mestbank gegevens nutrientenhalte" WHERE klantnr = $1 LIMIT 1`, [klantnr]),
      pool.query(`SELECT n.*, s.soort AS soort_naam FROM "03 ner" n LEFT JOIN "03 soort ner" s ON n.soort = s.id WHERE n.klantnr = $1 ORDER BY n.datum`, [klantnr]),
      pool.query(`SELECT * FROM "10 mestbank dieren stalbezetting" WHERE klantnr = $1 ORDER BY id`, [klantnr]),
      pool.query(`SELECT * FROM "10 voorw rv" WHERE klantnr = $1 AND jaar = $2`, [klantnr, HUIDIG_JAAR_MIN_1]),
      pool.query(`SELECT d.*, dr.diernaam FROM "10 mestbank dieren" d LEFT JOIN "21 dieren" dr ON d.diercode = dr.diercode WHERE d.klantnr = $1 AND d.jaartal = $2`, [klantnr, HUIDIG_JAAR_MIN_1]),
      pool.query(`SELECT sv.*, dr.diernaam FROM "12 mestbank stock voeder" sv LEFT JOIN "21 dieren" dr ON sv.diercode_stock = dr.diercode WHERE sv.klantnr = $1`, [klantnr]),
      pool.query(`SELECT * FROM "14 voeders" WHERE klantnr = $1 ORDER BY jaar DESC`, [klantnr])
    ]);

    res.json({
      identificatie: identificatie.rows[0] || null,
      ner: ner.rows,
      stalbezetting: stalbezetting.rows,
      rv: rv.rows[0] || null,
      dieren: dieren.rows,
      stockVoeder: stockVoeder.rows,
      andereVoeders: andereVoeders.rows,
      huidigJaarMin1: HUIDIG_JAAR_MIN_1
    });
  } catch (err) {
    console.error('FOUT bij ophalen mestbankgegevens:', err);
    res.status(500).json({ error: err.message });
  }
});
