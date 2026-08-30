-- Automatisch gegenereerd Postgres/Supabase-schema op basis van geg_2021.mdb
-- Tabelnamen en kolomnamen zijn ongewijzigd t.o.v. Access (aangehaald met dubbele quotes,
-- want ze bevatten spaties). Tabellen zonder oorspronkelijke primary key hebben een
-- synthetische 'row_id' kolom gekregen zodat individuele rijen bewerkbaar zijn.

CREATE TABLE IF NOT EXISTS "13 voederlijst" (
    "id" SERIAL,
    "klantnr" INTEGER
);

ALTER TABLE "13 voederlijst" ADD CONSTRAINT "13 voederlijst_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "13 voeders degrave" (
    "levering_id" SERIAL,
    "klantnr" INTEGER NOT NULL,
    "diercode" INTEGER NOT NULL,
    "leverdatum" TIMESTAMP WITHOUT TIME ZONE NOT NULL,
    "artnr" INTEGER,
    "hoev" INTEGER,
    "re" DOUBLE PRECISION,
    "p" DOUBLE PRECISION,
    "tot_re" DOUBLE PRECISION,
    "tot_p" DOUBLE PRECISION,
    "oorsprcode" INTEGER,
    "oorsprklnr" INTEGER,
    "bestaat" VARCHAR (50),
    "gemed" VARCHAR (50),
    "voorschrift" VARCHAR (50),
    "molentje" VARCHAR (50),
    "iddier" INTEGER,
    "codep" VARCHAR (50),
    "coden" VARCHAR (50),
    "codepn" VARCHAR (50),
    "coppens" VARCHAR (255),
    "proplume" VARCHAR (255)
);

ALTER TABLE "13 voeders degrave" ADD CONSTRAINT "13 voeders degrave_pkey" PRIMARY KEY ("levering_id", "klantnr", "diercode", "leverdatum");

CREATE TABLE IF NOT EXISTS "14 voeders" (
    "bedrijfsvoeder_id" SERIAL,
    "klantnr" INTEGER,
    "jaar" INTEGER,
    "diercode" SMALLINT,
    "omschrijving" VARCHAR (50),
    "hoev" INTEGER,
    "re" REAL,
    "p" REAL,
    "bedrijfseigen" BOOLEAN NOT NULL,
    "bestaat" VARCHAR (50)
);

ALTER TABLE "14 voeders" ADD CONSTRAINT "14 voeders_pkey" PRIMARY KEY ("bedrijfsvoeder_id");

CREATE TABLE IF NOT EXISTS "14 voeders tsst" (
    row_id SERIAL PRIMARY KEY,
    "bedrijfsvoeder_id" SERIAL,
    "klantnr" INTEGER,
    "jaar" INTEGER,
    "diercode" SMALLINT,
    "omschrijving" VARCHAR (50),
    "hoev" INTEGER,
    "re" REAL,
    "p" REAL
);

CREATE TABLE IF NOT EXISTS "15 kunstmest" (
    "id" SERIAL,
    "klantnr" INTEGER NOT NULL,
    "jaartal" INTEGER NOT NULL,
    "kunstmest" INTEGER NOT NULL,
    "omschrijving" VARCHAR (50),
    "hoev" DOUBLE PRECISION,
    "n" DOUBLE PRECISION,
    "p2o5" DOUBLE PRECISION,
    "ingave" VARCHAR (50),
    "bestaat" VARCHAR (50)
);

ALTER TABLE "15 kunstmest" ADD CONSTRAINT "15 kunstmest_pkey" PRIMARY KEY ("id", "klantnr", "jaartal", "kunstmest");

CREATE TABLE IF NOT EXISTS "15 tr" (
    row_id SERIAL PRIMARY KEY,
    "docnr" DOUBLE PRECISION,
    "datum" TIMESTAMP WITHOUT TIME ZONE,
    "mest" VARCHAR (255),
    "ton" DOUBLE PRECISION,
    "n" DOUBLE PRECISION,
    "p2o5" DOUBLE PRECISION,
    "vorm" VARCHAR (255),
    "aanbieder" VARCHAR (50),
    "afnemer" VARCHAR (50),
    "type" VARCHAR (255),
    "richting" VARCHAR (255),
    "bestaat" BOOLEAN NOT NULL
);

CREATE TABLE IF NOT EXISTS "67 regios" (
    "id" SERIAL,
    "code" VARCHAR (255),
    "regio" VARCHAR (255),
    "jaar" DOUBLE PRECISION
);

ALTER TABLE "67 regios" ADD CONSTRAINT "67 regios_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "69 teelten" (
    "id" SERIAL,
    "code" VARCHAR (255),
    "teelt" VARCHAR (255),
    "jaar" DOUBLE PRECISION
);

ALTER TABLE "69 teelten" ADD CONSTRAINT "69 teelten_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "70 sanitaire afwijking redenen" (
    "id" SERIAL,
    "code" VARCHAR (255),
    "reden sanitel afwijking" VARCHAR (255),
    "jaar" DOUBLE PRECISION
);

ALTER TABLE "70 sanitaire afwijking redenen" ADD CONSTRAINT "70 sanitaire afwijking redenen_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "00" (
    "adres_id" SERIAL,
    "klantnr" INTEGER,
    "tot" INTEGER,
    "prefix" VARCHAR (255),
    "aanspreking" VARCHAR (255),
    "naam" VARCHAR (255),
    "adres1" VARCHAR (255),
    "adres2" VARCHAR (255),
    "postnr" VARCHAR (50),
    "gemeente_id" INTEGER,
    "telefoon" VARCHAR (50),
    "gsm" VARCHAR (50),
    "faxnummer" VARCHAR (50),
    "btw" VARCHAR (50),
    "klant" BOOLEAN NOT NULL,
    "beginkl" INTEGER,
    "expobe" BOOLEAN NOT NULL,
    "expofr" BOOLEAN NOT NULL,
    "premies" BOOLEAN NOT NULL,
    "mestbank" BOOLEAN NOT NULL,
    "mb" BOOLEAN NOT NULL,
    "granen" BOOLEAN NOT NULL,
    "email" VARCHAR (50),
    "vl" BOOLEAN NOT NULL,
    "reknr" VARCHAR (50),
    "vertegenw" INTEGER,
    "bestaat" BOOLEAN NOT NULL,
    "test" VARCHAR (50),
    "bestaat1" BOOLEAN NOT NULL
);

ALTER TABLE "00" ADD CONSTRAINT "00_pkey" PRIMARY KEY ("adres_id");

CREATE TABLE IF NOT EXISTS "00 adresessen" (
    "adres_id" SERIAL,
    "klantnr" INTEGER,
    "tot" INTEGER,
    "prefix" VARCHAR (255),
    "aanspreking" VARCHAR (255),
    "naam" VARCHAR (255),
    "adres1" VARCHAR (255),
    "adres2" VARCHAR (255),
    "postnr" VARCHAR (50),
    "gemeente_id" INTEGER,
    "telefoon" VARCHAR (50),
    "gsm" VARCHAR (50),
    "faxnummer" VARCHAR (50),
    "btw" VARCHAR (50),
    "klant" BOOLEAN NOT NULL,
    "beginkl" INTEGER,
    "expobe" BOOLEAN NOT NULL,
    "expofr" BOOLEAN NOT NULL,
    "premies" BOOLEAN NOT NULL,
    "mestbank" BOOLEAN NOT NULL,
    "mb" BOOLEAN NOT NULL,
    "granen" BOOLEAN NOT NULL,
    "email" VARCHAR (50),
    "vl" BOOLEAN NOT NULL,
    "reknr" VARCHAR (50),
    "vertegenw" INTEGER,
    "bestaat" BOOLEAN NOT NULL,
    "test" VARCHAR (50),
    "bestaat1" BOOLEAN NOT NULL
);

ALTER TABLE "00 adresessen" ADD CONSTRAINT "00 adresessen_pkey" PRIMARY KEY ("adres_id");

CREATE TABLE IF NOT EXISTS "00 leveradressen" (
    "klantnr" INTEGER,
    "levernr" INTEGER
);

ALTER TABLE "00 leveradressen" ADD CONSTRAINT "00 leveradressen_pkey" PRIMARY KEY ("klantnr", "levernr");

CREATE TABLE IF NOT EXISTS "000 vertegenwoordiger" (
    "vertegenwoordiger" SERIAL,
    "volgnr" INTEGER,
    "naam" VARCHAR (50),
    "adres1" VARCHAR (50),
    "gemeente_id" INTEGER,
    "login" VARCHAR (50),
    "paswoord" VARCHAR (8),
    "alg" BOOLEAN NOT NULL,
    "mb" BOOLEAN NOT NULL,
    "bedrijfsgeg" BOOLEAN NOT NULL,
    "voorschr" BOOLEAN NOT NULL,
    "lev" BOOLEAN NOT NULL,
    "korting" BOOLEAN NOT NULL,
    "voederopv" BOOLEAN NOT NULL
);

ALTER TABLE "000 vertegenwoordiger" ADD CONSTRAINT "000 vertegenwoordiger_pkey" PRIMARY KEY ("vertegenwoordiger");

CREATE TABLE IF NOT EXISTS "0000" (
    row_id SERIAL PRIMARY KEY,
    "klantnr" INTEGER,
    "eerstevannaam" VARCHAR (255),
    "jaartal" INTEGER
);

CREATE TABLE IF NOT EXISTS "001lijst" (
    row_id SERIAL PRIMARY KEY,
    "klantnr" INTEGER,
    "naam" VARCHAR (255),
    "jaartal" INTEGER,
    "somvanaantal" DOUBLE PRECISION
);

CREATE TABLE IF NOT EXISTS "01 gemeenten" (
    "gemeente_id" SERIAL,
    "postcode" VARCHAR (50),
    "gemeente" VARCHAR (50),
    "route" INTEGER,
    "verwpl" VARCHAR (50),
    "ndruk" INTEGER,
    "ndrukvoor1_1_19" INTEGER,
    "ndrukvoor1_1_17" INTEGER,
    "per1" INTEGER,
    "per2" INTEGER,
    "per3" INTEGER
);

ALTER TABLE "01 gemeenten" ADD CONSTRAINT "01 gemeenten_pkey" PRIMARY KEY ("gemeente_id");

CREATE TABLE IF NOT EXISTS "01 maanden" (
    "id" SERIAL,
    "maand" VARCHAR (50)
);

ALTER TABLE "01 maanden" ADD CONSTRAINT "01 maanden_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "02 sanitaire gegevens" (
    "adres_id" SERIAL,
    "klantnr" INTEGER,
    "beslagnr" VARCHAR (50),
    "beslagcode" VARCHAR (50),
    "pasw_abregister" VARCHAR (255),
    "login_veeportaal" VARCHAR (255),
    "pasw_veeportaal" VARCHAR (255),
    "auj_statuut" VARCHAR (50),
    "zeugen" INTEGER,
    "mestvarkens" INTEGER,
    "verkoop biggen" BOOLEAN NOT NULL,
    "aankoop biggen" BOOLEAN NOT NULL
);

