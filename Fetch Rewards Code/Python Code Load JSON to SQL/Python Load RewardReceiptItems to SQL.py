import json
import mysql.connector

# Load data from receipts.json (line-by-line handling)
with open('receipts.json', 'r') as file:
    data = [json.loads(line) for line in file]

# Connect to MySQL database
conn = mysql.connector.connect(
    host="127.0.0.1",
    user="root",
    password="",
    database="fetch"
)
cursor = conn.cursor()

# Function to truncate a table if it exists
def truncate_table_if_exists(table_name):
    cursor.execute(f"""
        SELECT COUNT(*)
        FROM information_schema.tables
        WHERE table_schema = 'fetch'
        AND table_name = '{table_name}';
    """)
    table_exists = cursor.fetchone()[0]
    if table_exists:
        print(f"Table '{table_name}' exists. Truncating...")
        cursor.execute(f"TRUNCATE TABLE {table_name};")
    else:
        print(f"Table '{table_name}' does not exist.")

# Truncate rewardsReceiptItems table if it exists
truncate_table_if_exists('rewardsReceiptItems')

# Create rewardsReceiptItems table with surrogate key
create_items_table = """
CREATE TABLE IF NOT EXISTS rewardsReceiptItems (
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
"""
cursor.execute(create_items_table)

# Insert data into rewardsReceiptItems table
insert_item = """
INSERT INTO rewardsReceiptItems (
    receiptId, barcode, description, finalPrice, itemPrice, needsFetchReview, partnerItemId, 
    preventTargetGapPoints, quantityPurchased, userFlaggedBarcode, userFlaggedNewItem, 
    userFlaggedPrice, userFlaggedQuantity
) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
"""

for record in data:
    receipt_id = record["_id"]["$oid"]
    # Insert related items data
    for item in record.get("rewardsReceiptItemList", []):
        cursor.execute(insert_item, (
            receipt_id,
            item.get("barcode", ""),
            item.get("description", ""),
            float(item.get("finalPrice", 0.0)),
            float(item.get("itemPrice", 0.0)),
            item.get("needsFetchReview", False),
            item.get("partnerItemId", ""),
            item.get("preventTargetGapPoints", False),
            item.get("quantityPurchased", 0),
            item.get("userFlaggedBarcode", ""),
            item.get("userFlaggedNewItem", False),
            float(item.get("userFlaggedPrice", 0.0)),
            item.get("userFlaggedQuantity", 0)
        ))

# Commit and close connection
conn.commit()
cursor.close()
conn.close()

print("RewardsReceiptItems data successfully inserted")
