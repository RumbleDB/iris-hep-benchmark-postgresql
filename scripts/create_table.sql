-- Drop the table if it already exists
DROP TABLE IF EXISTS Run2012B_SingleMu CASCADE;
DROP TYPE IF EXISTS metType, hltType, pvType, muonType, electronType, photonType, jetType, tauType, eventType CASCADE;

-- Creates the `Run2012B_SingleMu` schema
CREATE TABLE  IF NOT EXISTS Run2012B_SingleMu (
	run  INTEGER,
	luminosityBlock  BIGINT,
	event  BIGINT,
	HLT_IsoMu24_eta2p1  BOOLEAN,
	HLT_IsoMu24  BOOLEAN,
	HLT_IsoMu17_eta2p1_LooseIsoPFTau20  BOOLEAN,
	PV_npvs  INTEGER,
	PV_x  DOUBLE PRECISION,
	PV_y  DOUBLE PRECISION,
	PV_z  DOUBLE PRECISION,
	nMuon  BIGINT,
	nElectron  BIGINT,
	nTau  BIGINT,
	nPhoton  BIGINT,
	MET_pt  DOUBLE PRECISION,
	MET_phi  DOUBLE PRECISION,
	MET_sumet  DOUBLE PRECISION,
	MET_significance  DOUBLE PRECISION,
	MET_CovXX  DOUBLE PRECISION,
	MET_CovXY  DOUBLE PRECISION,
	MET_CovYY  DOUBLE PRECISION,
	nJet  BIGINT,
	Muon_pt  DOUBLE PRECISION [],
	Muon_eta  DOUBLE PRECISION [],
	Muon_phi  DOUBLE PRECISION [],
	Muon_mass  DOUBLE PRECISION [],
	Muon_charge  INTEGER [],
	Muon_pfRelIso03_all  DOUBLE PRECISION [],
	Muon_pfRelIso04_all  DOUBLE PRECISION [],
	Muon_tightId  BOOLEAN [],
	Muon_softId  BOOLEAN [],
	Muon_dxy  DOUBLE PRECISION [],
	Muon_dxyErr  DOUBLE PRECISION [],
	Muon_dz  DOUBLE PRECISION [],
	Muon_dzErr  DOUBLE PRECISION [],
	Muon_jetIdx  INTEGER [],
	Muon_genPartIdx  INTEGER [],
	Electron_pt  DOUBLE PRECISION [],
	Electron_eta  DOUBLE PRECISION [],
	Electron_phi  DOUBLE PRECISION [],
	Electron_mass  DOUBLE PRECISION [],
	Electron_charge  INTEGER [],
	Electron_pfRelIso03_all  DOUBLE PRECISION [],
	Electron_dxy  DOUBLE PRECISION [],
	Electron_dxyErr  DOUBLE PRECISION [],
	Electron_dz  DOUBLE PRECISION [],
	Electron_dzErr  DOUBLE PRECISION [],
	Electron_cutBasedId  BOOLEAN [],
	Electron_pfId  BOOLEAN [],
	Electron_jetIdx  INTEGER [],
	Electron_genPartIdx  INTEGER [],
	Tau_pt  DOUBLE PRECISION [],
	Tau_eta  DOUBLE PRECISION [],
	Tau_phi  DOUBLE PRECISION [],
	Tau_mass  DOUBLE PRECISION [],
	Tau_charge  INTEGER [],
	Tau_decayMode  INTEGER [],
	Tau_relIso_all  DOUBLE PRECISION [],
	Tau_jetIdx  INTEGER [],
	Tau_genPartIdx  INTEGER [],
	Tau_idDecayMode  BOOLEAN [],
	Tau_idIsoRaw  DOUBLE PRECISION [],
	Tau_idIsoVLoose  BOOLEAN [],
	Tau_idIsoLoose  BOOLEAN [],
	Tau_idIsoMedium  BOOLEAN [],
	Tau_idIsoTight  BOOLEAN [],
	Tau_idAntiEleLoose  BOOLEAN [],
	Tau_idAntiEleMedium  BOOLEAN [],
	Tau_idAntiEleTight  BOOLEAN [],
	Tau_idAntiMuLoose  BOOLEAN [],
	Tau_idAntiMuMedium  BOOLEAN [],
	Tau_idAntiMuTight  BOOLEAN [],
	Photon_pt  DOUBLE PRECISION [],
	Photon_eta  DOUBLE PRECISION [],
	Photon_phi  DOUBLE PRECISION [],
	Photon_mass  DOUBLE PRECISION [],
	Photon_charge  INTEGER [],
	Photon_pfRelIso03_all  DOUBLE PRECISION [],
	Photon_jetIdx  INTEGER [],
	Photon_genPartIdx  INTEGER [],
	Jet_pt  DOUBLE PRECISION [],
	Jet_eta  DOUBLE PRECISION [],
	Jet_phi  DOUBLE PRECISION [],
	Jet_mass  DOUBLE PRECISION [],
	Jet_puId  BOOLEAN [],
	Jet_btag  DOUBLE PRECISION []
);

-- Create the particle types
CREATE TYPE metType AS (
    pt             DOUBLE PRECISION,
    phi            DOUBLE PRECISION,
    sumet          DOUBLE PRECISION,
    significance   DOUBLE PRECISION,
    CovXX          DOUBLE PRECISION,
    CovXY          DOUBLE PRECISION,
    CovYY          DOUBLE PRECISION
);

CREATE TYPE hltType AS (
    IsoMu24_eta2p1                 BOOLEAN,
    IsoMu24                        BOOLEAN,
    IsoMu17_eta2p1_LooseIsoPFTau20 BOOLEAN
);

