vereistLogin();

let klantenLijst = [];
let gefilterdeLijst = [];
let huidigeIndex = -1;
let huidigeKlantnr = null;
let huidigJaarMin1 = new Date().getFullYear() - 1;

// Lookup-tabellen (eenmalig geladen, gebruikt om ID's naar leesbare namen om te zetten
// en om keuzelijsten te vullen)
let lkpDieren = [];        // 21 dieren: diercode, diernaam
let lkpVerliesnorm = [];   // 21 verliesnorm: id, omschrijving
let lkpStaltypes = [];     // 07 stal types: id, staltype
let lkpMub = [];           // 04 type mestuitscheidingsbalans: id, omschrijving
let lkpSoortNer = [];      // 03 soort ner: id, soort
let lkpArtikelen = [];     // 23 artikelnr voeders: artikelnummer, omschrijving
let lkpSamenvoegcodes = []; // afgeleid uit 21 dieren: unieke samenvoegcode + representatieve naam

function opt(waarde, tekst, geselecteerd) {
  const o = document.createElement('option');
  o.value = waarde;
  o.textContent = tekst;
  if (geselecteerd !== undefined && String(geselecteerd) === String(waarde)) o.selected = true;
  return o;
}

function maakSelect(lijst, huidigeWaarde, placeholderTekst) {
  const select = document.createElement('select');
  select.appendChild(opt('', placeholderTekst || '-'));
  lijst.forEach(([waarde, tekst]) => select.appendChild(opt(waarde, tekst, huidigeWaarde)));
  return select;
}

function maakInput(type, waarde) {
  const input = document.createElement('input');
  if (type === 'checkbox') {
    input.type = 'checkbox';
    input.checked = !!waarde;
  } else {
    input.type = type;
    if (type === 'number') input.step = 'any';
    input.value = waarde === null || waarde === undefined ? '' : (type === 'date' && typeof waarde === 'string' ? waarde.substring(0, 10) : waarde);
  }
  return input;
}

function leesVeld(el) {
  if (el.tagName === 'SELECT') return el.value === '' ? null : el.value;
  if (el.type === 'checkbox') return el.checked;
  if (el.type === 'number') return el.value === '' ? null : Number(el.value);
  return el.value === '' ? null : el.value;
}