ALTER TABLE "02 sanitaire gegevens" ADD CONSTRAINT "02 sanitaire gegevens_pkey" PRIMARY KEY ("adres_id");

CREATE TABLE IF NOT EXISTS "03 mestbank gegevens nutrientenhalte" (
    "klantnr" INTEGER NOT NULL,
    "mestbanknr" VARCHAR (50),
    "inrichtingsrnr" INTEGER,
    "koepelnr" INTEGER,
    "relatienr" INTEGER,
    "bedrijfnr" INTEGER,
    "dossiernrvmm" VARCHAR (50),
    "bedrijfsgroep" VARCHAR (50),
    "lbernr" VARCHAR (50),
    "exploitantnr" VARCHAR (50),
    "exploitatienr" VARCHAR (50),
    "test" VARCHAR (50),
    "start" TIMESTAMP WITHOUT TIME ZONE,
    "stop" TIMESTAMP WITHOUT TIME ZONE,
    "uitbatersnr" VARCHAR (50),
    "uitbatingsnr" VARCHAR (50),
    "nh_n" DOUBLE PRECISION,
    "nh_p2o5" DOUBLE PRECISION,
    "zeugennormnh" INTEGER,
    "mestvarkensnormnh" INTEGER,
    "anderevarkensnormnh" INTEGER,
    "login" VARCHAR (50),
    "paswoord" VARCHAR (50),
    "loginbis" VARCHAR (50),
    "paswoordbis" VARCHAR (50),
    "aangevraagd" BOOLEAN NOT NULL,
    "verwerkingsplichtig" BOOLEAN NOT NULL,
    "best" VARCHAR (50)
);

ALTER TABLE "03 mestbank gegevens nutrientenhalte" ADD CONSTRAINT "03 mestbank gegevens nutrientenhalte_pkey" PRIMARY KEY ("klantnr");

CREATE TABLE IF NOT EXISTS "03 ner" (
    "id" SERIAL,
    "klantnr" INTEGER NOT NULL,
    "tot" INTEGER,
    "landbouwrnr" VARCHAR (50),
    "aantal" DOUBLE PRECISION,
    "soort" INTEGER,
    "datum" TIMESTAMP WITHOUT TIME ZONE,
    "nverwbedrijf" DOUBLE PRECISION,
    "nverwspsoort" DOUBLE PRECISION,
    "verwpl" BOOLEAN NOT NULL,
    "diersoortrv" BOOLEAN NOT NULL,
    "diersoortv" BOOLEAN NOT NULL,
    "diersoortp" BOOLEAN NOT NULL,
    "diersoorta" BOOLEAN NOT NULL,
    "blok" BOOLEAN NOT NULL,
    "opm" VARCHAR (50),
    "verw" TEXT,
    "bestaat" VARCHAR (50),
    "nverwbedrijfoorspr" DOUBLE PRECISION,
    "nverwspsoortoorspr" DOUBLE PRECISION
);

ALTER TABLE "03 ner" ADD CONSTRAINT "03 ner_pkey" PRIMARY KEY ("id", "klantnr");

CREATE TABLE IF NOT EXISTS "03 ner groep" (
    "soort" INTEGER,
    "nergr" VARCHAR (50),
    "code" VARCHAR (50)
);

ALTER TABLE "03 ner groep" ADD CONSTRAINT "03 ner groep_pkey" PRIMARY KEY ("soort");

CREATE TABLE IF NOT EXISTS "03 soort ner" (
    "id" INTEGER,
    "soort" VARCHAR (50),
    "nergroep" INTEGER,
    "verwperc" DOUBLE PRECISION
);

ALTER TABLE "03 soort ner" ADD CONSTRAINT "03 soort ner_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "03 soort verw" (
    "id" INTEGER,
    "soort" VARCHAR (50)
);

ALTER TABLE "03 soort verw" ADD CONSTRAINT "03 soort verw_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "04 type mestuitscheidingsbalans" (
    "id" SERIAL,
    "nr" INTEGER,
    "omschrijving" VARCHAR (50)
);

ALTER TABLE "04 type mestuitscheidingsbalans" ADD CONSTRAINT "04 type mestuitscheidingsbalans_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "05 compensatie ner" (
    "id" SERIAL,
    "klantnr" DOUBLE PRECISION,
    "jaar" INTEGER,
    "comp" VARCHAR (255),
    "opm" VARCHAR (255)
);

ALTER TABLE "05 compensatie ner" ADD CONSTRAINT "05 compensatie ner_pkey" PRIMARY KEY ("id", "klantnr", "jaar");

CREATE TABLE IF NOT EXISTS "06 type afzet" (
    "type afzet" INTEGER,
    "beschrijving" VARCHAR (50),
    "aanofaf" VARCHAR (50)
);

ALTER TABLE "06 type afzet" ADD CONSTRAINT "06 type afzet_pkey" PRIMARY KEY ("type afzet");

CREATE TABLE IF NOT EXISTS "07 luchtwassers" (
    "id" SERIAL,
    "diersoort" VARCHAR (255),
    "diercat" DOUBLE PRECISION,
    "lw" INTEGER,
    "reductie" DOUBLE PRECISION,
    "min" DOUBLE PRECISION,
    "max" DOUBLE PRECISION
);

ALTER TABLE "07 luchtwassers" ADD CONSTRAINT "07 luchtwassers_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "07 stal types" (
    "id" SERIAL,
    "staltype" TEXT
);

ALTER TABLE "07 stal types" ADD CONSTRAINT "07 stal types_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "08 convenant" (
    "diercode" INTEGER NOT NULL,
    "jaar" INTEGER NOT NULL,
    "iddier" INTEGER NOT NULL,
    "omschrijving" VARCHAR (50),
    "maxp" REAL,
    "maxre" REAL,
    "maxverbruik" REAL,
    "margeverbruik" VARCHAR (50),
    "uitschn" DOUBLE PRECISION,
    "uitschp" DOUBLE PRECISION
);

ALTER TABLE "08 convenant" ADD CONSTRAINT "08 convenant_pkey" PRIMARY KEY ("diercode", "jaar", "iddier");

CREATE TABLE IF NOT EXISTS "08 dieren coefficienten regressie" (
    "samenvoegcode" INTEGER,
    "jaar" INTEGER,
    "coef1re" REAL,
    "coef2re" REAL,
    "coef1p" REAL,
    "coef2p" REAL,
    "verbruik" INTEGER
);

ALTER TABLE "08 dieren coefficienten regressie" ADD CONSTRAINT "08 dieren coefficienten regressie_pkey" PRIMARY KEY ("samenvoegcode", "jaar");

CREATE TABLE IF NOT EXISTS "09 cert" (
    "id" SERIAL,
    "klantnr" INTEGER,
    "volgnr" INTEGER,
    "omschr" VARCHAR (50),
    "datum" TIMESTAMP WITHOUT TIME ZONE,
    "aard" VARCHAR (50)
);

ALTER TABLE "09 cert" ADD CONSTRAINT "09 cert_pkey" PRIMARY KEY ("id", "klantnr", "volgnr");

CREATE TABLE IF NOT EXISTS "10 dieren tussenstand" (
    "klantnr" INTEGER,
    "diercode" INTEGER,
    "jaar" INTEGER,
    "datum" DATE,
    "aantal" INTEGER,
    "maanden" INTEGER,
    "aantalomgerek" DOUBLE PRECISION,
    "verbruik" DOUBLE PRECISION,
    "re" DOUBLE PRECISION,
    "p" DOUBLE PRECISION,
    "re_nmin" DOUBLE PRECISION,
    "re_nmax" DOUBLE PRECISION
);

ALTER TABLE "10 dieren tussenstand" ADD CONSTRAINT "10 dieren tussenstand_pkey" PRIMARY KEY ("klantnr", "diercode", "jaar");

CREATE TABLE IF NOT EXISTS "10 dieren verliesnorm" (
    row_id SERIAL PRIMARY KEY,
    "klantnr" INTEGER,
    "jaar" INTEGER,
    "10 mestbank dieren stalbezetting_diercode" DOUBLE PRECISION,
    "21 verliesnorm_diercode" DOUBLE PRECISION,
    "verliesnorm" DOUBLE PRECISION,
    "bestaat" VARCHAR (50)
);

CREATE TABLE IF NOT EXISTS "10 mestbank dieren" (
    "klantnr" INTEGER NOT NULL,
    "jaartal" INTEGER NOT NULL,
    "diercode" DOUBLE PRECISION NOT NULL,
    "aantal" INTEGER,
    "plaatsen" INTEGER,
    "mub" INTEGER,
    "lec" BOOLEAN NOT NULL,
    "bruton" DOUBLE PRECISION,
    "verliesnorm" DOUBLE PRECISION,
    "netton" DOUBLE PRECISION,
    "nettop" DOUBLE PRECISION,
    "prodn" REAL,
    "prodp" DOUBLE PRECISION,
    "1prodn" REAL,
    "1prodp" REAL,
    "1ner" DOUBLE PRECISION,
    "2prodn" REAL,
    "2prodp" REAL,
    "3prodn" REAL,
    "3prodp" REAL,
    "4prodn" REAL,
    "4prodp" REAL,
    "totre" DOUBLE PRECISION,
    "totp" DOUBLE PRECISION,
    "waterverbruik" DOUBLE PRECISION,
    "watervmm" DOUBLE PRECISION,
    "ingave" TIMESTAMP WITHOUT TIME ZONE,
    "bestaat" VARCHAR (50)
);

ALTER TABLE "10 mestbank dieren" ADD CONSTRAINT "10 mestbank dieren_pkey" PRIMARY KEY ("klantnr", "jaartal", "diercode");

CREATE TABLE IF NOT EXISTS "10 mestbank dieren stalbezetting" (
    "id" SERIAL,
    "klantnr" INTEGER,
    "jaar" INTEGER,
    "diercode" DOUBLE PRECISION,
    "type" INTEGER,
    "stalbezet" REAL,
    "aantal" INTEGER,
    "plaatsen" INTEGER,
    "staltype" INTEGER,
    "best" VARCHAR (50),
    "begrazing" INTEGER,
    "f12" VARCHAR (255),
    "f13" VARCHAR (255),
    "f14" VARCHAR (255),
    "f15" VARCHAR (255),
    "f16" VARCHAR (255),
    "f17" VARCHAR (255),
    "f18" VARCHAR (255),
    "f19" VARCHAR (255),
    "f20" VARCHAR (255),
    "f21" VARCHAR (255),
    "f22" VARCHAR (255),
    "f23" VARCHAR (255),
    "f24" VARCHAR (255),
    "f25" VARCHAR (255),
    "f26" VARCHAR (255),
    "f27" VARCHAR (255),
    "f28" VARCHAR (255)
);

