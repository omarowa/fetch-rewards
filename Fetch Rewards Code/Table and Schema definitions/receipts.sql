CREATE OR REPLACE TABLE fetch.receipts (
    id VARCHAR(24) PRIMARY KEY,
    bonusPointsEarned INT,
    bonusPointsEarnedReason TEXT,
    createDate DATETIME,
    dateScanned DATETIME,
    finishedDate DATETIME,
    modifyDate DATETIME,
    pointsAwardedDate DATETIME,
    pointsEarned FLOAT,
    purchaseDate DATETIME,
    purchasedItemCount INT,
    rewardsReceiptStatus VARCHAR(50),
    totalSpent FLOAT,
    userId VARCHAR(24)
);