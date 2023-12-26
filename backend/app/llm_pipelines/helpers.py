import json


def extract_json(data_str, start_marker='```json', end_marker='```'):
    # Find the starting index of JSON
    json_start = data_str.find(start_marker) + len(start_marker)
    # Find the ending index of JSON
    json_end = data_str.find(end_marker, json_start)

    if json_start != -1 and json_end != -1:
        # Extract the JSON string
        json_str = data_str[json_start:json_end].strip()
        # Parse the JSON string
        try:
            return json.loads(json_str)
        except json.JSONDecodeError:
            raise ValueError("String could not be decoded as JSON.")
    else:
        raise ValueError("No JSON data found.")