ALTER TABLE "10 mestbank dieren stalbezetting" ADD CONSTRAINT "10 mestbank dieren stalbezetting_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "10 prod spui" (
    "id" SERIAL,
    "klantnr" INTEGER,
    "stal" VARCHAR (50),
    "soort" INTEGER,
    "jaartal" INTEGER,
    "tellerbegin" INTEGER,
    "datumbegin" TIMESTAMP WITHOUT TIME ZONE,
    "tellereind" INTEGER,
    "datumeind" TIMESTAMP WITHOUT TIME ZONE,
    "hoev" INTEGER,
    "nanal" DOUBLE PRECISION,
    "panal" DOUBLE PRECISION,
    "ntot" DOUBLE PRECISION,
    "ptot" DOUBLE PRECISION,
    "gebrcert" BOOLEAN NOT NULL,
    "datumcert" TIMESTAMP WITHOUT TIME ZONE,
    "bestaat" VARCHAR (255)
);

ALTER TABLE "10 prod spui" ADD CONSTRAINT "10 prod spui_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "10 prod spui balans" (
    "id" SERIAL,
    "klantnr" INTEGER,
    "soort" INTEGER,
    "jaar" INTEGER,
    "datum" TIMESTAMP WITHOUT TIME ZONE,
    "aard" INTEGER,
    "hoev" INTEGER,
    "gehalte" DOUBLE PRECISION,
    "n" DOUBLE PRECISION
);

ALTER TABLE "10 prod spui balans" ADD CONSTRAINT "10 prod spui balans_pkey" PRIMARY KEY ("id", "klantnr");

CREATE TABLE IF NOT EXISTS "10 verlies'" (
    row_id SERIAL PRIMARY KEY,
    "klantnr" INTEGER,
    "jaar" INTEGER,
    "10 mestbank dieren stalbezetting_diercode" DOUBLE PRECISION,
    "21 verliesnorm_diercode" DOUBLE PRECISION,
    "verliesnorm" DOUBLE PRECISION,
    "bestaat" VARCHAR (50)
);

CREATE TABLE IF NOT EXISTS "10 voorw rv" (
    "id" SERIAL,
    "klantnr" INTEGER,
    "jaar" INTEGER,
    "derogatie" BOOLEAN NOT NULL,
    "melkq" INTEGER,
    "leveringen" INTEGER,
    "melkqkg" DOUBLE PRECISION,
    "voedergewas" DOUBLE PRECISION,
    "gras" DOUBLE PRECISION,
    "voorw1" DOUBLE PRECISION,
    "voorw2" DOUBLE PRECISION,
    "bestaat" VARCHAR (50)
);

ALTER TABLE "10 voorw rv" ADD CONSTRAINT "10 voorw rv_pkey" PRIMARY KEY ("id", "klantnr", "jaar");

CREATE TABLE IF NOT EXISTS "102 aantal" (
    row_id SERIAL PRIMARY KEY,
    "klantnr" INTEGER,
    "aantalvanhoev" INTEGER
);

CREATE TABLE IF NOT EXISTS "102 aantal orig" (
    row_id SERIAL PRIMARY KEY,
    "klantnr" INTEGER,
    "aantalvanhoev" INTEGER
);

CREATE TABLE IF NOT EXISTS "11 mestbank gronden" (
    "klantnr" INTEGER,
    "jaartal" INTEGER,
    "grondtype" REAL,
    "oppervlakte" DOUBLE PRECISION,
    "dierln" DOUBLE PRECISION,
    "chemn" DOUBLE PRECISION,
    "totn" DOUBLE PRECISION,
    "totp2o5" DOUBLE PRECISION,
    "bestaat" VARCHAR (50)
);

ALTER TABLE "11 mestbank gronden" ADD CONSTRAINT "11 mestbank gronden_pkey" PRIMARY KEY ("klantnr", "jaartal", "grondtype");

CREATE TABLE IF NOT EXISTS "11 voedergewassen" (
    "id" SERIAL,
    "klantnr" INTEGER,
    "jaar" INTEGER,
    "type" INTEGER,
    "ha" DOUBLE PRECISION,
    "bestaat" VARCHAR (50)
);

ALTER TABLE "11 voedergewassen" ADD CONSTRAINT "11 voedergewassen_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "12 mestbank stock voeder" (
    "klantnr" INTEGER,
    "jaartal" INTEGER,
    "diercode_stock" INTEGER,
    "artnr" INTEGER,
    "stock_voeder" INTEGER,
    "p_stock" DOUBLE PRECISION,
    "re_stock" DOUBLE PRECISION,
    "stock_voedere" INTEGER,
    "p_stocke" DOUBLE PRECISION,
    "re_stocke" DOUBLE PRECISION,
    "stock_voeders" INTEGER,
    "p_stocks" DOUBLE PRECISION,
    "re_stocks" DOUBLE PRECISION,
    "bestaat" VARCHAR (50),
    "veld1" VARCHAR (255),
    "veld2" VARCHAR (255),
    "veld3" VARCHAR (255),
    "veld4" VARCHAR (255),
    "veld5" VARCHAR (255),
    "veld6" VARCHAR (255),
    "veld7" VARCHAR (255),
    "veld8" VARCHAR (255),
    "veld9" VARCHAR (255),
    "veld10" VARCHAR (255),
    "veld11" VARCHAR (255),
    "veld12" VARCHAR (255),
    "veld13" VARCHAR (255),
    "veld14" VARCHAR (255)
);

ALTER TABLE "12 mestbank stock voeder" ADD CONSTRAINT "12 mestbank stock voeder_pkey" PRIMARY KEY ("klantnr", "jaartal", "diercode_stock", "artnr");

CREATE TABLE IF NOT EXISTS "121 mestbank stock mest" (
    "stock_id" SERIAL,
    "klantnr" INTEGER,
    "jaartal" INTEGER,
    "omschrijving" VARCHAR (50),
    "capaciteit" INTEGER,
    "vorm" VARCHAR (50),
    "stock" INTEGER,
    "n" DOUBLE PRECISION,
    "p" DOUBLE PRECISION,
    "stock_e" INTEGER,
    "n_e" DOUBLE PRECISION,
    "p_e" DOUBLE PRECISION,
    "stock_s" INTEGER,
    "n_s" DOUBLE PRECISION,
    "p_s" DOUBLE PRECISION,
    "bestaat" VARCHAR (50),
    "f17" VARCHAR (255),
    "f18" VARCHAR (255),
    "f19" VARCHAR (255),
    "f20" VARCHAR (255),
    "f21" VARCHAR (255),
    "f22" VARCHAR (255),
    "f23" VARCHAR (255),
    "f24" VARCHAR (255),
    "f25" VARCHAR (255),
    "f26" VARCHAR (255),
    "f27" VARCHAR (255),
    "f28" VARCHAR (255)
);

ALTER TABLE "121 mestbank stock mest" ADD CONSTRAINT "121 mestbank stock mest_pkey" PRIMARY KEY ("stock_id", "klantnr");

CREATE TABLE IF NOT EXISTS "16 basisverwpl" (
    row_id SERIAL PRIMARY KEY,
    "id" SERIAL,
    "bedrgr" VARCHAR (50),
    "jaar" INTEGER,
    "klantnr" INTEGER,
    "naam" VARCHAR (50),
    "prodn" DOUBLE PRECISION,
    "landn" DOUBLE PRECISION,
    "overschot" DOUBLE PRECISION,
    "bedr" DOUBLE PRECISION,
    "gem" DOUBLE PRECISION,
    "verwtot" DOUBLE PRECISION,
    "nverwth" DOUBLE PRECISION,
    "ndefinitief" DOUBLE PRECISION,
    "soort" VARCHAR (80),
    "bestaat" VARCHAR (50)
);

CREATE TABLE IF NOT EXISTS "16 mvc" (
    "id" SERIAL,
    "klantnr" INTEGER NOT NULL,
    "lbnr" VARCHAR (255),
    "jaar" INTEGER,
    "datum" TIMESTAMP WITHOUT TIME ZONE,
    "mvc" DOUBLE PRECISION,
    "soort" INTEGER,
    "opm" VARCHAR (150),
    "overdrager" VARCHAR (255),
    "bestaat" VARCHAR (50)
);

ALTER TABLE "16 mvc" ADD CONSTRAINT "16 mvc_pkey" PRIMARY KEY ("id", "klantnr");

CREATE TABLE IF NOT EXISTS "17 verwpl" (
    "id" SERIAL,
    "bedrijfsgroep" VARCHAR (50),
    "klantnr" INTEGER,
    "jaar" VARCHAR (50),
    "soort" INTEGER,
    "nverw" DOUBLE PRECISION,
    "mvcgenoeg" BOOLEAN NOT NULL,
    "mvcverzet" BOOLEAN NOT NULL,
    "afgewerkt" BOOLEAN NOT NULL
);

ALTER TABLE "17 verwpl" ADD CONSTRAINT "17 verwpl_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "2017 diercategorieen" (
    "id" SERIAL,
    "code" VARCHAR (255),
    "diergroep" VARCHAR (255),
    "code diercategorie" VARCHAR (255),
    "diercategorie" VARCHAR (255),
    "grazen" VARCHAR (255)
);

ALTER TABLE "2017 diercategorieen" ADD CONSTRAINT "2017 diercategorieen_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "2017 kunstmest groeimedium" (
    "code" DOUBLE PRECISION,
    "id" SERIAL,
    "meststof" VARCHAR (255)
);

ALTER TABLE "2017 kunstmest groeimedium" ADD CONSTRAINT "2017 kunstmest groeimedium_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "2017 meststoffen" (
    "id" SERIAL,
    "code" DOUBLE PRECISION,
    "meststof" VARCHAR (255),
    "type" VARCHAR (255),
    "vorm" VARCHAR (255),
    "dichtheid" DOUBLE PRECISION,
    "kg n/ton" DOUBLE PRECISION,
    "kg p₂o₅/ton" DOUBLE PRECISION,
    "naam" VARCHAR (255),
    "nr uitbater" VARCHAR (255),
    "nr uitbating" VARCHAR (255),
    "jaar" INTEGER
);

ALTER TABLE "2017 meststoffen" ADD CONSTRAINT "2017 meststoffen_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "2017 nub types" (
    "code" VARCHAR (255),
    "id" SERIAL,
    "nub" VARCHAR (255)
);

ALTER TABLE "2017 nub types" ADD CONSTRAINT "2017 nub types_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "2017 pas maatregelen" (
    "code" VARCHAR (255),
    "code diercategorie" VARCHAR (255),
    "diergroep" VARCHAR (255),
    "code staltype" VARCHAR (255),
    "diercategorie" VARCHAR (255),
    "code pas-maatregel" VARCHAR (255),
    "staltype" VARCHAR (255),
    "id" SERIAL,
    "pas-maatregel" VARCHAR (255)
);

ALTER TABLE "2017 pas maatregelen" ADD CONSTRAINT "2017 pas maatregelen_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "2017 prod methodes" (
    "code" VARCHAR (255),
    "id" SERIAL,
    "productiemethode" VARCHAR (255)
);

ALTER TABLE "2017 prod methodes" ADD CONSTRAINT "2017 prod methodes_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "2017 regios" (
    "code" VARCHAR (255),
    "id" SERIAL,
    "regio" VARCHAR (255)
);

ALTER TABLE "2017 regios" ADD CONSTRAINT "2017 regios_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "2017 san afw redenen" (
    "code" VARCHAR (255),
    "id" SERIAL,
    "reden sanitel afwijking" VARCHAR (255)
);

