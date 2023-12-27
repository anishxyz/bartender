import base64
import json

from fastapi import HTTPException


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


async def process_image_data(base64_image=None, file=None):
    if base64_image:
        # Base64 string provided by the client
        image_data = base64_image.split(",")[-1]
    elif file:
        # File uploaded to the server
        file_contents = await file.read()
        image_data = base64.b64encode(file_contents).decode("utf-8")
        await file.close()
    else:
        raise HTTPException(status_code=400, detail="No image provided")

    return image_data