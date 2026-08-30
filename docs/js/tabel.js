vereistLogin();

const params = new URLSearchParams(window.location.search);
const tabelNaam = params.get('naam');

const LIMIT = 50;
let offset = 0;
let totaalRijen = 0;
let tabelInfo = null;
let huidigeRijen = [];

document.getElementById('tabel-titel').textContent = tabelNaam || 'Onbekende tabel';

function inputType(kolomType) {
  const t = kolomType.toUpperCase();
  if (t.includes('BOOLEAN')) return 'checkbox';
  if (t.includes('TIMESTAMP')) return 'datetime-local';
  if (t.includes('DATE')) return 'date';
  if (/INT|DOUBLE|REAL|NUMERIC|DECIMAL|SERIAL/.test(t)) return 'number';
  return 'text';
}

function isAutoKolom(kolom) {
  return /SERIAL/i.test(kolom.type);
}

function formatWaardeVoorInput(waarde, kolomType) {
  if (waarde === null || waarde === undefined) return '';
  const t = inputType(kolomType);
  if (t === 'datetime-local' && typeof waarde === 'string') {
    // Postgres geeft bv. "2019-01-03T00:00:00.000Z" of "2019-01-03 00:00:00" terug
    return waarde.replace(' ', 'T').substring(0, 16);
  }
  if (t === 'date' && typeof waarde === 'string') {
    return waarde.substring(0, 10);
  }
  return waarde;
}

function bouwNieuweRijFormulier() {
  const form = document.getElementById('nieuwe-rij-form');
  form.innerHTML = '';

  tabelInfo.columns.forEach(kolom => {
    if (isAutoKolom(kolom)) return; // wordt automatisch door de database ingevuld

    const label = document.createElement('label');
    label.textContent = kolom.name + (kolom.nullable ? '' : ' *');
    form.appendChild(label);

    const type = inputType(kolom.type);
    const input = document.createElement('input');
    input.type = type === 'checkbox' ? 'checkbox' : type;
    input.name = kolom.name;
    if (type === 'number') input.step = 'any';
    if (!kolom.nullable && type !== 'checkbox') input.required = true;
    form.appendChild(input);
  });

  const submitBtn = document.createElement('button');
  submitBtn.type = 'submit';
  submitBtn.textContent = 'Toevoegen';
  form.appendChild(submitBtn);
}

function leesFormulierWaarden(form) {
  const data = {};
  tabelInfo.columns.forEach(kolom => {
    if (isAutoKolom(kolom)) return;
    const el = form.elements[kolom.name];
    if (!el) return;
    const type = inputType(kolom.type);
    if (type === 'checkbox') {
      data[kolom.name] = el.checked;
    } else if (el.value !== '') {
      data[kolom.name] = type === 'number' ? Number(el.value) : el.value;
    } else if (kolom.nullable) {
      data[kolom.name] = null;
    }
  });
  return data;
}

function bouwHeader() {
  const headerRij = document.getElementById('header-rij');
  headerRij.innerHTML = '';
  tabelInfo.columns.forEach(kolom => {
    const th = document.createElement('th');
    th.textContent = kolom.name + (tabelInfo.primaryKey.includes(kolom.name) ? ' 🔑' : '');
    headerRij.appendChild(th);
  });
  const thActies = document.createElement('th');
  thActies.textContent = 'Acties';
  headerRij.appendChild(thActies);
}

function sleutelVanRij(rij) {
  const sleutel = {};
  tabelInfo.primaryKey.forEach(k => { sleutel[k] = rij[k]; });
  return sleutel;
}

function toonRijenAlleen() {
  const body = document.getElementById('body-rijen');
  body.innerHTML = '';

  huidigeRijen.forEach((rij, idx) => {
    const tr = document.createElement('tr');
    tabelInfo.columns.forEach(kolom => {
      const td = document.createElement('td');
      td.textContent = rij[kolom.name] === null || rij[kolom.name] === undefined ? '' : rij[kolom.name];
      tr.appendChild(td);
    });

    const tdActies = document.createElement('td');
    const bewerkBtn = document.createElement('button');
    bewerkBtn.textContent = 'Bewerken';
    bewerkBtn.className = 'actie-btn';
    bewerkBtn.onclick = () => toonRijBewerkbaar(idx);
    tdActies.appendChild(bewerkBtn);

    const verwijderBtn = document.createElement('button');
    verwijderBtn.textContent = 'Verwijderen';
    verwijderBtn.className = 'actie-btn verwijder';
    verwijderBtn.onclick = () => verwijderRij(rij);
    tdActies.appendChild(verwijderBtn);

    tr.appendChild(tdActies);
    body.appendChild(tr);
  });
}