ALTER TABLE "2017 san afw redenen" ADD CONSTRAINT "2017 san afw redenen_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "2017 spuistroom" (
    "code" VARCHAR (255),
    "id" SERIAL,
    "spuistroom" VARCHAR (255)
);

ALTER TABLE "2017 spuistroom" ADD CONSTRAINT "2017 spuistroom_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "2017 v staltypes" (
    "code" VARCHAR (255),
    "id" SERIAL,
    "staltype" VARCHAR (255)
);

ALTER TABLE "2017 v staltypes" ADD CONSTRAINT "2017 v staltypes_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "21 diercat dlv" (
    "id" SERIAL,
    "diercat" DOUBLE PRECISION,
    "omschr" VARCHAR (255)
);

ALTER TABLE "21 diercat dlv" ADD CONSTRAINT "21 diercat dlv_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "21 dieren" (
    "diercode" DOUBLE PRECISION NOT NULL,
    "diernaam" VARCHAR (50),
    "n_nh" REAL,
    "p2o5_nh" REAL,
    "ner" REAL,
    "n_forf" REAL,
    "p2o5_forf" REAL,
    "n_conv" REAL,
    "p2o5_conv" REAL,
    "n_lec" DOUBLE PRECISION,
    "samenvoegcode" INTEGER,
    "codewater" INTEGER,
    "diergroep" INTEGER,
    "trad" DOUBLE PRECISION,
    "aea" DOUBLE PRECISION,
    "catdlv" INTEGER,
    "verbruik" INTEGER,
    "volume" DOUBLE PRECISION
);

ALTER TABLE "21 dieren" ADD CONSTRAINT "21 dieren_pkey" PRIMARY KEY ("diercode");

CREATE TABLE IF NOT EXISTS "21 melkkoeien" (
    "id" SERIAL,
    "omschrijving" VARCHAR (255),
    "ondergrens" DOUBLE PRECISION,
    "bovengrens" DOUBLE PRECISION,
    "q250" DOUBLE PRECISION,
    "jaar" DOUBLE PRECISION,
    "p2o5" DOUBLE PRECISION,
    "n" DOUBLE PRECISION,
    "n eind" DOUBLE PRECISION
);

ALTER TABLE "21 melkkoeien" ADD CONSTRAINT "21 melkkoeien_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "21 soort spui" (
    "id" SERIAL,
    "omschrijving" VARCHAR (50)
);

ALTER TABLE "21 soort spui" ADD CONSTRAINT "21 soort spui_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "21 uitsch lec" (
    row_id SERIAL PRIMARY KEY,
    "klantnr" INTEGER,
    "jaar" INTEGER,
    "diercode" DOUBLE PRECISION,
    "somvanlec" DOUBLE PRECISION,
    "somvanniet lec" DOUBLE PRECISION,
    "somvansom" DOUBLE PRECISION,
    "n_lec" DOUBLE PRECISION,
    "niet-laageiwitvoeder" DOUBLE PRECISION
);

CREATE TABLE IF NOT EXISTS "21 verlies" (
    "id" SERIAL,
    "cat" INTEGER,
    "verlies" DOUBLE PRECISION,
    "jaar" INTEGER
);

ALTER TABLE "21 verlies" ADD CONSTRAINT "21 verlies_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "21 verliesnorm" (
    "id" SERIAL,
    "diercode" DOUBLE PRECISION,
    "omschrijving" VARCHAR (255),
    "verlies" DOUBLE PRECISION
);

ALTER TABLE "21 verliesnorm" ADD CONSTRAINT "21 verliesnorm_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "22 gronden" (
    "grond_id" SERIAL,
    "soort gebied" VARCHAR (50),
    "dierlijken" INTEGER,
    "chemischen" INTEGER,
    "totalen" INTEGER,
    "totalefosfaat" INTEGER,
    "jaartal" INTEGER
);

ALTER TABLE "22 gronden" ADD CONSTRAINT "22 gronden_pkey" PRIMARY KEY ("grond_id");

CREATE TABLE IF NOT EXISTS "23 artikelnr voeders" (
    "voeder_id" SERIAL,
    "artikelnummer" INTEGER,
    "omschrijving" VARCHAR (50),
    "eh" VARCHAR (50),
    "re" DOUBLE PRECISION,
    "p" DOUBLE PRECISION,
    "gebruikt in fr" BOOLEAN NOT NULL,
    "metmais" BOOLEAN NOT NULL,
    "code" INTEGER,
    "dosering" DOUBLE PRECISION,
    "omschrijvingfr" VARCHAR (50),
    "catmb" DOUBLE PRECISION,
    "typevoeder" VARCHAR (50),
    "geblokkeerd" VARCHAR (50),
    "codee" VARCHAR (50),
    "codep" VARCHAR (50),
    "tekst" VARCHAR (50),
    "bestaat" VARCHAR (255)
);

ALTER TABLE "23 artikelnr voeders" ADD CONSTRAINT "23 artikelnr voeders_pkey" PRIMARY KEY ("voeder_id");

CREATE TABLE IF NOT EXISTS "24 voeder per pl tsst" (
    row_id SERIAL PRIMARY KEY,
    "klantnr" INTEGER,
    "jaartal" INTEGER,
    "samenvoegcode" INTEGER,
    "expr1" DOUBLE PRECISION,
    "expr2" DOUBLE PRECISION,
    "expr3" DOUBLE PRECISION,
    "n" DOUBLE PRECISION,
    "p" DOUBLE PRECISION,
    "jaar" INTEGER,
    "mub" INTEGER,
    "verbr" DOUBLE PRECISION
);

CREATE TABLE IF NOT EXISTS "24 voeder per plaats" (
    row_id SERIAL PRIMARY KEY,
    "klantnr" INTEGER,
    "jaartal" INTEGER,
    "samenvoegcode" INTEGER,
    "expr1" DOUBLE PRECISION,
    "expr2" DOUBLE PRECISION,
    "expr3" DOUBLE PRECISION,
    "n" DOUBLE PRECISION,
    "p" DOUBLE PRECISION,
    "jaar" INTEGER,
    "mub" INTEGER
);

CREATE TABLE IF NOT EXISTS "25 samenstelling mest" (
    "id" SERIAL,
    "diersoort" INTEGER,
    "mestcode" INTEGER,
    "soort" VARCHAR (50),
    "omschr mb" VARCHAR (50),
    "vorm" VARCHAR (2),
    "n" DOUBLE PRECISION,
    "p2o5" DOUBLE PRECISION,
    "dichtheid (ton/m³)" REAL,
    "codemb" INTEGER,
    "werkingscoeff" INTEGER
);

ALTER TABLE "25 samenstelling mest" ADD CONSTRAINT "25 samenstelling mest_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "26 type mest" (
    "id" SERIAL,
    "omschrijving" VARCHAR (50),
    "vorm" VARCHAR (50)
);

ALTER TABLE "26 type mest" ADD CONSTRAINT "26 type mest_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "31 diergroepen" (
    "id" SERIAL,
    "diergroep" INTEGER,
    "omschrijving" VARCHAR (50)
);

ALTER TABLE "31 diergroepen" ADD CONSTRAINT "31 diergroepen_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "33 vmm nieuw" (
    "id" SERIAL,
    "putnummer" VARCHAR (255),
    "installatienummer" DOUBLE PRECISION,
    "locatie grondwaterput adres" VARCHAR (255),
    "locatie grondwaterput xy-coördinaten" VARCHAR (255),
    "vergunde diepte" DOUBLE PRECISION,
    "watervoerende laag (hydrogeologische hoofdeenheid)" VARCHAR (255),
    "vergunde hoeveelheid grondwater (m³/dag)" VARCHAR (255),
    "vergunde hoeveelheid grondwater (m³/jaar)" DOUBLE PRECISION,
    "exploitant_id_aow" DOUBLE PRECISION,
    "vergunning_id_aow" DOUBLE PRECISION,
    "installatie_id_aow" DOUBLE PRECISION,
    "watnr_aow" VARCHAR (255),
    "vmm_dossier" VARCHAR (255),
    "cbb_xtant" VARCHAR (255),
    "cbb_xtie" VARCHAR (255),
    "nacebel_code" VARCHAR (255),
    "nacebel" VARCHAR (255),
    "naam_exploitant" VARCHAR (255),
    "adres_exploitant" VARCHAR (255),
    "gemeente_exploitant" VARCHAR (255),
    "begin_datum_verg" TIMESTAMP WITHOUT TIME ZONE,
    "eind_datum_verg" TIMESTAMP WITHOUT TIME ZONE,
    "van_datum_termijn" TIMESTAMP WITHOUT TIME ZONE,
    "tot_datum_termijn" TIMESTAMP WITHOUT TIME ZONE,
    "datum_van" TIMESTAMP WITHOUT TIME ZONE,
    "datum_tot" TIMESTAMP WITHOUT TIME ZONE,
    "vergund_debiet_dag" DOUBLE PRECISION,
    "vergund_debiet_jr" DOUBLE PRECISION,
    "klasse" VARCHAR (255),
    "vlarem_rubriek_code" VARCHAR (255),
    "bestemming1" VARCHAR (255),
    "bestemming2" VARCHAR (255),
    "bestemming3" VARCHAR (255),
    "bestemming4" VARCHAR (255),
    "vergund_aantal_putten" DOUBLE PRECISION,
    "vergunde_diepte" DOUBLE PRECISION,
    "gemeente_inst" VARCHAR (255),
    "postcode_inst" DOUBLE PRECISION,
    "adres_inst" VARCHAR (255),
    "kadaster" VARCHAR (255),
    "inst_x" DOUBLE PRECISION,
    "inst_y" DOUBLE PRECISION,
    "inst_z" DOUBLE PRECISION,
    "aard_winning" DOUBLE PRECISION,
    "aard_winning_beschr" VARCHAR (255),
    "aquifer_code_inst" VARCHAR (255),
    "aquifer_beschr_inst" VARCHAR (255),
    "gwlichaam_inst" VARCHAR (255),
    "gwsysteem_inst" VARCHAR (255),
    "gespannen?" DOUBLE PRECISION,
    "heffinggebied" VARCHAR (255),
    "put_id_aow" DOUBLE PRECISION,
    "put_nummer_aow" VARCHAR (255),
    "put_nr_expl" VARCHAR (255),
    "x_put" DOUBLE PRECISION,
    "y_put" DOUBLE PRECISION,
    "z_put" DOUBLE PRECISION,
    "onderkant_pompfilter" DOUBLE PRECISION,
    "aquifercode_put" VARCHAR (255),
    "aquifer_beschr_put" VARCHAR (255),
    "gwlichaam_filter" VARCHAR (255),
    "gwsysteem_filter" VARCHAR (255)
);

ALTER TABLE "33 vmm nieuw" ADD CONSTRAINT "33 vmm nieuw_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "40 mv rondes" (
    "ronde" SERIAL,
    "klantnr" INTEGER,
    "silo" VARCHAR (255),
    "opzet" DATE,
    "aantal" INTEGER,
    "verkoop" DATE,
    "opm" TEXT
);