// ---------- Generieke bewerkbare grid ----------
// columns: [{ key, label, kind: 'text'|'number'|'date'|'checkbox'|'select', opties: [[waarde,tekst],...], vastBijNieuw: bool }]
function renderGrid(container, { tableName, primaryKey, rows, columns, vasteWaarden, herlaad }) {
  container.innerHTML = '';
  const table = document.createElement('table');
  table.className = 'grid';

  const thead = document.createElement('thead');
  const trh = document.createElement('tr');
  columns.forEach(c => {
    const th = document.createElement('th');
    th.textContent = c.label;
    trh.appendChild(th);
  });
  trh.appendChild(document.createElement('th'));
  thead.appendChild(trh);
  table.appendChild(thead);

  const tbody = document.createElement('tbody');

  function sleutelVan(rij) {
    const s = {};
    primaryKey.forEach(k => { s[k] = rij[k]; });
    return s;
  }

  rows.forEach(rij => {
    const tr = document.createElement('tr');
    const inputs = {};
    columns.forEach(c => {
      const td = document.createElement('td');
      const isSleutel = primaryKey.includes(c.key);
      let el;
      if (c.kind === 'select') {
        el = maakSelect(c.opties, rij[c.key]);
      } else {
        el = maakInput(c.kind, rij[c.key]);
      }
      if (isSleutel) el.disabled = true; // sleutelvelden niet wijzigbaar na aanmaak
      inputs[c.key] = el;
      td.appendChild(el);
      tr.appendChild(td);
    });

    const tdActies = document.createElement('td');
    tdActies.className = 'actie-cel';
    const opslaanBtn = document.createElement('button');
    opslaanBtn.textContent = 'Opslaan';
    opslaanBtn.onclick = async () => {
      const wijzigingen = {};
      columns.forEach(c => {
        if (!primaryKey.includes(c.key)) wijzigingen[c.key] = leesVeld(inputs[c.key]);
      });
      try {
        await apiPut(`/data/${encodeURIComponent(tableName)}`, { sleutel: sleutelVan(rij), wijzigingen });
        herlaad();
      } catch (err) { alert('Fout bij opslaan: ' + err.message); }
    };
    const verwijderBtn = document.createElement('button');
    verwijderBtn.textContent = 'X';
    verwijderBtn.onclick = async () => {
      if (!confirm('Deze rij verwijderen?')) return;
      try {
        await apiDelete(`/data/${encodeURIComponent(tableName)}`, sleutelVan(rij));
        herlaad();
      } catch (err) { alert('Fout bij verwijderen: ' + err.message); }
    };
    tdActies.appendChild(opslaanBtn);
    tdActies.appendChild(verwijderBtn);
    tr.appendChild(tdActies);
    tbody.appendChild(tr);
  });

  // Nieuwe-rij formulier
  const trNieuw = document.createElement('tr');
  const nieuweInputs = {};
  columns.forEach(c => {
    const td = document.createElement('td');
    if (c.vastBijNieuw !== undefined) {
      td.textContent = c.vastBijNieuw;
    } else {
      let el = c.kind === 'select' ? maakSelect(c.opties, null) : maakInput(c.kind, null);
      nieuweInputs[c.key] = el;
      td.appendChild(el);
    }
    trNieuw.appendChild(td);
  });
  const tdNieuwActie = document.createElement('td');
  const toevoegBtn = document.createElement('button');
  toevoegBtn.textContent = 'Toevoegen';
  toevoegBtn.onclick = async () => {
    const data = { ...vasteWaarden };
    columns.forEach(c => {
      if (c.vastBijNieuw === undefined) data[c.key] = leesVeld(nieuweInputs[c.key]);
    });
    try {
      await apiPost(`/data/${encodeURIComponent(tableName)}`, data);
      herlaad();
    } catch (err) { alert('Fout bij toevoegen: ' + err.message); }
  };
  tdNieuwActie.appendChild(toevoegBtn);
  trNieuw.appendChild(tdNieuwActie);
  tbody.appendChild(trNieuw);

  table.appendChild(tbody);
  container.appendChild(table);
}

// ---------- Enkelvoudig formulier (Identificatie, RV) ----------
function renderEnkelvoudig(container, { tableName, primaryKeyVaste, data, columns, vasteWaarden, herlaad }) {
  container.innerHTML = '';
  const inputs = {};
  columns.forEach(c => {
    const rij = document.createElement('div');
    rij.className = 'veldrij';
    const label = document.createElement('label');
    label.textContent = c.label + ':';
    label.style.width = '160px';
    rij.appendChild(label);
    const waarde = data ? data[c.key] : null;
    let el = c.kind === 'select' ? maakSelect(c.opties, waarde) : maakInput(c.kind, waarde);
    inputs[c.key] = el;
    rij.appendChild(el);
    container.appendChild(rij);
  });

  const opslaanBtn = document.createElement('button');
  opslaanBtn.textContent = data ? 'Opslaan' : 'Aanmaken';
  opslaanBtn.onclick = async () => {
    const velden = {};
    columns.forEach(c => { velden[c.key] = leesVeld(inputs[c.key]); });
    try {
      if (data) {
        const sleutel = {};
        Object.keys(primaryKeyVaste).forEach(k => { sleutel[k] = primaryKeyVaste[k]; });
        await apiPut(`/data/${encodeURIComponent(tableName)}`, { sleutel, wijzigingen: velden });
      } else {
        await apiPost(`/data/${encodeURIComponent(tableName)}`, { ...vasteWaarden, ...velden });
      }
      herlaad();
    } catch (err) { alert('Fout bij opslaan: ' + err.message); }
  };
  container.appendChild(opslaanBtn);
}

