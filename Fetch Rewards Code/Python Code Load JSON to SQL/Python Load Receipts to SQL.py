from datetime import datetime
import json
import mysql.connector

# Function to convert Unix timestamp in milliseconds to a human-readable date
def convert_timestamp(timestamp):
    if timestamp is not None:
        return datetime.fromtimestamp(timestamp / 1000).strftime('%Y-%m-%d %H:%M:%S')
    return None

# Load data from receipts.json (line-by-line handling)
data = []
with open('receipts.json', 'r') as file:
    for line in file:
        try:
            data.append(json.loads(line))
        except json.JSONDecodeError as e:
            print(f"Skipping invalid line due to JSONDecodeError: {e}")

# Connect to MySQL database
conn = mysql.connector.connect(
    host="127.0.0.1",
    user="root",
    password="",
    database="fetch"
)
cursor = conn.cursor()

# Check if table exists, truncate and recreate if it does
table_name = 'receipts'
cursor.execute(f"""
    SELECT COUNT(*)
    FROM information_schema.tables
    WHERE table_schema = 'fetch'
    AND table_name = '{table_name}';
""")
table_exists = cursor.fetchone()[0]

if table_exists:
    print(f"Table '{table_name}' exists. Truncating and recreating...")
    cursor.execute(f"DROP TABLE {table_name};")
else:
    print(f"Table '{table_name}' does not exist. Creating it...")

# Create table definition
create_table_query = """
CREATE TABLE receipts (
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
"""
cursor.execute(create_table_query)

# Insert data into the table
insert_query = """
INSERT INTO receipts (
    id, bonusPointsEarned, bonusPointsEarnedReason, createDate, dateScanned, finishedDate, modifyDate, pointsAwardedDate,
    pointsEarned, purchaseDate, purchasedItemCount, rewardsReceiptStatus, totalSpent, userId
) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s);
"""

# Parse and insert each record into the table
for record in data:
    record_values = (
        record["_id"]["$oid"],
        record.get("bonusPointsEarned", 0),
        record.get("bonusPointsEarnedReason", ""),
        convert_timestamp(record.get("createDate", {}).get("$date")),
        convert_timestamp(record.get("dateScanned", {}).get("$date")),
        convert_timestamp(record.get("finishedDate", {}).get("$date")),
        convert_timestamp(record.get("modifyDate", {}).get("$date")),
        convert_timestamp(record.get("pointsAwardedDate", {}).get("$date")),
        float(record.get("pointsEarned", 0.0)),
        convert_timestamp(record.get("purchaseDate", {}).get("$date")),
        record.get("purchasedItemCount", 0),
        record.get("rewardsReceiptStatus", ""),
        float(record.get("totalSpent", 0.0)),
        record.get("userId", "")
    )
    cursor.execute(insert_query, record_values)

# Commit the transaction
conn.commit()

# Close the connection
cursor.close()
conn.close()

print("Data successfully inserted!")
