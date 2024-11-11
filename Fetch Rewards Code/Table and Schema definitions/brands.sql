CREATE OR REPLACE TABLE brands (
    id VARCHAR(24) PRIMARY KEY,
    barcode VARCHAR(50),
    brandCode VARCHAR(255),
    category VARCHAR(255),
    categoryCode VARCHAR(255),
    cpg_id VARCHAR(24),
    cpg_ref VARCHAR(50),
    name VARCHAR(255),
    topBrand BOOLEAN
);