function toonRijBewerkbaar(idx) {
  const rij = huidigeRijen[idx];
  const body = document.getElementById('body-rijen');
  const tr = body.children[idx];
  tr.innerHTML = '';

  const inputs = {};
  tabelInfo.columns.forEach(kolom => {
    const td = document.createElement('td');
    const isSleutel = tabelInfo.primaryKey.includes(kolom.name);
    if (isSleutel) {
      // Sleutelkolommen zijn niet bewerkbaar (rij-identiteit blijft vast tijdens bewerken)
      td.textContent = rij[kolom.name] === null ? '' : rij[kolom.name];
    } else {
      const type = inputType(kolom.type);
      const input = document.createElement('input');
      if (type === 'checkbox') {
        input.type = 'checkbox';
        input.checked = !!rij[kolom.name];
      } else {
        input.type = type;
        if (type === 'number') input.step = 'any';
        input.value = formatWaardeVoorInput(rij[kolom.name], kolom.type);
      }
      inputs[kolom.name] = input;
      td.appendChild(input);
    }
    tr.appendChild(td);
  });

  const tdActies = document.createElement('td');
  const opslaanBtn = document.createElement('button');
  opslaanBtn.textContent = 'Opslaan';
  opslaanBtn.className = 'actie-btn opslaan';
  opslaanBtn.onclick = () => opslaanRij(rij, inputs);
  tdActies.appendChild(opslaanBtn);

  const annuleerBtn = document.createElement('button');
  annuleerBtn.textContent = 'Annuleren';
  annuleerBtn.className = 'actie-btn';
  annuleerBtn.onclick = () => toonRijenAlleen();
  tdActies.appendChild(annuleerBtn);

  tr.appendChild(tdActies);
}

async function opslaanRij(rij, inputs) {
  const wijzigingen = {};
  tabelInfo.columns.forEach(kolom => {
    if (tabelInfo.primaryKey.includes(kolom.name)) return;
    const input = inputs[kolom.name];
    const type = inputType(kolom.type);
    if (type === 'checkbox') {
      wijzigingen[kolom.name] = input.checked;
    } else if (input.value !== '') {
      wijzigingen[kolom.name] = type === 'number' ? Number(input.value) : input.value;
    } else {
      wijzigingen[kolom.name] = null;
    }
  });

  try {
    await apiPut(`/data/${encodeURIComponent(tabelNaam)}`, { sleutel: sleutelVanRij(rij), wijzigingen });
    await laadData();
  } catch (err) {
    alert('Fout bij opslaan: ' + err.message);
  }
}

async function verwijderRij(rij) {
  if (!confirm('Deze rij definitief verwijderen?')) return;
  try {
    await apiDelete(`/data/${encodeURIComponent(tabelNaam)}`, sleutelVanRij(rij));
    await laadData();
  } catch (err) {
    alert('Fout bij verwijderen: ' + err.message);
  }
}

async function laadData() {
  const zoek = document.getElementById('zoekveld').value.trim();
  const query = new URLSearchParams({ limit: LIMIT, offset, q: zoek });
  const resultaat = await apiGet(`/data/${encodeURIComponent(tabelNaam)}?${query}`);
  huidigeRijen = resultaat.rows;
  totaalRijen = resultaat.totaal;
  toonRijenAlleen();

  const totaalPaginas = Math.max(1, Math.ceil(totaalRijen / LIMIT));
  const huidigePagina = Math.floor(offset / LIMIT) + 1;
  document.getElementById('pagina-info').textContent = `pagina ${huidigePagina} van ${totaalPaginas} (${totaalRijen} rijen)`;
  document.getElementById('vorige-btn').disabled = offset === 0;
  document.getElementById('volgende-btn').disabled = offset + LIMIT >= totaalRijen;
}

async function init() {
  if (!tabelNaam) {
    document.body.innerHTML = '<p>Geen tabel opgegeven.</p>';
    return;
  }

  const alleTabellen = await apiGet('/tables');
  tabelInfo = alleTabellen.find(t => t.name === tabelNaam);
  if (!tabelInfo) {
    document.body.innerHTML = '<p>Onbekende tabel.</p>';
    return;
  }

  bouwNieuweRijFormulier();
  bouwHeader();
  await laadData();

  document.getElementById('nieuwe-rij-form').addEventListener('submit', async (e) => {
    e.preventDefault();
    const data = leesFormulierWaarden(e.target);
    try {
      await apiPost(`/data/${encodeURIComponent(tabelNaam)}`, data);
      document.getElementById('toevoeg-fout').style.display = 'none';
      document.getElementById('toevoeg-melding').style.display = 'block';
      e.target.reset();
      offset = 0;
      await laadData();
    } catch (err) {
      document.getElementById('toevoeg-melding').style.display = 'none';
      const foutEl = document.getElementById('toevoeg-fout');
      foutEl.textContent = 'Fout: ' + err.message;
      foutEl.style.display = 'block';
    }
  });

  document.getElementById('zoek-btn').addEventListener('click', () => {
    offset = 0;
    laadData();
  });
  document.getElementById('zoekveld').addEventListener('keydown', (e) => {
    if (e.key === 'Enter') { e.preventDefault(); offset = 0; laadData(); }
  });

  document.getElementById('vorige-btn').addEventListener('click', () => {
    offset = Math.max(0, offset - LIMIT);
    laadData();
  });
  document.getElementById('volgende-btn').addEventListener('click', () => {
    offset += LIMIT;
    laadData();
  });
}

init();
