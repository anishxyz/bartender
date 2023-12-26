from openai import OpenAI, AsyncOpenAI

from app.llm_pipelines.helpers import extract_json

client = AsyncOpenAI()

async def cocktail_extraction(image_data):
    response = await client.chat.completions.create(
        model="gpt-4-vision-preview",
        messages=[
            {
                "role": "system",
                "content": [
                    {
                        "type": "text",
                        "text": "You are a professional, michelin-star rated bartender. You are capable of making the best cocktails in the world. You can only respond with bartending and cocktail information related to the image"
                    }
                ]
            },
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": "I want to know what cocktails are in this image. Please return a JSON array of objects, each of which has the following attributes: name, ingredients, and notes. Notes should ONLY include any other relevant info about the cocktail from the image that may assist when making it. If no other info else is present, leave it as 'none'"
                    },
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{image_data}"
                        }
                    }
                ]
            }
        ],
        max_tokens=4096,
        temperature=0
    )

    jsonified = extract_json(response.choices[0].message.content)

    return jsonified


async def generate_cocktail(cocktail_description):
    response = await client.chat.completions.create(
        model="gpt-4-vision-preview",
        messages=[
            {
                "role": "system",
                "content": [
                    {
                        "type": "text",
                        "text": "You are a professional, michelin-star rated bartender. You are capable of making the best cocktails in the world. You can only respond with bartending and cocktail information related to the image"
                    }
                ]
            },
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": "I want to know what cocktails are in this image. Please return a JSON array of objects, each of which has the following attributes: name, ingredients, and notes. Notes should ONLY include any other relevant info about the cocktail from the image that may assist when making it. If no other info else is present, leave it as 'none'"
                    },
                    {
                        "type": "image_url",
                        "image_url": {
                            "url": f"data:image/jpeg;base64,{image_data}"
                        }
                    }
                ]
            }
        ],
        max_tokens=4096,
        temperature=0
    )