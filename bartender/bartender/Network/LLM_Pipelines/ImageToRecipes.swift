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
                    "text": "You are a professional, michelin-star rated bartender. Your job is to assist with detecting cocktails in an image and extracting detailed information about them."
                ]
            ]
        ]
        
        let userMessage: [String: Any] = [
            "role": "user",
            "content": [
                [
                    "type": "text",
                    "text": "I want to know what cocktails are in this image. Please return a JSON array of objects, each of which has the following attributes: name, description, and ingredients."
                ],
                [
                    "type": "image_url",
                    "image_url": [
                        "url": "data:image/jpeg;base64,\(base64Image)"
                    ]
                ]
            ]
        ]
        
        let messages: [[String: Any]] = [systemMessage, userMessage]
        
        networkManager.ChatCompletionV1(with: "gpt-4-vision-preview", messages: messages, maxTokens: 4096, temperature: 0) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let chatCompletion):
                    if let firstChoice = chatCompletion.choices.first {
                        let content = firstChoice.message.content
                        let tempMenuDetails = decodeTempMenuDetails(from: content) ?? []
                        if tempMenuDetails.isEmpty {
                            completion([])
                        } else {
                            completion(tempMenuDetails)
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

struct TempMenuDetail: Codable {
    let name: String
    let description: String
    let ingredients: [String]
}

func decodeTempMenuDetails(from message: String) -> [TempMenuDetail]? {
    let startTag = "```json"
    let endTag = "```"
    
    guard let startRange = message.range(of: startTag),
          let endRange = message.range(of: endTag, range: startRange.upperBound..<message.endIndex) else {
        print("JSON tags not found.")
        return nil
    }
    
    let jsonStartIndex = message.index(startRange.upperBound, offsetBy: 1)
    let jsonEndIndex = message.index(endRange.lowerBound, offsetBy: -1)
    let jsonString = String(message[jsonStartIndex..<jsonEndIndex])
    
    let decoder = JSONDecoder()
    do {
        let jsonData = Data(jsonString.utf8)
        let tempMenuDetails = try decoder.decode([TempMenuDetail].self, from: jsonData)
        return tempMenuDetails
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}
