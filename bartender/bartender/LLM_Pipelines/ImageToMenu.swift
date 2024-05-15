//
//  ImageToRecipes.swift
//  bartender
//
//  Created by Anish Agrawal on 4/28/24.
//

import Foundation
import UIKit
import SwiftData

class ImageToMenu {
    private var networkManager: OpenAINetworkManager
    
    init() {
        self.networkManager = OpenAINetworkManager()
    }
    
    @MainActor
    func generateMenu(img: UIImage, context: ModelContext) async -> CocktailMenu? {
        guard let tempMenuDetail = await self._analyzeImageForCocktailDescriptions(img: img) else {
            return nil
        }
        
        let newMenu = CocktailMenu(name: tempMenuDetail.menu_name)
        var finalRecipes: [CocktailRecipe] = []
        
        await withTaskGroup(of: TempCocktail?.self) { group in
            for cocktailDetail in tempMenuDetail.cocktails {
                group.addTask {
                    // Asynchronously call _descriptionToRecipe for each TempCocktailDetail
                    return await self._descriptionToRecipe(cocktailDetails: cocktailDetail)
                }
            }

            // Collect results from the group
            for await tempCocktail in group {
                if let tempCocktail = tempCocktail {
                    var finalIngredients: [Ingredient] = []
                    
                    for tempIngredient in tempCocktail.ingredients {
                        finalIngredients.append(Ingredient(name: tempIngredient.name, quantity: tempIngredient.quantity, units: tempIngredient.units, type: tempIngredient.type))
                    }
                    
                    var finalRecipeSteps: [RecipeStep] = []
                    
                    for tempStep in tempCocktail.recipe_steps {
                        finalRecipeSteps.append(RecipeStep(instruction: tempStep.instruction, index: tempStep.index))
                    }
                    
                    let newRecipe = CocktailRecipe(name: tempCocktail.name)
                    newRecipe.ingredients = finalIngredients
                    newRecipe.steps = finalRecipeSteps
                    
                    finalRecipes.append(newRecipe)
                }
            }
        }
        
        DispatchQueue.main.async {
            for recipe in finalRecipes {
                context.insert(recipe)
            }
            context.insert(newMenu)
            newMenu.recipes = finalRecipes
        }
        
        return newMenu
    }
    
