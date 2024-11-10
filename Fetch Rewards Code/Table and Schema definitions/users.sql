CREATE OR REPLACE TABLE users (
    id VARCHAR(24),
    state VARCHAR(10),
    createdDate DATETIME,
    lastLogin DATETIME,
    role VARCHAR(50),
    active BOOLEAN
);