// ---------- Klantenlijst (zelfde patroon als opvragen-algemeen) ----------
function toonKlantenlijst() {
  const container = document.getElementById('klantenlijst');
  container.innerHTML = '';
  gefilterdeLijst.forEach((k, idx) => {
    const div = document.createElement('div');
    div.className = 'klant-item' + (idx === huidigeIndex ? ' actief' : '');
    div.innerHTML = `<span class="nr">${k.klantnr}</span><span>${k.naam}</span>`;
    div.onclick = () => selecteerIndex(idx);
    container.appendChild(div);
  });
}

function filterLijst() {
  const zoekterm = document.getElementById('zoekklant').value.trim().toLowerCase();
  gefilterdeLijst = zoekterm
    ? klantenLijst.filter(k => k.naam.toLowerCase().includes(zoekterm) || String(k.klantnr).includes(zoekterm))
    : klantenLijst;
  huidigeIndex = -1;
  toonKlantenlijst();
}

async function selecteerIndex(idx) {
  huidigeIndex = idx;
  toonKlantenlijst();
  huidigeKlantnr = gefilterdeLijst[idx].klantnr;
  document.getElementById('titel').textContent = `Mestbankgegevens — ${gefilterdeLijst[idx].naam} (${huidigeKlantnr})`;
  await laadMestbankData();
}