ALTER TABLE "40 mv rondes" ADD CONSTRAINT "40 mv rondes_pkey" PRIMARY KEY ("ronde");

CREATE TABLE IF NOT EXISTS "41 biggen" (
    "id" SERIAL,
    "ronde" INTEGER,
    "biggen" INTEGER,
    "leverancier" INTEGER,
    "opm" TEXT
);

ALTER TABLE "41 biggen" ADD CONSTRAINT "41 biggen_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "42 beh" (
    "id" SERIAL,
    "ronde" INTEGER,
    "behandeling" TEXT,
    "opm" TEXT
);

ALTER TABLE "42 beh" ADD CONSTRAINT "42 beh_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "50 voorschriften" (
    "id" SERIAL,
    "intern nummer" DOUBLE PRECISION,
    "datum voorschrift" TIMESTAMP WITHOUT TIME ZONE,
    "beslagadres code" DOUBLE PRECISION,
    "beslagadres" VARCHAR (255),
    "dierenarts code" DOUBLE PRECISION,
    "dierenarts" VARCHAR (255),
    "voorschrift dierenarts" VARCHAR (255),
    "soort dieren code" DOUBLE PRECISION,
    "soort dieren" VARCHAR (255),
    "ouderdom" VARCHAR (255),
    "aantal dieren" DOUBLE PRECISION,
    "silo" DOUBLE PRECISION,
    "medicamentnr 1" INTEGER,
    "medicament 1" VARCHAR (255),
    "dosage (kg/ton) 1" DOUBLE PRECISION,
    "medicamentnr 2" INTEGER,
    "medicament 2" VARCHAR (255),
    "dosage (kg/ton) 2" DOUBLE PRECISION,
    "medicamentnr 3" INTEGER,
    "medicament 3" VARCHAR (255),
    "dosage (kg/ton) 3" VARCHAR (255),
    "medicamentnr 4" INTEGER,
    "medicament 4" VARCHAR (255),
    "dosage (kg/ton) 4" VARCHAR (255),
    "productcode 1" DOUBLE PRECISION,
    "product 1" VARCHAR (255),
    "hoeveelheid (kg) 1" DOUBLE PRECISION,
    "ziektenr 1" DOUBLE PRECISION,
    "ziekte 1" VARCHAR (255),
    "ziektenr 2" DOUBLE PRECISION,
    "ziekte 2" VARCHAR (255),
    "ziektenr 3" VARCHAR (255),
    "ziekte 3" VARCHAR (255),
    "duur behandeling (dagen)" DOUBLE PRECISION,
    "certus kwaliteitslabel?" VARCHAR (255),
    "wachttijd" DOUBLE PRECISION,
    "wachttijd eenheid" VARCHAR (255),
    "certus diergroep code" DOUBLE PRECISION,
    "certus diergroep" VARCHAR (255)
);

ALTER TABLE "50 voorschriften" ADD CONSTRAINT "50 voorschriften_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "60 meststoffen" (
    "code" DOUBLE PRECISION,
    "type" VARCHAR (255),
    "meststof" VARCHAR (255),
    "vorm" VARCHAR (255),
    "dichtheid" DOUBLE PRECISION,
    "kg n/ton" DOUBLE PRECISION,
    "kg p₂o₅/ton" DOUBLE PRECISION,
    "nr uitbater" VARCHAR (255),
    "naam" VARCHAR (255),
    "nr uitbating" VARCHAR (255),
    "id" SERIAL,
    "jaar" DOUBLE PRECISION
);

ALTER TABLE "60 meststoffen" ADD CONSTRAINT "60 meststoffen_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "61 kunstmest op groeimedium" (
    "id" SERIAL,
    "code" DOUBLE PRECISION,
    "meststof" VARCHAR (255),
    "jaar" DOUBLE PRECISION
);

ALTER TABLE "61 kunstmest op groeimedium" ADD CONSTRAINT "61 kunstmest op groeimedium_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "62 diercategorieen" (
    "code" VARCHAR (255),
    "code diercategorie" VARCHAR (255),
    "diergroep" VARCHAR (255),
    "diercategorie" VARCHAR (255),
    "grazen" VARCHAR (255),
    "id" SERIAL,
    "jaar" DOUBLE PRECISION
);

ALTER TABLE "62 diercategorieen" ADD CONSTRAINT "62 diercategorieen_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "63 nub types" (
    "id" SERIAL,
    "code" VARCHAR (255),
    "nub" VARCHAR (255),
    "jaar" DOUBLE PRECISION
);

ALTER TABLE "63 nub types" ADD CONSTRAINT "63 nub types_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "64 pas maatregelen" (
    "id" SERIAL,
    "code" VARCHAR (255),
    "diergroep" VARCHAR (255),
    "code diercategorie" VARCHAR (255),
    "diercategorie" VARCHAR (255),
    "code staltype" VARCHAR (255),
    "staltype" VARCHAR (255),
    "code pas-maatregel" VARCHAR (255),
    "jaar" DOUBLE PRECISION,
    "pas-maatregel" VARCHAR (255),
    "veld9" VARCHAR (255)
);

ALTER TABLE "64 pas maatregelen" ADD CONSTRAINT "64 pas maatregelen_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "65 staltype" (
    "id" SERIAL,
    "code" VARCHAR (255),
    "staltype" VARCHAR (255),
    "jaar" DOUBLE PRECISION
);

ALTER TABLE "65 staltype" ADD CONSTRAINT "65 staltype_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "66 productiemethodes" (
    "id" SERIAL,
    "code" VARCHAR (255),
    "productiemethode" VARCHAR (255),
    "jaar" DOUBLE PRECISION
);

ALTER TABLE "66 productiemethodes" ADD CONSTRAINT "66 productiemethodes_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "factuurklanten" (
    "code adres" INTEGER,
    "landcode" VARCHAR (255),
    "omschrijving landcode" VARCHAR (255),
    "naam" VARCHAR (255),
    "prefix naam" VARCHAR (255),
    "adres" VARCHAR (255),
    "plaats" VARCHAR (255),
    "postcode" VARCHAR (255),
    "btw-nr" VARCHAR (255),
    "taalcode" VARCHAR (255),
    "fax" VARCHAR (255),
    "telefoon" VARCHAR (255),
    "email" VARCHAR (255),
    "gsm" VARCHAR (255),
    "ondernemingsnummer" VARCHAR (255),
    "url" VARCHAR (255),
    "code prijslijst" DOUBLE PRECISION,
    "geblokkeerd? (j of n)" VARCHAR (255),
    "bestelkorting? (j of n)" VARCHAR (255),
    "soort facturatie" VARCHAR (255),
    "code betaalvoorwaarde" DOUBLE PRECISION,
    "domiciliëring? (j of n)" VARCHAR (255),
    "omschrijving betaalvoorwaarde" VARCHAR (255),
    "btw-regime" VARCHAR (255),
    "mandaatreferte" VARCHAR (255),
    "id" SERIAL,
    "vertegenwoordiger" VARCHAR (255),
    "bestaat" BOOLEAN NOT NULL
);

ALTER TABLE "factuurklanten" ADD CONSTRAINT "factuurklanten_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "g attest mestbank" (
    "id" SERIAL,
    "klantnr" INTEGER,
    "diercode" INTEGER,
    "jaar" INTEGER,
    "hoev" DOUBLE PRECISION,
    "tot_re" DOUBLE PRECISION,
    "tot_p" DOUBLE PRECISION,
    "soort" VARCHAR (50),
    "best" BOOLEAN NOT NULL
);

ALTER TABLE "g attest mestbank" ADD CONSTRAINT "g attest mestbank_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "h attest mestbank lec" (
    "id" SERIAL,
    "klantnr" INTEGER,
    "diercode" INTEGER,
    "subcat" INTEGER,
    "jaar" INTEGER,
    "leverancier" VARCHAR (50),
    "hoev" DOUBLE PRECISION,
    "tot_re" DOUBLE PRECISION,
    "tot_p" DOUBLE PRECISION,
    "soort" VARCHAR (50),
    "periode" INTEGER
);

ALTER TABLE "h attest mestbank lec" ADD CONSTRAINT "h attest mestbank lec_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "leveranciers" (
    "code adres" DOUBLE PRECISION,
    "landcode" VARCHAR (255),
    "omschrijving landcode" VARCHAR (255),
    "naam" VARCHAR (255),
    "prefix naam" VARCHAR (255),
    "adres" VARCHAR (255),
    "plaats" VARCHAR (255),
    "postcode" DOUBLE PRECISION,
    "btw-nr" VARCHAR (255),
    "taalcode" VARCHAR (255),
    "fax" VARCHAR (255),
    "telefoon" VARCHAR (255),
    "email" VARCHAR (255),
    "gsm" VARCHAR (255),
    "ondernemingsnummer" DOUBLE PRECISION,
    "url" VARCHAR (255),
    "betaalwijze" VARCHAR (255),
    "geblokkeerd? (j of n)" VARCHAR (255),
    "code betaalvoorwaarde" DOUBLE PRECISION,
    "mandaatreferte" VARCHAR (255),
    "munt" VARCHAR (255),
    "omschrijving betaalvoorwaarde" VARCHAR (255),
    "btw-regime" VARCHAR (255),
    "type graanafrekening" VARCHAR (255),
    "code ontvangstnorm" DOUBLE PRECISION,
    "id" SERIAL,
    "omschrijving ontvangstnorm" VARCHAR (255),
    "test" VARCHAR (255),
    "adres2" VARCHAR (255),
    "bestaat" BOOLEAN NOT NULL,
    "granen" BOOLEAN NOT NULL
);

ALTER TABLE "leveranciers" ADD CONSTRAINT "leveranciers_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "leverplaatsen" (
    "code adres" INTEGER,
    "landcode" VARCHAR (255),
    "omschrijving landcode" VARCHAR (255),
    "naam" VARCHAR (255),
    "prefix naam" VARCHAR (255),
    "adres" VARCHAR (255),
    "plaats" VARCHAR (255),
    "postcode" VARCHAR (255),
    "btw-nr" VARCHAR (255),
    "taalcode" VARCHAR (255),
    "fax" VARCHAR (255),
    "telefoon" VARCHAR (255),
    "email" VARCHAR (255),
    "gsm" VARCHAR (255),
    "ondernemingsnummer" VARCHAR (255),
    "url" VARCHAR (255),
    "beslagnummer" VARCHAR (255),
    "code gekoppelde factuurklant" VARCHAR (255),
    "geblokkeerd? (j of n)" VARCHAR (255),
    "mestbanknummer" VARCHAR (255),
    "datum 1ste levering" VARCHAR (255),
    "jaar1stelev" INTEGER,
    "id" SERIAL,
    "vertegenwoordiger" VARCHAR (255),
    "bestaat" BOOLEAN NOT NULL,
    "mandaatreferentie" VARCHAR (255),
    "test" VARCHAR (255),
    "adres2" VARCHAR (255)
);

