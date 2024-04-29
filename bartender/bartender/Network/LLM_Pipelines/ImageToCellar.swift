//
//  ImageToCellar.swift
//  bartender
//
//  Created by Anish Agrawal on 3/26/24.
//

import Foundation
import UIKit

class ImageToCellar {
    private var networkManager: OpenAINetworkManager
    
    init() {
        self.networkManager = OpenAINetworkManager()
    }
    
    func analyzeImage(img: UIImage, completion: @escaping ([Bottle]) -> Void) {
        
        let base64Image = convertImageToBase64String(img: img)
        let bottleTypes = BottleType.allCases.map { $0.rawValue }.joined(separator: ", ")
        
        let systemMessage: [String: Any] = [
            "role": "system",
            "content": [
                [
                    "type": "text",
                    "text": "You are a professional, michelin-star rated bartender. You are capable of making the best cocktails in the world. Your job is to assist with detecting bottles in an image and extracting information about them. You can only respond with bartending and cocktail information related to the image"
                ]
            ]
        ]
        
        let userMessage: [String: Any] = [
            "role": "user",
            "content": [
                [
                    "type": "text",
                    "text": "I want to know what bottles are in this image. Please return a JSON array of objects, each of which has the following attributes: name, type, and description. The name should be the name of the bottle. The type should be one of the following: \(bottleTypes). Description can contain any other information on the bottle. If no other info is present, leave it as 'none'"
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
        
        networkManager.ChatCompletionV1(with: "gpt-4-turbo-2024-04-09", messages: messages, temperature: 0) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let chatCompletion):

                    if let firstChoice = chatCompletion.choices.first {
                        let content = firstChoice.message.content
                        
                        let tempBottles = decodeTempBottles(from: content) ?? []
                        
                        if tempBottles.isEmpty {
                            completion([])
                        } else {
                            let bottles = tempBottles.map { tempBottle in
                                convertToBottle(tempBottle: tempBottle)
                            }
                            completion(bottles)
                        }
                    }
                    
                case .failure(let error):
                    print("ImageToCellar Error: \(error.localizedDescription)")
                    completion([])
                }
            }
        }
    }

}

struct TempBottle: Codable {
    let name: String
    let type: BottleType
    let description: String
}

func decodeTempBottles(from message: String) -> [TempBottle]? {
    // Define the start and end tags
    let startTag = "```json"
    let endTag = "```"
    
    // Attempt to find the range of the JSON string
    guard let startRange = message.range(of: startTag),
          let endRange = message.range(of: endTag, range: startRange.upperBound..<message.endIndex) else {
        print("JSON tags not found.")
        return nil
    }
    
    // Extract the JSON string
    let jsonStartIndex = message.index(startRange.upperBound, offsetBy: 1)
    let jsonEndIndex = message.index(endRange.lowerBound, offsetBy: -1)
    let jsonString = String(message[jsonStartIndex..<jsonEndIndex])
    
    // Decode the JSON string into an array of Beverage objects
    let decoder = JSONDecoder()
    do {
        let jsonData = Data(jsonString.utf8)
        let tempBottles = try decoder.decode([TempBottle].self, from: jsonData)
        return tempBottles
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

func convertToBottle(tempBottle: TempBottle) -> Bottle {
    return Bottle(name: tempBottle.name, type: tempBottle.type, qty: 1, info: tempBottle.description)
}
