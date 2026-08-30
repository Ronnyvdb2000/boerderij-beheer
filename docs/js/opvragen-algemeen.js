vereistLogin();

let klantenLijst = [];      // volledige lijst { klantnr, naam }
let gefilterdeLijst = [];   // huidig gefilterd (via zoekveld)
let huidigeIndex = -1;
let nieuweKlantModus = false;

const velden = {
  algemeen: ['klantnr','naam','adres1','adres2','gemeente_id','telefoon','gsm','faxnummer','btw','email','reknr',
             'klant','beginkl','expobe','mestbank','expofr','granen','premies','vl','mb','vertegenw'],
  sanitair: ['beslagnr','pasw_abregister','login_veeportaal','beslagcode','pasw_veeportaal','zeugen','mestvarkens',
             'verkoop biggen','aankoop biggen']
};

// Koppeling van elk databaseveld naar het bijhorende HTML-element-id
const veldElementId = {
  klantnr: 'f_klantnr', naam: 'f_naam', adres1: 'f_adres1', adres2: 'f_adres2', gemeente_id: 'f_gemeente_id',
  telefoon: 'f_telefoon', gsm: 'f_gsm', faxnummer: 'f_faxnummer', btw: 'f_btw', email: 'f_email', reknr: 'f_reknr',
  klant: 'f_klant', beginkl: 'f_beginkl', expobe: 'f_expobe', mestbank: 'f_mestbank', expofr: 'f_expofr',
  granen: 'f_granen', premies: 'f_premies', vl: 'f_vl', mb: 'f_mb', vertegenw: 'f_vertegenw',
  beslagnr: 'f_beslagnr', pasw_abregister: 'f_pasw_abregister', login_veeportaal: 'f_login_veeportaal',
  beslagcode: 'f_beslagcode', pasw_veeportaal: 'f_pasw_veeportaal', zeugen: 'f_zeugen', mestvarkens: 'f_mestvarkens',
  'verkoop biggen': 'f_verkoopbiggen', 'aankoop biggen': 'f_aankoopbiggen'
};

function isCheckbox(id) {
  const el = document.getElementById(id);
  return el && el.type === 'checkbox';
}

function vulFormulierIn(algemeen, sanitair) {
  velden.algemeen.forEach(veld => {
    const elId = veldElementId[veld];
    const el = document.getElementById(elId);
    if (!el) return;
    const waarde = algemeen ? algemeen[veld] : null;
    if (isCheckbox(elId)) {
      el.checked = !!waarde;
    } else {
      el.value = waarde === null || waarde === undefined ? '' : waarde;
    }
  });

  const sanitelFieldset = document.getElementById('sanitel-velden');
  velden.sanitair.forEach(veld => {
    const elId = veldElementId[veld];
    const el = document.getElementById(elId);
    if (!el) return;
    const waarde = sanitair ? sanitair[veld] : null;
    if (isCheckbox(elId)) {
      el.checked = !!waarde;
    } else {
      el.value = waarde === null || waarde === undefined ? '' : waarde;
    }
  });
  sanitelFieldset.disabled = !sanitair;
}

function leesFormulier() {
  const algemeen = {};
  velden.algemeen.forEach(veld => {
    if (veld === 'klantnr') return; // klantnr wordt nooit via het formulier gewijzigd
    const elId = veldElementId[veld];
    const el = document.getElementById(elId);
    if (!el) return;
    if (isCheckbox(elId)) {
      algemeen[veld] = el.checked;
    } else if (el.value !== '') {
      algemeen[veld] = ['gemeente_id', 'beginkl', 'vertegenw'].includes(veld) ? Number(el.value) : el.value;
    } else {
      algemeen[veld] = null;
    }
  });

  let sanitair = null;
  if (!document.getElementById('sanitel-velden').disabled) {
    sanitair = {};
    velden.sanitair.forEach(veld => {
      const elId = veldElementId[veld];
      const el = document.getElementById(elId);
      if (!el) return;
      if (isCheckbox(elId)) {
        sanitair[veld] = el.checked;
      } else if (el.value !== '') {
        sanitair[veld] = ['zeugen', 'mestvarkens'].includes(veld) ? Number(el.value) : el.value;
      } else {
        sanitair[veld] = null;
      }
    });
  }

  return { algemeen, sanitair };
}

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