async function laadMestbankData() {
  let data;
  try {
    data = await apiGet(`/mestbank/${huidigeKlantnr}`);
  } catch (err) {
    alert('Fout bij laden mestbankgegevens: ' + err.message);
    return;
  }
  huidigJaarMin1 = data.huidigJaarMin1;
  document.getElementById('rv-titel').textContent = `Melk / RV (jaar ${huidigJaarMin1})`;
  document.getElementById('dieren-titel').textContent = `Mestbank dieren (jaar ${huidigJaarMin1})`;

  // --- Identificatie ---
  renderEnkelvoudig(document.getElementById('sectie-identificatie'), {
    tableName: '03 mestbank gegevens nutrientenhalte',
    primaryKeyVaste: { klantnr: huidigeKlantnr },
    data: data.identificatie,
    vasteWaarden: { klantnr: huidigeKlantnr },
    columns: [
      { key: 'mestbanknr', label: 'Mestbanknr', kind: 'text' },
      { key: 'relatienr', label: 'Relatienr', kind: 'number' },
      { key: 'inrichtingsrnr', label: 'Inrichtingsrnr', kind: 'number' },
      { key: 'bedrijfsgroep', label: 'Bedrijfsgroep', kind: 'text' },
      { key: 'bedrijfnr', label: 'Bedrijfnr', kind: 'number' },
      { key: 'lbernr', label: 'Landbouwernr', kind: 'text' },
      { key: 'exploitantnr', label: 'Exploitantnr', kind: 'text' },
      { key: 'exploitatienr', label: 'Exploitatienr', kind: 'text' },
      { key: 'dossiernrvmm', label: 'Dossiernr VMM', kind: 'text' }
    ],
    herlaad: laadMestbankData
  });

  // --- Overzicht NER ---
  renderGrid(document.getElementById('sectie-ner'), {
    tableName: '03 ner',
    primaryKey: ['id', 'klantnr'],
    rows: data.ner,
    vasteWaarden: { klantnr: huidigeKlantnr },
    columns: [
      { key: 'klantnr', label: 'klantnr', kind: 'number', vastBijNieuw: huidigeKlantnr },
      { key: 'landbouwrnr', label: 'landbouwrnr', kind: 'text' },
      { key: 'soort', label: 'soort', kind: 'select', opties: lkpSoortNer },
      { key: 'aantal', label: 'aantal', kind: 'number' },
      { key: 'datum', label: 'datum', kind: 'date' },
      { key: 'verwpl', label: 'verwerkingspl.', kind: 'checkbox' },
      { key: 'blok', label: 'geblokkeerd', kind: 'checkbox' },
      { key: 'nverwbedrijf', label: 'N te verw (bedrijf)', kind: 'number' },
      { key: 'nverwspsoort', label: 'N te verw (soort)', kind: 'number' },
      { key: 'diersoortrv', label: 'RV', kind: 'checkbox' },
      { key: 'diersoortv', label: 'V', kind: 'checkbox' },
      { key: 'diersoortp', label: 'P', kind: 'checkbox' },
      { key: 'diersoorta', label: 'A', kind: 'checkbox' },
      { key: 'opm', label: 'opmerking', kind: 'text' }
    ],
    herlaad: laadMestbankData
  });

  // --- Stalbezetting ---
  renderGrid(document.getElementById('sectie-stalbezetting'), {
    tableName: '10 mestbank dieren stalbezetting',
    primaryKey: ['id'],
    rows: data.stalbezetting,
    vasteWaarden: { klantnr: huidigeKlantnr },
    columns: [
      { key: 'klantnr', label: 'klantnr', kind: 'number', vastBijNieuw: huidigeKlantnr },
      { key: 'jaar', label: 'jaar', kind: 'number' },
      { key: 'diercode', label: 'diersoort', kind: 'select', opties: lkpDieren },
      { key: 'type', label: 'type (ammoniak)', kind: 'select', opties: lkpVerliesnorm },
      { key: 'stalbezet', label: 'stalbezetting (%)', kind: 'number' },
      { key: 'aantal', label: 'aantal', kind: 'number' },
      { key: 'plaatsen', label: 'aantal plaatsen', kind: 'number' },
      { key: 'staltype', label: 'staltype', kind: 'select', opties: lkpStaltypes },
      { key: 'begrazing', label: '% begrazing', kind: 'number' }
    ],
    herlaad: laadMestbankData
  });

  // --- Melk / RV ---
  renderEnkelvoudig(document.getElementById('sectie-rv'), {
    tableName: '10 voorw rv',
    primaryKeyVaste: data.rv ? { id: data.rv.id, klantnr: huidigeKlantnr, jaar: huidigJaarMin1 } : null,
    data: data.rv,
    vasteWaarden: { klantnr: huidigeKlantnr, jaar: huidigJaarMin1 },
    columns: [
      { key: 'derogatie', label: 'Derogatie', kind: 'checkbox' },
      { key: 'melkq', label: 'Melkquotum leveringen (liter)', kind: 'number' },
      { key: 'leveringen', label: 'Melk thuisverkoop (liter)', kind: 'number' },
      { key: 'melkqkg', label: 'Melkquotum (kg)', kind: 'number' },
      { key: 'voedergewas', label: 'Voedergewas (ha)', kind: 'number' },
      { key: 'gras', label: 'Gras (ha)', kind: 'number' },
      { key: 'voorw1', label: 'Voorwaarde 1', kind: 'number' },
      { key: 'voorw2', label: 'Voorwaarde 2', kind: 'number' }
    ],
    herlaad: laadMestbankData
  });

  // --- Mestbank dieren ---
  renderGrid(document.getElementById('sectie-dieren'), {
    tableName: '10 mestbank dieren',
    primaryKey: ['klantnr', 'jaartal', 'diercode'],
    rows: data.dieren,
    vasteWaarden: { klantnr: huidigeKlantnr, jaartal: huidigJaarMin1 },
    columns: [
      { key: 'klantnr', label: 'klantnr', kind: 'number', vastBijNieuw: huidigeKlantnr },
      { key: 'jaartal', label: 'jaartal', kind: 'number', vastBijNieuw: huidigJaarMin1 },
      { key: 'diercode', label: 'diersoort', kind: 'select', opties: lkpDieren },
      { key: 'aantal', label: 'aantal', kind: 'number' },
      { key: 'plaatsen', label: 'plaatsen', kind: 'number' },
      { key: 'mub', label: 'MuB', kind: 'select', opties: lkpMub },
      { key: 'lec', label: 'LEC', kind: 'checkbox' }
    ],
    herlaad: laadMestbankData
  });

  // --- Stock voeder ---
  renderGrid(document.getElementById('sectie-stockvoeder'), {
    tableName: '12 mestbank stock voeder',
    primaryKey: ['klantnr', 'jaartal', 'diercode_stock', 'artnr'],
    rows: data.stockVoeder,
    vasteWaarden: { klantnr: huidigeKlantnr },
    columns: [
      { key: 'klantnr', label: 'klantnr', kind: 'number', vastBijNieuw: huidigeKlantnr },
      { key: 'jaartal', label: 'jaartal', kind: 'number' },
      { key: 'diercode_stock', label: 'diersoort', kind: 'select', opties: lkpDieren },
      { key: 'artnr', label: 'artikel', kind: 'select', opties: lkpArtikelen },
      { key: 'stock_voeder', label: 'beginstock hoev.', kind: 'number' },
      { key: 'p_stock', label: 'beginstock P', kind: 'number' },
      { key: 're_stock', label: 'beginstock RE', kind: 'number' },
      { key: 'stock_voedere', label: 'eindstock hoev.', kind: 'number' },
      { key: 'p_stocke', label: 'eindstock P', kind: 'number' },
      { key: 're_stocke', label: 'eindstock RE', kind: 'number' }
    ],
    herlaad: laadMestbankData
  });

  // --- Andere voeders ---
  renderGrid(document.getElementById('sectie-anderevoeders'), {
    tableName: '14 voeders',
    primaryKey: ['bedrijfsvoeder_id'],
    rows: data.andereVoeders,
    vasteWaarden: { klantnr: huidigeKlantnr },
    columns: [
      { key: 'klantnr', label: 'klantnr', kind: 'number', vastBijNieuw: huidigeKlantnr },
      { key: 'jaar', label: 'jaar', kind: 'number' },
      { key: 'diercode', label: 'diersoort(groep)', kind: 'select', opties: lkpSamenvoegcodes },
      { key: 'omschrijving', label: 'omschrijving', kind: 'text' },
      { key: 'hoev', label: 'hoeveelheid', kind: 'number' },
      { key: 're', label: 'RE', kind: 'number' },
      { key: 'p', label: 'P', kind: 'number' },
      { key: 'bedrijfseigen', label: 'bedrijfseigen?', kind: 'checkbox' }
    ],
    herlaad: laadMestbankData
  });
}