ALTER TABLE "leverplaatsen" ADD CONSTRAINT "leverplaatsen_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "lijst kl enkel 24" (
    "id" SERIAL,
    "klantnr" DOUBLE PRECISION,
    "naam" VARCHAR (255),
    "21" DOUBLE PRECISION,
    "24" DOUBLE PRECISION
);

ALTER TABLE "lijst kl enkel 24" ADD CONSTRAINT "lijst kl enkel 24_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "mestbankgegevens pl proplume" (
    "diercode" INTEGER,
    "klantnr" INTEGER,
    "artnr" INTEGER,
    "leverdatum" TIMESTAMP WITHOUT TIME ZONE,
    "hoev" INTEGER,
    "p" DOUBLE PRECISION,
    "re" DOUBLE PRECISION,
    "tot_p" DOUBLE PRECISION,
    "tot_re" DOUBLE PRECISION,
    "coppens" VARCHAR (255),
    "proplume" VARCHAR (255),
    "id" SERIAL
);

ALTER TABLE "mestbankgegevens pl proplume" ADD CONSTRAINT "mestbankgegevens pl proplume_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "n1 verliesnorm" (
    "id" SERIAL,
    "diercode" DOUBLE PRECISION,
    "omschrijving" VARCHAR (255),
    "uitleg" VARCHAR (255),
    "tra" DOUBLE PRECISION,
    "ea" DOUBLE PRECISION
);

ALTER TABLE "n1 verliesnorm" ADD CONSTRAINT "n1 verliesnorm_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "n4 ndruk gem" (
    "id" SERIAL,
    "idgem" INTEGER,
    "gemeente" VARCHAR (255),
    "ndruk" DOUBLE PRECISION
);

ALTER TABLE "n4 ndruk gem" ADD CONSTRAINT "n4 ndruk gem_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "producten" (
    "id" SERIAL,
    "code" INTEGER,
    "omschrijving nederlands" VARCHAR (255),
    "omschrijving frans" VARCHAR (255),
    "code producthoofdgroep" DOUBLE PRECISION,
    "code productgroep verkoop" DOUBLE PRECISION,
    "omschrijving producthoofdgroep" VARCHAR (255),
    "prijseenheid (vb: per 1000 kg)" DOUBLE PRECISION,
    "omschrijving productgroep verkoop" VARCHAR (255),
    "code eenheid" DOUBLE PRECISION,
    "omschrijving code eenheid" VARCHAR (255),
    "goederencode" VARCHAR (255),
    "code productgroep aankoop" DOUBLE PRECISION,
    "code statistische hoeveelheid" DOUBLE PRECISION,
    "omschrijving code statistische hoeveelheid" VARCHAR (255),
    "gekoppeld recept" VARCHAR (255),
    "omschrijving productgroep aankoop" VARCHAR (255),
    "oorsprong (aankoop of productie)" VARCHAR (255),
    "code producent" DOUBLE PRECISION,
    "omschrijving code producent" VARCHAR (255),
    "diersoort sanitel" DOUBLE PRECISION,
    "omschrijving diersoort sanitel" VARCHAR (255),
    "categorie mestbank" DOUBLE PRECISION,
    "omschrijving categorie mestbank" VARCHAR (255),
    "subcategorie mestbank" DOUBLE PRECISION,
    "omschrijving subcategorie mestbank" VARCHAR (255),
    "voedertype" VARCHAR (255),
    "geblokkeerd? (j of n)" VARCHAR (255),
    "code 1 -statistiekgroep" DOUBLE PRECISION,
    "omschrijving 1 -statistiekgroep" VARCHAR (255),
    "code 2 -statistiekgroep" DOUBLE PRECISION,
    "omschrijving 2 -statistiekgroep" VARCHAR (255),
    "code productvorm" DOUBLE PRECISION,
    "omschrijving productvorm" VARCHAR (255),
    "etiketbenaming nederlands" VARCHAR (255),
    "etiketbenaming frans" VARCHAR (255),
    "etiketbenaming ggo nederlands" VARCHAR (255),
    "etiketbenaming ggo frans" VARCHAR (255),
    "code bemefa" DOUBLE PRECISION,
    "als voedermiddel op etiket? (j of n)" VARCHAR (255),
    "omschrijving bemefa" VARCHAR (255),
    "prodcomcode" VARCHAR (255),
    "ccm in formule? (j of n)" VARCHAR (255),
    "% ccm" DOUBLE PRECISION,
    "basisformule" VARCHAR (255),
    "eiwit (%)" DOUBLE PRECISION,
    "eiwit (datum)" TIMESTAMP WITHOUT TIME ZONE,
    "eiwit (aanduiding laag eiwit convenant, le)" VARCHAR (255),
    "fosfor (%)" DOUBLE PRECISION,
    "fosfor (datum)" TIMESTAMP WITHOUT TIME ZONE,
    "fosfor (aanduiding laag fosfor, lp)" VARCHAR (255),
    "code 3 -statistiekgroep" DOUBLE PRECISION,
    "omschrijving 3 -statistiekgroep" VARCHAR (255),
    "code 4 -statistiekgroep" DOUBLE PRECISION,
    "omschrijving 4 -statistiekgroep" VARCHAR (255),
    "facturatie groep nummer" DOUBLE PRECISION,
    "facturatie groep omschrijving" VARCHAR (255),
    "bestaat" BOOLEAN NOT NULL
);

ALTER TABLE "producten" ADD CONSTRAINT "producten_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "switchboard items" (
    "switchboardid" INTEGER,
    "itemnumber" INTEGER,
    "itemtext" VARCHAR (255),
    "command" INTEGER,
    "argument" VARCHAR (255)
);

ALTER TABLE "switchboard items" ADD CONSTRAINT "switchboard items_pkey" PRIMARY KEY ("switchboardid", "itemnumber");

CREATE TABLE IF NOT EXISTS "tr br aanvoer" (
    "id" SERIAL,
    "nr burenregeling" DOUBLE PRECISION,
    "begin" TIMESTAMP WITHOUT TIME ZONE,
    "einde" TIMESTAMP WITHOUT TIME ZONE,
    "vorm" VARCHAR (255),
    "mest" VARCHAR (255),
    "ton" DOUBLE PRECISION,
    "kg p₂o₅/ton" DOUBLE PRECISION,
    "kg n" DOUBLE PRECISION,
    "kg n/ton" DOUBLE PRECISION,
    "kg p₂o₅" DOUBLE PRECISION,
    "naam aanbieder" VARCHAR (255),
    "nr landbouwer aanbieder" VARCHAR (255),
    "naam afnemer" VARCHAR (255),
    "nr uitbater/exploitant aanbieder" VARCHAR (255),
    "nr uitbating/exploitatie aanbieder" VARCHAR (255),
    "nr landbouwer afnemer" VARCHAR (255),
    "losplaats" VARCHAR (255),
    "nr uitbater/exploitant afnemer" VARCHAR (255),
    "nr uitbating/exploitatie afnemer" VARCHAR (255)
);

ALTER TABLE "tr br aanvoer" ADD CONSTRAINT "tr br aanvoer_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "tr br afvoer" (
    "id" SERIAL,
    "nr burenregeling" DOUBLE PRECISION,
    "begin" TIMESTAMP WITHOUT TIME ZONE,
    "einde" TIMESTAMP WITHOUT TIME ZONE,
    "vorm" VARCHAR (255),
    "mest" VARCHAR (255),
    "ton" DOUBLE PRECISION,
    "kg p₂o₅/ton" DOUBLE PRECISION,
    "kg n" DOUBLE PRECISION,
    "kg n/ton" DOUBLE PRECISION,
    "kg p₂o₅" DOUBLE PRECISION,
    "naam aanbieder" VARCHAR (255),
    "nr landbouwer aanbieder" VARCHAR (255),
    "naam afnemer" VARCHAR (255),
    "nr uitbater/exploitant aanbieder" VARCHAR (255),
    "nr uitbating/exploitatie aanbieder" VARCHAR (255),
    "nr landbouwer afnemer" VARCHAR (255),
    "losplaats" VARCHAR (255),
    "nr uitbater/exploitant afnemer" VARCHAR (255),
    "nr uitbating/exploitatie afnemer" VARCHAR (255)
);

ALTER TABLE "tr br afvoer" ADD CONSTRAINT "tr br afvoer_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "tr brm aanvoer" (
    "id" SERIAL,
    "nr burenregeling" DOUBLE PRECISION,
    "naam aanbieder" VARCHAR (255),
    "nr landbouwer aanbieder" VARCHAR (255),
    "naam afnemer" VARCHAR (255),
    "nr uitbater/exploitant aanbieder" VARCHAR (255),
    "nr uitbating/exploitatie aanbieder" VARCHAR (255),
    "nr landbouwer afnemer" VARCHAR (255),
    "losplaats" VARCHAR (255),
    "nr uitbater/exploitant afnemer" VARCHAR (255),
    "nr uitbating/exploitatie afnemer" VARCHAR (255),
    "meststof" VARCHAR (255),
    "datum vervoer" TIMESTAMP WITHOUT TIME ZONE,
    "voorgemelde hoeveelheid (ton)" DOUBLE PRECISION,
    "vrachten" DOUBLE PRECISION,
    "voorgemelde n (kg/ton)" DOUBLE PRECISION,
    "voorgemelde p₂o₅ (kg/ton)" DOUBLE PRECISION,
    "voorgemelde n (kg)" DOUBLE PRECISION,
    "voorgemelde p₂o₅ (kg)" DOUBLE PRECISION,
    "nagemelde hoeveelheid (ton)" DOUBLE PRECISION,
    "nagemeld aantal vrachten" DOUBLE PRECISION,
    "nagemelde n (kg)" DOUBLE PRECISION,
    "nagemelde n (kg/ton)" DOUBLE PRECISION,
    "nagemelde p₂o₅ (kg/ton)" DOUBLE PRECISION,
    "geannuleerd" BOOLEAN NOT NULL,
    "nagemelde p₂o₅ (kg)" DOUBLE PRECISION,
    "statustext" VARCHAR (255),
    "ts voormelding" TIMESTAMP WITHOUT TIME ZONE,
    "ts namelding" TIMESTAMP WITHOUT TIME ZONE
);

ALTER TABLE "tr brm aanvoer" ADD CONSTRAINT "tr brm aanvoer_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "tr ic aanvoer" (
    "id" SERIAL,
    "document" DOUBLE PRECISION,
    "naam inschaarder" VARCHAR (255),
    "nr landbouwer inschaarder" VARCHAR (255),
    "nr exploitant inschaarder" VARCHAR (255),
    "nr exploitatie inschaarder" VARCHAR (255),
    "naam houder" VARCHAR (255),
    "nr landbouwer houder" VARCHAR (255),
    "nr exploitant houder" VARCHAR (255),
    "nr exploitatie houder" VARCHAR (255),
    "diersoort" VARCHAR (255),
    "aantal" DOUBLE PRECISION,
    "begin" TIMESTAMP WITHOUT TIME ZONE,
    "einde" TIMESTAMP WITHOUT TIME ZONE,
    "kg p₂o₅" DOUBLE PRECISION,
    "kg n" DOUBLE PRECISION
);

