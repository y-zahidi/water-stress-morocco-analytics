-- ============================================================
-- DIMENSION TABLES - Water Stress Morocco Analytics
-- Author: Mohammed Taha BENMAHI, Yassir ZAHIDI  
-- Purpose: Reference data for star schema
-- ============================================================

-- Regions dimension (12 administrative regions)
CREATE TABLE regions (
    region_id INT NOT NULL AUTO_INCREMENT,
    nom_region VARCHAR(100) NOT NULL,
    population BIGINT,
    superficie_km2 DECIMAL(12,2),
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (region_id),
    UNIQUE KEY uk_region_nom (nom_region),
    INDEX idx_region_population (population)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
COMMENT='Morocco administrative regions with demographics';

-- Cities dimension (46 major cities)
CREATE TABLE villes (
    ville_id INT NOT NULL AUTO_INCREMENT,
    region_id INT NOT NULL,
    nom_ville VARCHAR(120) NOT NULL,
    population_est BIGINT,
    date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (ville_id),
    FOREIGN KEY (region_id) REFERENCES regions(region_id)
        ON DELETE RESTRICT 
        ON UPDATE CASCADE,
    UNIQUE KEY uk_ville_region (region_id, nom_ville),
    INDEX idx_ville_region (region_id),
    INDEX idx_ville_nom (nom_ville)
) ENGINE=InnoDB
COMMENT='Major Moroccan cities linked to parent regions';

-- Time dimension (131 months: 2015-01 to 2025-11)
CREATE TABLE dim_mois (
    mois_id INT NOT NULL,  -- Format: YYYYMM (e.g., 202512)
    date_debut DATE NOT NULL,
    annee SMALLINT NOT NULL,
    mois TINYINT NOT NULL,
    trimestre TINYINT NOT NULL,
    mois_nom_fr VARCHAR(15) NOT NULL,
    
    PRIMARY KEY (mois_id),
    UNIQUE KEY uk_annee_mois (annee, mois),
    INDEX idx_annee (annee),
    INDEX idx_mois (mois)
) ENGINE=InnoDB
COMMENT='Time dimension covering Jan 2015 to Nov 2025';

-- Economic sectors dimension (4 sectors)
CREATE TABLE secteurs_consommation (
    secteur_id INT NOT NULL AUTO_INCREMENT,
    nom_secteur VARCHAR(50) NOT NULL,
    description_secteur TEXT,
    
    PRIMARY KEY (secteur_id),
    UNIQUE KEY uk_secteur_nom (nom_secteur)
) ENGINE=InnoDB
COMMENT='Four economic sectors: Agriculture, Industry, Domestic, Services';

-- Sample data inserts
INSERT INTO secteurs_consommation (nom_secteur, description_secteur) VALUES
('Agriculture', 'Irrigation, livestock, aquaculture'),
('Industrie', 'Manufacturing, mining, processing'),
('Domestique', 'Urban and rural households, drinking water'),
('Services', 'Offices, retail, hotels, hospitals');
