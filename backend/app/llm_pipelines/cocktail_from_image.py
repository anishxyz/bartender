import asyncio
import json

from openai import OpenAI, AsyncOpenAI

from app.llm_pipelines.helpers import extract_json
from app.schemas.cellar_schemas import BottleType, IngredientType

client = AsyncOpenAI()


async def get_cocktails_from_image(image_data):
    cocktails = await cocktail_extraction(image_data)

    print(cocktails)

    async def process_cocktail(cocktail):
        description = await generate_cocktail_instructions(cocktail)

        ret = {
            "name": cocktail["name"],
            "sections": description["sections"],
            "ingredients": description["ingredients"],
        }

        return ret

    tasks = [process_cocktail(cocktail) for cocktail in cocktails]

    response = []
    for task in asyncio.as_completed(tasks):
        cocktail_description = await task
        response.append(cocktail_description)
        # print(cocktail_description)

    return response


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


async def generate_cocktail_instructions(cocktail_description):
    tools = [
        {
            "type": "function",
            "function": {
                "name": "cocktail_instructions",
                "description": "Detailed content on how to make a cocktail",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "name": {
                            "type": "string",
                            "description": "name of cocktail"
                        },
                        "sections": {
                            "type": "array",
                            "description": "sections",
                            "items": {
                                "type": "object",
                                "properties": {
                                    "index": {
                                        "type": "integer",
                                        "description": "index of the section"
                                    },
                                    "name": {
                                        "type": "string",
                                        "description": "name of the section"
                                    },
                                    "steps": {
                                        "type": "array",
                                        "description": "steps in the section",
                                        "items": {
                                            "type": "object",
                                            "properties": {
                                                "index": {
                                                    "type": "integer",
                                                    "description": "index of the step"
                                                },
                                                "instruction": {
                                                    "type": "string",
                                                    "description": "instruction for the step"
                                                }
                                            },
                                            "required": ["index", "instruction"]
                                        }
                                    }
                                },
                                "required": ["index", "steps"]
                            }
                        },
                        "ingredients": {
                            "type": "array",
                            "description": "ingredients",
                            "items": {
                                "type": "object",
                                "properties": {
                                    "name": {
                                        "type": "string",
                                        "description": "name of the ingredient"
                                    },
                                    "type": {
                                        "type": "string",
                                        "enum": IngredientType.list(),
                                        "description": "type of the ingredient"
                                    },
                                    "quantity": {
                                        "type": "number",
                                        "description": "quantity of the ingredient"
                                    },
                                    "units": {
                                        "type": "string",
                                        "description": "units of measurement. for smaller measurements oz is preferred"
                                    }
                                },
                                "required": ["name", "type", "quantity", "units"]
                            }
                        }
                    },
                    "required": ["name", "sections", "ingredients"]
                }
            }
        }
    ]

    tool_choice = {
        "type": "function",
        "function": {
            "name": "cocktail_instructions"
        }
    }

    response = await client.chat.completions.create(
        model="gpt-4-1106-preview",
        # model="gpt-3.5-turbo-1106",
        messages=[
            {
                "role": "system",
                "content": [
                    {
                        "type": "text",
                        "text": "You are a professional, michelin-star rated bartender. You are capable of making the best cocktails in the world. Your job is to help the user make the cocktail from the limited descriptions they provide you"
                    }
                ]
            },
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": "I have a brief description of the cocktail I want to make. Please help me make it. I have the following description:\n" + str(cocktail_description)
                    },
                ]
            }
        ],
        max_tokens=4096,
        temperature=0,
        tools=tools,
        tool_choice=tool_choice
    )

    return json.loads(response.choices[0].message.tool_calls[0].function.arguments)
