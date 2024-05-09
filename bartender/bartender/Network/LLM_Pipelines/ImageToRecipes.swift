//
//  ImageToRecipes.swift
//  bartender
//
//  Created by Anish Agrawal on 4/28/24.
//

import Foundation
import UIKit

class ImageToMenu {
    private var networkManager: OpenAINetworkManager
    
    init() {
        self.networkManager = OpenAINetworkManager()
    }
    
    func analyzeImageForCocktailDescriptions(img: UIImage, completion: @escaping ([TempMenuDetail]) -> Void) {
        let base64Image = convertImageToBase64String(img: img)
        
        let systemMessage: [String: Any] = [
            "role": "system",
            "content": [
                [
                    "type": "text",
                    "text": "You are a professional, michelin-star rated bartender. Your job is to assist reverse engineer cocktail recipes from a cocktail menu at a restaurant"
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
                                "description": "Name of cocktail menu being described"
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
        
        let tool_choice: ToolChoice = ToolChoice.dictionaryValue([
            "type": "function",
            "function": [
                "name": "submit_cocktail_menu_description"
            ]
        ])
        
        let messages: [[String: Any]] = [systemMessage, userMessage]
        
        networkManager.ChatCompletionV1(with: "gpt-4-turbo-2024-04-09", messages: messages, tools: tools, toolChoice: tool_choice) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let chatCompletion):
                    if let firstChoice = chatCompletion.choices.first {
                        guard let toolCalls = firstChoice.message.toolCalls, !toolCalls.isEmpty else {
                            print("No tool calls available.")
                            completion([])
                            return
                        }
                        
                        let firstToolCall = toolCalls[0]
                        let functionArgs = firstToolCall.function.arguments
                        
                        print("args", functionArgs)
                        
                        if let jsonData = functionArgs.data(using: .utf8) {
                            if let tempMenuDetail = decodeTempMenuDetails(from: jsonData) {
                                completion([tempMenuDetail])
                            } else {
                                completion([])
                            }
                        } else {
                            print("Failed to convert function arguments to Data.")
                            completion([])
                        }

                    }
                    
                case .failure(let error):
                    print("ImageToMenu Error: \(error.localizedDescription)")
                    completion([])
                }
            }
        }
    }
    
    func convertDetailsToCocktailRecipe(details: [TempMenuDetail], completion: @escaping ([TempMenuDetail]) -> Void) {
        
        completion([])
    }

}

struct TempCocktailDetail: Codable {
    let name: String
    let description: String
    let ingredients: String
}

struct TempMenuDetail: Codable {
    let menu_name: String
    let cocktails: [TempCocktailDetail]
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
