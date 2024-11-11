CREATE OR REPLACE TABLE rewardsReceiptItems (
    id INT AUTO_INCREMENT PRIMARY KEY,
    receiptId VARCHAR(24),
    barcode VARCHAR(50),
    description TEXT,
    finalPrice FLOAT,
    itemPrice FLOAT,
    needsFetchReview BOOLEAN,
    partnerItemId VARCHAR(50),
    preventTargetGapPoints BOOLEAN,
    quantityPurchased INT,
    userFlaggedBarcode VARCHAR(50),
    userFlaggedNewItem BOOLEAN,
    userFlaggedPrice FLOAT,
    userFlaggedQuantity INT,
    FOREIGN KEY (receiptId) REFERENCES receipts(id)
);