ALTER TABLE "tr ic aanvoer" ADD CONSTRAINT "tr ic aanvoer_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "tr ic afvoer" (
    "id" SERIAL,
    "document" DOUBLE PRECISION,
    "naam inschaarder" VARCHAR (255),
    "nr landbouwer inschaarder" VARCHAR (255),
    "nr exploitant inschaarder" VARCHAR (255),
    "nr exploitatie inschaarder" VARCHAR (255),
    "naam houder" VARCHAR (255),
    "nr landbouwer houder" VARCHAR (255),
    "nr exploitant houder" VARCHAR (255),
    "nr exploitatie houder" VARCHAR (255),
    "diersoort" VARCHAR (255),
    "aantal" DOUBLE PRECISION,
    "begin" TIMESTAMP WITHOUT TIME ZONE,
    "einde" TIMESTAMP WITHOUT TIME ZONE,
    "kg p₂o₅" DOUBLE PRECISION,
    "kg n" DOUBLE PRECISION
);

ALTER TABLE "tr ic afvoer" ADD CONSTRAINT "tr ic afvoer_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "tr mad aanvoer" (
    "id" SERIAL,
    "document" DOUBLE PRECISION,
    "datum" TIMESTAMP WITHOUT TIME ZONE,
    "gereden" VARCHAR (255),
    "status" VARCHAR (255),
    "code" DOUBLE PRECISION,
    "type" VARCHAR (255),
    "mest" VARCHAR (255),
    "vorm" VARCHAR (255),
    "kg p₂o₅/ton" DOUBLE PRECISION,
    "kg n/ton" DOUBLE PRECISION,
    "vrachten" DOUBLE PRECISION,
    "ton/vracht" DOUBLE PRECISION,
    "ton" DOUBLE PRECISION,
    "kg p₂o₅" DOUBLE PRECISION,
    "kg n" DOUBLE PRECISION,
    "hoedanigheid aanbieder" VARCHAR (255),
    "naam aanbieder" VARCHAR (255),
    "nr landbouwer aanbieder" VARCHAR (255),
    "laadplaats" VARCHAR (255),
    "nr uitbater/exploitant aanbieder" VARCHAR (255),
    "nr uitbating/exploitatie aanbieder" VARCHAR (255),
    "hoedanigheid afnemer" VARCHAR (255),
    "naam afnemer" VARCHAR (255),
    "nr landbouwer afnemer" VARCHAR (255),
    "losplaats" VARCHAR (255),
    "nr uitbater/exploitant afnemer" VARCHAR (255),
    "nr uitbating/exploitatie afnemer" VARCHAR (255),
    "naam voerder" VARCHAR (255),
    "nr uitbating voerder" VARCHAR (255),
    "document vervolg" VARCHAR (255),
    "nummerplaat" VARCHAR (255),
    "overnachtplaats" VARCHAR (255),
    "datum vervolg" VARCHAR (255)
);

ALTER TABLE "tr mad aanvoer" ADD CONSTRAINT "tr mad aanvoer_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "tr mad afvoer" (
    "id" SERIAL,
    "document" DOUBLE PRECISION,
    "datum" TIMESTAMP WITHOUT TIME ZONE,
    "gereden" VARCHAR (255),
    "status" VARCHAR (255),
    "code" DOUBLE PRECISION,
    "type" VARCHAR (255),
    "mest" VARCHAR (255),
    "vorm" VARCHAR (255),
    "kg p₂o₅/ton" DOUBLE PRECISION,
    "kg n/ton" DOUBLE PRECISION,
    "vrachten" DOUBLE PRECISION,
    "ton/vracht" DOUBLE PRECISION,
    "ton" DOUBLE PRECISION,
    "kg p₂o₅" DOUBLE PRECISION,
    "kg n" DOUBLE PRECISION,
    "hoedanigheid aanbieder" VARCHAR (255),
    "naam aanbieder" VARCHAR (255),
    "nr landbouwer aanbieder" VARCHAR (255),
    "laadplaats" VARCHAR (255),
    "nr uitbater/exploitant aanbieder" VARCHAR (255),
    "nr uitbating/exploitatie aanbieder" VARCHAR (255),
    "hoedanigheid afnemer" VARCHAR (255),
    "naam afnemer" VARCHAR (255),
    "nr landbouwer afnemer" VARCHAR (255),
    "losplaats" VARCHAR (255),
    "nr uitbater/exploitant afnemer" VARCHAR (255),
    "nr uitbating/exploitatie afnemer" VARCHAR (255),
    "naam voerder" VARCHAR (255),
    "nr uitbating voerder" VARCHAR (255),
    "document vervolg" VARCHAR (255),
    "nummerplaat" VARCHAR (255),
    "overnachtplaats" VARCHAR (255),
    "datum vervolg" TIMESTAMP WITHOUT TIME ZONE
);

ALTER TABLE "tr mad afvoer" ADD CONSTRAINT "tr mad afvoer_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "tr over aanvoer" (
    "id" SERIAL,
    "document" DOUBLE PRECISION,
    "datum" TIMESTAMP WITHOUT TIME ZONE,
    "gereden" VARCHAR (255),
    "status" VARCHAR (255),
    "code" DOUBLE PRECISION,
    "type" VARCHAR (255),
    "mest" VARCHAR (255),
    "vorm" VARCHAR (255),
    "kg p₂o₅/ton" DOUBLE PRECISION,
    "kg n/ton" DOUBLE PRECISION,
    "vrachten" DOUBLE PRECISION,
    "ton/vracht" DOUBLE PRECISION,
    "ton" DOUBLE PRECISION,
    "kg p₂o₅" DOUBLE PRECISION,
    "kg n" DOUBLE PRECISION,
    "hoedanigheid aanbieder" VARCHAR (255),
    "naam aanbieder" VARCHAR (255),
    "nr landbouwer aanbieder" VARCHAR (255),
    "laadplaats" VARCHAR (255),
    "nr uitbater/exploitant aanbieder" VARCHAR (255),
    "nr uitbating/exploitatie aanbieder" VARCHAR (255),
    "hoedanigheid afnemer" VARCHAR (255),
    "naam afnemer" VARCHAR (255),
    "nr landbouwer afnemer" VARCHAR (255),
    "losplaats" VARCHAR (255),
    "nr uitbater/exploitant afnemer" VARCHAR (255),
    "nr uitbating/exploitatie afnemer" VARCHAR (255),
    "naam voerder" VARCHAR (255),
    "nr uitbating voerder" VARCHAR (255),
    "document vervolg" VARCHAR (255),
    "nummerplaat" VARCHAR (255),
    "overnachtplaats" VARCHAR (255),
    "datum vervolg" VARCHAR (255)
);

ALTER TABLE "tr over aanvoer" ADD CONSTRAINT "tr over aanvoer_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "tr over afvoer" (
    "id" SERIAL,
    "document" DOUBLE PRECISION,
    "datum" TIMESTAMP WITHOUT TIME ZONE,
    "gereden" VARCHAR (255),
    "status" VARCHAR (255),
    "code" DOUBLE PRECISION,
    "type" VARCHAR (255),
    "mest" VARCHAR (255),
    "vorm" VARCHAR (255),
    "kg p₂o₅/ton" DOUBLE PRECISION,
    "kg n/ton" DOUBLE PRECISION,
    "vrachten" DOUBLE PRECISION,
    "ton/vracht" DOUBLE PRECISION,
    "ton" DOUBLE PRECISION,
    "kg p₂o₅" DOUBLE PRECISION,
    "kg n" DOUBLE PRECISION,
    "hoedanigheid aanbieder" VARCHAR (255),
    "naam aanbieder" VARCHAR (255),
    "nr landbouwer aanbieder" VARCHAR (255),
    "laadplaats" VARCHAR (255),
    "nr uitbater/exploitant aanbieder" VARCHAR (255),
    "nr uitbating/exploitatie aanbieder" VARCHAR (255),
    "hoedanigheid afnemer" VARCHAR (255),
    "naam afnemer" VARCHAR (255),
    "nr landbouwer afnemer" VARCHAR (255),
    "losplaats" VARCHAR (255),
    "nr uitbater/exploitant afnemer" VARCHAR (255),
    "nr uitbating/exploitatie afnemer" VARCHAR (255),
    "naam voerder" VARCHAR (255),
    "nr uitbating voerder" VARCHAR (255),
    "document vervolg" VARCHAR (255),
    "nummerplaat" VARCHAR (255),
    "overnachtplaats" VARCHAR (255),
    "datum vervolg" VARCHAR (255)
);

ALTER TABLE "tr over afvoer" ADD CONSTRAINT "tr over afvoer_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "zab_med_varkensmeel" (
    "beslagadres code" DOUBLE PRECISION,
    "datum voorschrift" TIMESTAMP WITHOUT TIME ZONE,
    "beslagadres" VARCHAR (255),
    "dierenarts" VARCHAR (255),
    "dierenarts code" DOUBLE PRECISION,
    "medicament 1" VARCHAR (255),
    "voorschrift dierenarts" VARCHAR (255),
    "medicament 2" VARCHAR (255),
    "medicament 3" VARCHAR (255),
    "duur behandeling (dagen)" DOUBLE PRECISION,
    "medicament 4" VARCHAR (255),
    "certus diergroep code" DOUBLE PRECISION,
    "certus kwaliteitslabel?" VARCHAR (255),
    "certus diergroep" VARCHAR (255),
    "id" SERIAL,
    "productcode 1" DOUBLE PRECISION
);

ALTER TABLE "zab_med_varkensmeel" ADD CONSTRAINT "zab_med_varkensmeel_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "01 gem periode" (
    "id" SERIAL,
    "jaar" INTEGER,
    "ndruk" INTEGER
);

ALTER TABLE "01 gem periode" ADD CONSTRAINT "01 gem periode_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "03 erk transporteurs" (
    "id" SERIAL,
    "klantnr" INTEGER,
    "transportnr" VARCHAR (50)
);

ALTER TABLE "03 erk transporteurs" ADD CONSTRAINT "03 erk transporteurs_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "03 soort mvc" (
    "id" INTEGER,
    "soort" VARCHAR (50)
);

ALTER TABLE "03 soort mvc" ADD CONSTRAINT "03 soort mvc_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "090 eenheden" (
    "id" INTEGER,
    "eenheid" VARCHAR (50)
);

ALTER TABLE "090 eenheden" ADD CONSTRAINT "090 eenheden_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "10 melkvee" (
    row_id SERIAL PRIMARY KEY,
    "id" SERIAL,
    "klantnr" INTEGER,
    "trapjaar" INTEGER,
    "diercode" DOUBLE PRECISION,
    "aantaltrap" INTEGER,
    "melkq" INTEGER,
    "leveringen" INTEGER,
    "melkkg" NUMERIC (28, 2),
    "melkgifte" NUMERIC (28, 2),
    "jaar" INTEGER,
    "aantal" INTEGER,
    "derogatie" BOOLEAN NOT NULL,
    "voorw1" DOUBLE PRECISION,
    "voorw2" DOUBLE PRECISION,
    "p2o5" DOUBLE PRECISION,
    "n" DOUBLE PRECISION,
    "n eind" DOUBLE PRECISION,
    "somvanvg" DOUBLE PRECISION,
    "somvgg" DOUBLE PRECISION,
    "nvoorw1" DOUBLE PRECISION,
    "pvoorw1" DOUBLE PRECISION,
    "nvoorw2" DOUBLE PRECISION,
    "pvoorw2" DOUBLE PRECISION,
    "pmax" DOUBLE PRECISION,
    "nmax" DOUBLE PRECISION,
    "pprod" DOUBLE PRECISION,
    "nprod" DOUBLE PRECISION,
    "bestaat" VARCHAR (50)
);

