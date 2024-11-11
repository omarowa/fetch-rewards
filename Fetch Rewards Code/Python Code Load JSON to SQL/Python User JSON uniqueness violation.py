import json

# Load data from users.json (line-by-line handling)
data = []
with open('users.json', 'r') as file:
    for line in file:
        try:
            data.append(json.loads(line))
        except json.JSONDecodeError as e:
            print(f"Skipping invalid line due to JSONDecodeError: {e}")

# Count distinct combinations of all fields in the record
distinct_full_records = set()

def convert_to_hashable(obj):
    """Recursively convert dictionaries to tuples to make them hashable."""
    if isinstance(obj, dict):
        return tuple((k, convert_to_hashable(v)) for k, v in sorted(obj.items()))
    elif isinstance(obj, list):
        return tuple(convert_to_hashable(x) for x in obj)
    return obj

for record in data:
    # Convert record to a tuple of its sorted key-value pairs for uniqueness
    record_tuple = tuple(sorted((k, convert_to_hashable(v)) for k, v in record.items()))
    distinct_full_records.add(record_tuple)

print(f"Number of distinct full records: {len(distinct_full_records)}")
