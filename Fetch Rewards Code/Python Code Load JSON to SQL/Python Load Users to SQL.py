from datetime import datetime
import json
import mysql.connector

# Function to convert Unix timestamp in milliseconds to a human-readable date
def convert_timestamp(timestamp):
    if timestamp is not None:
        return datetime.fromtimestamp(timestamp / 1000).strftime('%Y-%m-%d %H:%M:%S')
    return None

# Load data from users.json (line-by-line handling)
data = []
with open('users.json', 'r') as file:
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
table_name = 'users'
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
CREATE TABLE users (
    id VARCHAR(24),
    state VARCHAR(10),
    createdDate DATETIME,
    lastLogin DATETIME,
    role VARCHAR(50),
    active BOOLEAN
);
"""
cursor.execute(create_table_query)

# Insert all records into the table
insert_query = """
INSERT INTO users (
    id, state, createdDate, lastLogin, role, active
) VALUES (%s, %s, %s, %s, %s, %s);
"""

# Prepare data for insertion
unique_records = []
for record in data:
    record_values = (
        record["_id"]["$oid"],
        record.get("state", ""),
        convert_timestamp(record.get("createdDate", {}).get("$date")),
        convert_timestamp(record.get("lastLogin", {}).get("$date")),
        record.get("role", "consumer"),  # Default to "consumer" as per schema
        record.get("active", False)
    )
    unique_records.append(record_values)

# Batch insert all records
cursor.executemany(insert_query, unique_records)

# Commit the transaction
conn.commit()

# Close the connection
cursor.close()
conn.close()

print("Data successfully inserted!")