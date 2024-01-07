import asyncio
import json

from openai import OpenAI, AsyncOpenAI

from app.llm_pipelines.helpers import extract_json
from app.schemas.cellar_schemas import BottleType, IngredientType

client = AsyncOpenAI()

async def bottle_extraction(image_data):
    response = await client.chat.completions.create(
        model="gpt-4-vision-preview",
        messages=[
            {
                "role": "system",
                "content": [
                    {
                        "type": "text",
                        "text": "You are a professional, michelin-star rated bartender. You are capable of making the best cocktails in the world. Your job is to assist with detecting bottles in an image and extracting information about them. You can only respond with bartending and cocktail information related to the image"
                    }
                ]
            },
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": f"I want to know what bottles are in this image. Please return a JSON array of objects, each of which has the following attributes: name, type, and description. The name should be the name of the bottle. The type should be one of the following: {str(BottleType.list())}. Description can contain any other information on the bottle. If no other info else is present, leave it as 'none'"
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