function updateNavigatorInfo() {
  document.getElementById('nav-info').textContent =
    gefilterdeLijst.length === 0 ? 'geen records' : `record ${huidigeIndex + 1} van ${gefilterdeLijst.length}`;
}

async function selecteerIndex(idx) {
  if (idx < 0 || idx >= gefilterdeLijst.length) return;
  huidigeIndex = idx;
  nieuweKlantModus = false;
  toonKlantenlijst();
  updateNavigatorInfo();

  const klant = gefilterdeLijst[idx];
  try {
    const data = await apiGet(`/klanten/${klant.klantnr}`);
    vulFormulierIn(data.algemeen, data.sanitair);
  } catch (err) {
    alert('Fout bij laden van klant: ' + err.message);
  }
}

function filterLijst() {
  const zoekterm = document.getElementById('zoekklant').value.trim().toLowerCase();
  gefilterdeLijst = zoekterm
    ? klantenLijst.filter(k => k.naam.toLowerCase().includes(zoekterm) || String(k.klantnr).includes(zoekterm))
    : klantenLijst;
  huidigeIndex = -1;
  toonKlantenlijst();
  updateNavigatorInfo();
}

async function vulKeuzelijsten() {
  try {
    const gemeenten = await apiGet('/lijsten/gemeenten');
    const gemSelect = document.getElementById('f_gemeente_id');
    gemeenten.forEach(g => {
      const opt = document.createElement('option');
      opt.value = g.gemeente_id;
      opt.textContent = `${g.postcode || ''} ${g.gemeente}`.trim();
      gemSelect.appendChild(opt);
    });

    const vertegenwoordigers = await apiGet('/lijsten/vertegenwoordigers');
    const vertSelect = document.getElementById('f_vertegenw');
    vertegenwoordigers.forEach(v => {
      const opt = document.createElement('option');
      opt.value = v.vertegenwoordiger;
      opt.textContent = v.naam;
      vertSelect.appendChild(opt);
    });
  } catch (err) {
    console.error('Fout bij laden keuzelijsten:', err);
  }
}

async function init() {
  await vulKeuzelijsten();

  try {
    klantenLijst = await apiGet('/klanten');
  } catch (err) {
    alert('Fout bij laden klantenlijst: ' + err.message);
    return;
  }
  filterLijst();
  if (gefilterdeLijst.length > 0) selecteerIndex(0);

  document.getElementById('zoekklant').addEventListener('input', filterLijst);

  document.getElementById('nav-eerste').onclick = () => selecteerIndex(0);
  document.getElementById('nav-laatste').onclick = () => selecteerIndex(gefilterdeLijst.length - 1);
  document.getElementById('nav-vorige').onclick = () => selecteerIndex(huidigeIndex - 1);
  document.getElementById('nav-volgende').onclick = () => selecteerIndex(huidigeIndex + 1);

  document.getElementById('btn-toevoegen').onclick = () => {
    nieuweKlantModus = true;
    huidigeIndex = -1;
    toonKlantenlijst();
    vulFormulierIn(null, null);
    document.getElementById('f_klantnr').value = '(nieuw)';
    document.getElementById('nav-info').textContent = 'nieuwe klant (nog niet opgeslagen)';
  };

  document.getElementById('btn-sanitel-toevoegen').onclick = () => {
    document.getElementById('sanitel-velden').disabled = false;
  };

  document.getElementById('btn-opslaan').onclick = async () => {
    const { algemeen, sanitair } = leesFormulier();
    try {
      if (nieuweKlantModus) {
        const result = await apiPost('/klanten', { algemeen });
        alert(`Klant aangemaakt met klantnummer ${result.klantnr}`);
        nieuweKlantModus = false;
        klantenLijst = await apiGet('/klanten');
        filterLijst();
        const idx = gefilterdeLijst.findIndex(k => k.klantnr === result.klantnr);
        if (idx >= 0) selecteerIndex(idx);
      } else {
        const klant = gefilterdeLijst[huidigeIndex];
        if (!klant) { alert('Geen klant geselecteerd.'); return; }
        await apiPut(`/klanten/${klant.klantnr}`, { algemeen, sanitair });
        alert('Opgeslagen.');
        klantenLijst = await apiGet('/klanten');
        filterLijst();
      }
    } catch (err) {
      alert('Fout bij opslaan: ' + err.message);
    }
  };
}

init();