    func _descriptionToRecipe(cocktailDetails: TempCocktailDetail) async -> TempCocktail? {
        
        let cocktailName = cocktailDetails.name
        let ingredients = cocktailDetails.ingredients
        let description = cocktailDetails.description
        
        let formattedPrompt = """
        The cocktail name is: \(cocktailName)

        Ingredients are:
        \(ingredients)

        Description:
        \(description)
        """
        
        let systemMessage: [String: Any] = [
            "role": "system",
            "content": [
                [
                    "type": "text",
                    "text": "You are a professional, michelin-star rated bartender. Your job is to assist in reverse engineering cocktail recipes from a cocktail description. When outputting the type and units for ingredients, ensure they are exactly as stated for the enum or the submision will not go through"
                ]
            ]
        ]
        
        let userMessage: [String: Any] = [
            "role": "user",
            "content": [
                [
                    "type": "text",
                    "text": """
I need your help to make a cocktail recipe from the following information I have. Be concise and clear about how to make it.

\(formattedPrompt)
"""
                ]
            ]
        ]
        
        let messages: [[String: Any]] = [systemMessage, userMessage]
        
        let toolChoice: ToolChoice = ToolChoice.dictionaryValue([
            "type": "function",
            "function": [
                "name": "submit_cocktail"
            ]
        ])
        
        let tools: [[String: Any]] = [
            [
                "type": "function",
                "function": [
                    "name": "submit_cocktail",
                    "description": "Submit cocktail details",
                    "parameters": [
                        "type": "object",
                        "properties": [
                            "name": [
                                "type": "string",
                                "description": "Name of cocktail"
                            ],
                            "ingredients": [
                                "type": "array",
                                "description": "array of ingredients needed to make cocktail",
                                "items": [
                                    "type": "object",
                                    "properties": [
                                        "name": [
                                          "type": "string",
                                          "description": "Name of cocktail ingredient",
                                        ],
                                        "quantity": [
                                          "type": "number",
                                          "description": "quantity of ingredient (number only)",
                                        ],
                                        "units": [
                                          "type": "string",
                                          "enum": IngredientUnitType.list,
                                          "description": "units of quantity for cocktail ingredient. I prefer oz over ml.",
                                        ],
                                        "type": [
                                          "type": "string",
                                          "enum": IngredientType.list,
                                          "description": "type of ingredient",
                                        ],
                                    ],
                                    "required": ["name", "type"]
                                ]
                            ],
                            "recipe_steps": [
                                "type": "array",
                                "description": "array of recipe steps to make the cocktail",
                                "items": [
                                    "type": "object",
                                    "properties": [
                                        "index": [
                                          "type": "number",
                                          "description": "index of the recipe step",
                                        ],
                                        "instruction": [
                                          "type": "string",
                                          "description": "instruction for this step of the recipe",
                                        ],
                                    ],
                                    "required": ["index", "instruction"]
                                ]
                            ]
                        ],
                        "required": ["name", "ingredients", "recipe_steps"]
                    ]
                ]
            ]
        ]
        
        do {
            let chatCompletion = try await self.networkManager.chatCompletionV1Async(with: "gpt-4-turbo-2024-04-09", messages: messages, tools: tools, toolChoice: toolChoice)
            if let firstChoice = chatCompletion.choices.first,
               let toolCalls = firstChoice.message.toolCalls, !toolCalls.isEmpty,
               let firstToolCall = toolCalls.first {
                let functionArgs = firstToolCall.function.arguments
                if let jsonData = functionArgs.data(using: .utf8) {
                    return decodeTempCocktail(from: jsonData)
                }
            }
            return nil
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
    }
    
    func _analyzeImageForCocktailDescriptions(img: UIImage) async -> TempMenuDetail? {
       let base64Image = convertImageToBase64String(img: img)
       
       let systemMessage: [String: Any] = [
           "role": "system",
           "content": [
               [
                   "type": "text",
                   "text": "You are a professional, michelin-star rated bartender. Your job is to assist in reverse engineering cocktail recipes from a cocktail menu at a restaurant"
               ]
           ]
       ]
       
       let userMessage: [String: Any] = [
           "role": "user",
           "content": [
               [
                   "type": "text",
                   "text": "I want to know what cocktails are in this menu. To help reverse engineer them, I need the following information: name, ingredients, description. The name should be as shown on the menu (if not present make a relevant name). The description should include anything relevant from the menu that could help me make the drink."
               ],
               [
                   "type": "image_url",
                   "image_url": [
                       "url": "data:image/jpeg;base64,\(base64Image)"
                   ]
               ]
           ]
       ]
       
       let tools: [[String: Any]] = [
           [
               "type": "function",
               "function": [
                   "name": "submit_cocktail_menu_description",
                   "description": "Submit descriptions of cocktails on a menu",
                   "parameters": [
                       "type": "object",
                       "properties": [
                           "menu_name": [
                               "type": "string",
                               "description": "Name of cocktail menu being described. If it is not present, generate a brief relevant, creative name in 2-3 words. The name should take inspiration from the cocktails."
                           ],
                           "cocktails": [
                               "type": "array",
                               "description": "array of cocktails found in menu",
                               "items": [
                                   "type": "object",
                                   "properties": [
                                       "name": [
                                         "type": "string",
                                         "description": "Name of cocktail from menu (if not provided make a relevant name)",
                                       ],
                                       "ingredients": [
                                         "type": "string",
                                         "description": "List of all ingredients needed to make the drink as described on menu",
                                       ],
                                       "description": [
                                         "type": "string",
                                         "description": "Relevant information about the cocktail from the menu that would assist in making the drink",
                                       ],
                                   ],
                                   "required": ["name", "ingredients", "description"]
                               ]
                           ]
                       ],
                       "required": ["menu_name", "cocktails"]
                   ]
               ]
           ]
       ]
       
       let toolChoice: ToolChoice = ToolChoice.dictionaryValue([
           "type": "function",
           "function": [
               "name": "submit_cocktail_menu_description"
           ]
       ])
       
       let messages: [[String: Any]] = [systemMessage, userMessage]
       
        do {
            let chatCompletion = try await self.networkManager.chatCompletionV1Async(with: "gpt-4-turbo-2024-04-09", messages: messages, tools: tools, toolChoice: toolChoice)
            if let firstChoice = chatCompletion.choices.first,
               let toolCalls = firstChoice.message.toolCalls, !toolCalls.isEmpty,
               let firstToolCall = toolCalls.first {
                let functionArgs = firstToolCall.function.arguments
                if let jsonData = functionArgs.data(using: .utf8) {
                    return decodeTempMenuDetails(from: jsonData)
                }
            }
            return nil
        } catch {
            print("Error: \(error.localizedDescription)")
            return nil
        }
   }
}

// image to menu
struct TempCocktailDetail: Codable {
    let name: String
    let description: String
    let ingredients: String
}

struct TempMenuDetail: Codable {
    let menu_name: String
    let cocktails: [TempCocktailDetail]
}


// temp cocktail to recipe
struct TempIngredient: Codable {
    let name: String
    let quantity: Float?
    let units: IngredientUnitType?
    let type: IngredientType
}

// Recipe Step Class
struct TempRecipeStep: Codable {
    let index: Int
    let instruction: String
}

// Cocktail Class
struct TempCocktail: Codable {
    let name: String
    let ingredients: [TempIngredient]
    let recipe_steps: [TempRecipeStep]
}

func decodeTempMenuDetails(from jsonData: Data) -> TempMenuDetail? {
    let decoder = JSONDecoder()
    do {
        let tempMenuDetails = try decoder.decode(TempMenuDetail.self, from: jsonData)
        return tempMenuDetails
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

func decodeTempCocktail(from jsonData: Data) -> TempCocktail? {
    let decoder = JSONDecoder()
    do {
        let tempCocktail = try decoder.decode(TempCocktail.self, from: jsonData)
        return tempCocktail
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