CREATE TABLE IF NOT EXISTS "15 afzet mest" (
    "klantnr" INTEGER NOT NULL,
    "jaartal" INTEGER NOT NULL,
    "type afzet" INTEGER NOT NULL,
    "omschrijving" VARCHAR (50),
    "hoev" DOUBLE PRECISION,
    "n" DOUBLE PRECISION,
    "p2o5" DOUBLE PRECISION,
    "werkzamen" DOUBLE PRECISION,
    "ingave" VARCHAR (50),
    "bestaat" VARCHAR (50)
);

ALTER TABLE "15 afzet mest" ADD CONSTRAINT "15 afzet mest_pkey" PRIMARY KEY ("klantnr", "jaartal", "type afzet");

CREATE TABLE IF NOT EXISTS "2017 pl staltypes" (
    "code" VARCHAR (255),
    "id" SERIAL,
    "staltype" VARCHAR (255)
);

ALTER TABLE "2017 pl staltypes" ADD CONSTRAINT "2017 pl staltypes_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "2017 teelten" (
    "code" VARCHAR (255),
    "id" SERIAL,
    "teelt" VARCHAR (255)
);

ALTER TABLE "2017 teelten" ADD CONSTRAINT "2017 teelten_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "21 soort afzet spui" (
    "id" SERIAL,
    "omschrijving" VARCHAR (50)
);

ALTER TABLE "21 soort afzet spui" ADD CONSTRAINT "21 soort afzet spui_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "22 voedergewassen" (
    "id" SERIAL,
    "omschrijving" VARCHAR (50),
    "omrekeningha" DOUBLE PRECISION
);

ALTER TABLE "22 voedergewassen" ADD CONSTRAINT "22 voedergewassen_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "27 convenant" (
    row_id SERIAL PRIMARY KEY,
    "diercode" INTEGER,
    "jaar" INTEGER,
    "iddier" INTEGER,
    "omschrijving" VARCHAR (50),
    "maxp" DOUBLE PRECISION,
    "maxre" DOUBLE PRECISION
);

CREATE TABLE IF NOT EXISTS "30 water" (
    "id" SERIAL,
    "watercode" INTEGER,
    "omschrijving" VARCHAR (50),
    "verbruik" DOUBLE PRECISION,
    "vmm" DOUBLE PRECISION
);

ALTER TABLE "30 water" ADD CONSTRAINT "30 water_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "33" (
    "id" SERIAL,
    "putnummer" VARCHAR (255),
    "installatienummer" DOUBLE PRECISION,
    "locatie grondwaterput adres" VARCHAR (255),
    "locatie grondwaterput xy-coördinaten" VARCHAR (255),
    "vergunde diepte" DOUBLE PRECISION,
    "watervoerende laag (hydrogeologische hoofdeenheid)" VARCHAR (255),
    "vergunde hoeveelheid grondwater (m³/dag)" VARCHAR (255),
    "vergunde hoeveelheid grondwater (m³/jaar)" DOUBLE PRECISION,
    "exploitant_id_aow" DOUBLE PRECISION,
    "vergunning_id_aow" DOUBLE PRECISION,
    "installatie_id_aow" DOUBLE PRECISION,
    "watnr_aow" VARCHAR (255),
    "vmm_dossier" VARCHAR (255),
    "cbb_xtant" VARCHAR (255),
    "cbb_xtie" VARCHAR (255),
    "nacebel_code" VARCHAR (255),
    "nacebel" VARCHAR (255),
    "naam_exploitant" VARCHAR (255),
    "adres_exploitant" VARCHAR (255),
    "gemeente_exploitant" VARCHAR (255),
    "begin_datum_verg" TIMESTAMP WITHOUT TIME ZONE,
    "eind_datum_verg" TIMESTAMP WITHOUT TIME ZONE,
    "van_datum_termijn" TIMESTAMP WITHOUT TIME ZONE,
    "tot_datum_termijn" TIMESTAMP WITHOUT TIME ZONE,
    "datum_van" TIMESTAMP WITHOUT TIME ZONE,
    "datum_tot" TIMESTAMP WITHOUT TIME ZONE,
    "vergund_debiet_dag" DOUBLE PRECISION,
    "vergund_debiet_jr" DOUBLE PRECISION,
    "klasse" VARCHAR (255),
    "vlarem_rubriek_code" VARCHAR (255),
    "bestemming1" VARCHAR (255),
    "bestemming2" VARCHAR (255),
    "bestemming3" VARCHAR (255),
    "bestemming4" VARCHAR (255),
    "vergund_aantal_putten" DOUBLE PRECISION,
    "vergunde_diepte" DOUBLE PRECISION,
    "gemeente_inst" VARCHAR (255),
    "postcode_inst" DOUBLE PRECISION,
    "adres_inst" VARCHAR (255),
    "kadaster" VARCHAR (255),
    "inst_x" DOUBLE PRECISION,
    "inst_y" DOUBLE PRECISION,
    "inst_z" DOUBLE PRECISION,
    "aard_winning" DOUBLE PRECISION,
    "aard_winning_beschr" VARCHAR (255),
    "aquifer_code_inst" VARCHAR (255),
    "aquifer_beschr_inst" VARCHAR (255),
    "gwlichaam_inst" VARCHAR (255),
    "gwsysteem_inst" VARCHAR (255),
    "gespannen?" DOUBLE PRECISION,
    "heffinggebied" VARCHAR (255),
    "put_id_aow" DOUBLE PRECISION,
    "put_nummer_aow" VARCHAR (255),
    "put_nr_expl" VARCHAR (255),
    "x_put" DOUBLE PRECISION,
    "y_put" DOUBLE PRECISION,
    "z_put" DOUBLE PRECISION,
    "onderkant_pompfilter" DOUBLE PRECISION,
    "aquifercode_put" VARCHAR (255),
    "aquifer_beschr_put" VARCHAR (255),
    "gwlichaam_filter" VARCHAR (255),
    "gwsysteem_filter" VARCHAR (255)
);

ALTER TABLE "33" ADD CONSTRAINT "33_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "43 cert" (
    "id" SERIAL,
    "klantnr" INTEGER,
    "certificering" VARCHAR (255),
    "aanvraag" DATE,
    "toekenning" DATE,
    "tot" DATE,
    "certificaat" VARCHAR (255)
);

ALTER TABLE "43 cert" ADD CONSTRAINT "43 cert_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "68 spuistroom" (
    "id" SERIAL,
    "code" VARCHAR (255),
    "spuistroom" VARCHAR (255),
    "jaar" DOUBLE PRECISION
);

ALTER TABLE "68 spuistroom" ADD CONSTRAINT "68 spuistroom_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "mestbankgegevens" (
    "diercode" INTEGER,
    "klantnr" INTEGER,
    "artnr" DOUBLE PRECISION,
    "leverdatum" TIMESTAMP WITHOUT TIME ZONE,
    "hoev" INTEGER,
    "p" DOUBLE PRECISION,
    "re" DOUBLE PRECISION,
    "tot_p" DOUBLE PRECISION,
    "tot_re" DOUBLE PRECISION,
    "gemed" VARCHAR (255),
    "id" SERIAL,
    "voorschrift" VARCHAR (255),
    "proplume" VARCHAR (255),
    "coppens" VARCHAR (255)
);

ALTER TABLE "mestbankgegevens" ADD CONSTRAINT "mestbankgegevens_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "n2 dieren map3" (
    "id" SERIAL,
    "diersoort" DOUBLE PRECISION,
    "omschrijving" VARCHAR (255),
    "ondergrens" DOUBLE PRECISION,
    "bovengrens" DOUBLE PRECISION,
    "p2o5" DOUBLE PRECISION,
    "n (2007)" DOUBLE PRECISION,
    "n (2008)" DOUBLE PRECISION,
    "n (2009)" DOUBLE PRECISION,
    "n (2010)" DOUBLE PRECISION
);

ALTER TABLE "n2 dieren map3" ADD CONSTRAINT "n2 dieren map3_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "tr brm afvoer" (
    "id" SERIAL,
    "nr burenregeling" DOUBLE PRECISION,
    "naam aanbieder" VARCHAR (255),
    "nr landbouwer aanbieder" VARCHAR (255),
    "naam afnemer" VARCHAR (255),
    "nr uitbater/exploitant aanbieder" VARCHAR (255),
    "nr uitbating/exploitatie aanbieder" VARCHAR (255),
    "nr landbouwer afnemer" VARCHAR (255),
    "losplaats" VARCHAR (255),
    "nr uitbater/exploitant afnemer" VARCHAR (255),
    "nr uitbating/exploitatie afnemer" VARCHAR (255),
    "meststof" VARCHAR (255),
    "datum vervoer" TIMESTAMP WITHOUT TIME ZONE,
    "voorgemelde hoeveelheid (ton)" DOUBLE PRECISION,
    "vrachten" DOUBLE PRECISION,
    "voorgemelde n (kg/ton)" DOUBLE PRECISION,
    "voorgemelde p₂o₅ (kg/ton)" DOUBLE PRECISION,
    "voorgemelde n (kg)" DOUBLE PRECISION,
    "voorgemelde p₂o₅ (kg)" DOUBLE PRECISION,
    "nagemelde hoeveelheid (ton)" DOUBLE PRECISION,
    "nagemeld aantal vrachten" DOUBLE PRECISION,
    "nagemelde n (kg)" DOUBLE PRECISION,
    "nagemelde n (kg/ton)" DOUBLE PRECISION,
    "nagemelde p₂o₅ (kg/ton)" DOUBLE PRECISION,
    "geannuleerd" BOOLEAN NOT NULL,
    "nagemelde p₂o₅ (kg)" DOUBLE PRECISION,
    "statustext" VARCHAR (255),
    "ts voormelding" TIMESTAMP WITHOUT TIME ZONE,
    "ts namelding" TIMESTAMP WITHOUT TIME ZONE
);

ALTER TABLE "tr brm afvoer" ADD CONSTRAINT "tr brm afvoer_pkey" PRIMARY KEY ("id");

CREATE TABLE IF NOT EXISTS "15" (
    row_id SERIAL PRIMARY KEY,
    "bedrijfsgroep" VARCHAR (50),
    "somvann" DOUBLE PRECISION,
    "jaartal" INTEGER
);

CREATE TABLE IF NOT EXISTS "1" (
    row_id SERIAL PRIMARY KEY,
    "eerstevanklantnr" INTEGER,
    "bedrijfsgroep" VARCHAR (50)
);