async function laadLookups() {
  const [dieren, verliesnorm, staltypes, mub, soortNer, artikelen] = await Promise.all([
    apiGet('/lijsten/tabel/' + encodeURIComponent('21 dieren')),
    apiGet('/lijsten/tabel/' + encodeURIComponent('21 verliesnorm')),
    apiGet('/lijsten/tabel/' + encodeURIComponent('07 stal types')),
    apiGet('/lijsten/tabel/' + encodeURIComponent('04 type mestuitscheidingsbalans')),
    apiGet('/lijsten/tabel/' + encodeURIComponent('03 soort ner')),
    apiGet('/lijsten/tabel/' + encodeURIComponent('23 artikelnr voeders'))
  ]);

  lkpDieren = dieren.filter(d => d.diercode !== null && d.diernaam).map(d => [d.diercode, `${d.diercode} - ${d.diernaam}`]);
  lkpVerliesnorm = verliesnorm.map(v => [v.id, v.omschrijving || ('#' + v.id)]);
  lkpStaltypes = staltypes.map(s => [s.id, s.staltype || ('#' + s.id)]);
  lkpMub = mub.map(m => [m.id, m.omschrijving || ('#' + m.id)]);
  lkpSoortNer = soortNer.map(s => [s.id, s.soort || ('#' + s.id)]);
  lkpArtikelen = artikelen.filter(a => a.artikelnummer !== null).map(a => [a.artikelnummer, `${a.artikelnummer} - ${a.omschrijving || ''}`]);

  const samenvoegMap = new Map();
  dieren.forEach(d => {
    if (d.samenvoegcode !== null && !samenvoegMap.has(d.samenvoegcode)) {
      samenvoegMap.set(d.samenvoegcode, d.diernaam || ('groep ' + d.samenvoegcode));
    }
  });
  lkpSamenvoegcodes = Array.from(samenvoegMap.entries());
}

async function init() {
  await laadLookups();
  try {
    klantenLijst = await apiGet('/klanten');
  } catch (err) {
    alert('Fout bij laden klantenlijst: ' + err.message);
    return;
  }
  filterLijst();
  if (gefilterdeLijst.length > 0) selecteerIndex(0);

  document.getElementById('zoekklant').addEventListener('input', filterLijst);
}

init();