CREATE TYPE pvType AS (
    npvs   INTEGER,
    x      DOUBLE PRECISION,
    y      DOUBLE PRECISION,
    z      DOUBLE PRECISION
);

CREATE TYPE muonType AS (
    pt             DOUBLE PRECISION,
    eta            DOUBLE PRECISION,
    phi            DOUBLE PRECISION,
    mass           DOUBLE PRECISION,
    charge         INTEGER,
    pfRelIso03_all DOUBLE PRECISION,
    pfRelIso04_all DOUBLE PRECISION,
    tightId        BOOLEAN,
    softId         BOOLEAN,
    dxy            DOUBLE PRECISION,
    dxyErr         DOUBLE PRECISION,
    dz             DOUBLE PRECISION,
    dzErr          DOUBLE PRECISION,
    jetIdx		   INTEGER,
    genPartIdx     INTEGER
);

CREATE TYPE electronType AS (
    pt             DOUBLE PRECISION,
    eta            DOUBLE PRECISION,
    phi            DOUBLE PRECISION,
    mass           DOUBLE PRECISION,
    charge         INTEGER,
    pfRelIso03_all DOUBLE PRECISION,
    dxy            DOUBLE PRECISION,
    dxyErr         DOUBLE PRECISION,
    dz             DOUBLE PRECISION,
    dzErr          DOUBLE PRECISION,
    cutBasedId     BOOLEAN,
    pfId           BOOLEAN,
    jetIdx    	   INTEGER,
    genPartIdx     INTEGER
);

CREATE TYPE photonType AS (
    pt             DOUBLE PRECISION,
    eta            DOUBLE PRECISION,
    phi            DOUBLE PRECISION,
    mass           DOUBLE PRECISION,
    charge         INTEGER,
    pfRelIso03_all DOUBLE PRECISION,
    jetIdx  	   INTEGER,
    genPartIdx     INTEGER
);

CREATE TYPE jetType AS (
    pt     DOUBLE PRECISION,
    eta    DOUBLE PRECISION,
    phi    DOUBLE PRECISION,
    mass   DOUBLE PRECISION,
    puId   BOOLEAN,
    btag   DOUBLE PRECISION
);

CREATE TYPE tauType AS (
    pt                 DOUBLE PRECISION,
    eta                DOUBLE PRECISION,
    phi                DOUBLE PRECISION,
    mass               DOUBLE PRECISION,
    charge             INTEGER,
    decayMode          INTEGER,
    relIso_all         DOUBLE PRECISION,  -- XXX This attribute contains null values. Not sure why...
    jetIdx             INTEGER,
    genPartIdx         INTEGER,
    idDecayMode        BOOLEAN,
    idIsoRaw           DOUBLE PRECISION,
    idIsoVLoose        BOOLEAN,
    idIsoLoose         BOOLEAN,
    idIsoMedium        BOOLEAN,
    idIsoTight         BOOLEAN,
    idAntiEleLoose     BOOLEAN,
    idAntiEleMedium    BOOLEAN,
    idAntiEleTight     BOOLEAN,
    idAntiMuLoose      BOOLEAN,
    idAntiMuMedium     BOOLEAN,
    idAntiMuTight      BOOLEAN
);

CREATE TYPE eventType AS (
    run                INTEGER,
    luminosityBlock    BIGINT,
    event              BIGINT,
    MET                metType,
    HLT                hltType,
    PV                 pvType,
    Muon               muonType [],
    Electron           electronType [],
    Photon             photonType [],
    Jet                jetType [],
    Tau                tauType []
);


-- SELECT event, array( (SELECT ROW(Muon_pt, Muon_eta) FROM UNNEST(Muon_pt, Muon_eta)) ) AS arr FROM Run2012B_SingleMu;

-- Create the view
CREATE VIEW Run2012B_SingleMu_event AS
SELECT RUN, 
	   luminosityBlock, 
	   event,
	   CAST (ROW(MET_pt, MET_phi, MET_sumet, MET_significance, MET_CovXX, MET_CovXY, MET_CovYY) AS metType) AS MET,
	   CAST (ROW(HLT_IsoMu24_eta2p1, HLT_IsoMu24, HLT_IsoMu17_eta2p1_LooseIsoPFTau20) AS hltType) AS HLT,
	   CAST (ROW(PV_npvs, PV_x, PV_y, PV_z) AS pvType) AS PV,
	   array(
	   	(SELECT CAST(ROW(pt,eta,phi,mass,charge,pfRelIso03_all,pfRelIso04_all,tightId,softId,dxy,dxyErr,dz,dzErr,jetIdx,genPartIdx) AS muonType) FROM UNNEST(Muon_pt, Muon_eta, Muon_phi, Muon_mass, Muon_charge, Muon_pfRelIso03_all, Muon_pfRelIso04_all, Muon_tightId, Muon_softId, Muon_dxy, Muon_dxyErr, Muon_dz, Muon_dzErr, Muon_jetIdx, Muon_genPartIdx) AS t(pt,eta,phi,mass,charge,pfRelIso03_all,pfRelIso04_all,tightId,softId,dxy,dxyErr,dz,dzErr,jetIdx,genPartIdx))
	   ) AS Muon
FROM Run2012B_SingleMu;


-- Import the data into the DB
COPY Run2012B_SingleMu FROM '/home/dan/data/garbage/iris-hep-benchmark-postgresql/data/Run2012B_SingleMu-1000.csv' WITH (FORMAT csv, HEADER, ENCODING 'UTF-8');