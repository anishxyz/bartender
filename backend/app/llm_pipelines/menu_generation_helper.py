import asyncio
import json

from openai import OpenAI, AsyncOpenAI

from app.llm_pipelines.helpers import extract_json
from app.schemas.cellar_schemas import BottleType, IngredientType

client = AsyncOpenAI()

async def generate_menu_name(cocktails):
    tools = [
        {
            "type": "function",
            "function": {
                "name": "menu_naming",
                "description": "Short name for a cocktail menu",
                "parameters": {
                    "type": "object",
                    "properties": {
                        "name": {
                            "type": "string",
                            "description": "name for menu"
                        },
                    },
                    "required": ["name"]
                }
            }
        }
    ]

    tool_choice = {
        "type": "function",
        "function": {
            "name": "menu_naming"
        }
    }

    response = await client.chat.completions.create(
        # model="gpt-4-1106-preview",
        model="gpt-3.5-turbo-1106",
        messages=[
            {
                "role": "system",
                "content": [
                    {
                        "type": "text",
                        "text": "You are a professional, michelin-star rated bartender. You are capable of making the best cocktails in the world. A user can give you a list of cocktails and your role is to name the menu that best describes the cocktails. It should be brief, at most 4 words, and classy"
                    }
                ]
            },
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": "I have a brief description of the cocktails on my menu. Please help me name the menu. I have the following cocktail descriptions:\n" + str(cocktails)
                    },
                ]
            }
        ],
        max_tokens=4096,
        temperature=1,
        tools=tools,
        tool_choice=tool_choice
    )

    menu_name = json.loads(response.choices[0].message.tool_calls[0].function.arguments)['name']
    return menu_name