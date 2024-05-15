import json
from openai import OpenAI
import base64

# OpenAI setup
api_key = "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"
client = OpenAI(api_key=api_key)


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


# Function to encode the image
def encode_image(image_path):
    with open(image_path, "rb") as image_file:
        return base64.b64encode(image_file.read()).decode('utf-8')


# Path to your image
image_path = "IMG_0765.jpg"

# Getting the base64 string
base64_image = encode_image(image_path)

response = client.chat.completions.create(
    model="gpt-4-vision-preview",
    messages=[
        {
            "role": "user",
            "content": [
                {
                    "type": "text",
                    "text": "Return a detailed name of the alcohol, type, volume, alcohol_percentage, and description for each bottle in the image. If not found in image, put 'not found' or estimate the value if possible. Your response should be a JSON array of objects, each of which has the following attributes: name, type, volume, alcohol_percentage, and description"
                },
                {
                    "type": "image_url",
                    "image_url": {
                        "url": f"data:image/jpeg;base64,{base64_image}"
                    }
                }
            ]
        }
    ],
    max_tokens=500,
    temperature=0
)
# print(response.choices[0].message.content)

print('EXTRACTED', extract_json(response.choices[0].message.content))

response_json = extract_json(response.choices[0].message.content)

