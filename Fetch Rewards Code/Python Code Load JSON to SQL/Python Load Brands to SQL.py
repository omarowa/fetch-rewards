from datetime import datetime
import json
import mysql.connector

# Load data from brands.json (line-by-line handling)
data = []
with open('brands.json', 'r') as file:
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
table_name = 'brands'
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
CREATE TABLE brands (
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
"""
cursor.execute(create_table_query)

# Insert data into the table
insert_query = """
INSERT INTO brands (
    id, barcode, brandCode, category, categoryCode, cpg_id, cpg_ref, name, topBrand
) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s);
"""

# Parse and insert each record into the table
for record in data:
    cpg = record.get("cpg", {})
    cpg_id = cpg.get("$id", {}).get("$oid", None)
    cpg_ref = cpg.get("$ref", None)

    record_values = (
        record["_id"]["$oid"],
        record.get("barcode", ""),
        record.get("brandCode", ""),
        record.get("category", ""),
        record.get("categoryCode", ""),
        cpg_id,
        cpg_ref,
        record.get("name", ""),
        record.get("topBrand", False)
    )
    cursor.execute(insert_query, record_values)

# Commit the transaction
conn.commit()

# Close the connection
cursor.close()
conn.close()

print("Data successfully inserted!")