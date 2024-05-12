//
//  OpenAINetworkManager.swift
//  bartender
//
//  Created by Anish Agrawal on 3/25/24.
//

import Foundation

class OpenAINetworkManager {
    // API endpoint
    private let baseURL = URL(string: "https://api.openai.com")!
    
    // Your OpenAI API Key
    private var apiKey: String {
        struct Static {
            static let key: String = {
                guard let key = Bundle.main.object(forInfoDictionaryKey: "OPENAI_API_KEY") as? String, !key.isEmpty else {
                    fatalError("API Key not found in Info.plist")
                }
                return key
            }()
        }
        return Static.key
    }

    
    private func createRequest(model: String, messages: [[String: Any]], maxTokens: Int?, tools: [[String: Any]]?, toolChoice: ToolChoice?, temperature: Float?) throws -> URLRequest {
        var request = URLRequest(url: baseURL.appendingPathComponent("/v1/chat/completions"))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        var body: [String: Any] = ["model": model, "messages": messages]
        if let maxTokens = maxTokens { body["max_tokens"] = maxTokens }
        if let tools = tools { body["tools"] = tools }
        if let toolChoice = toolChoice {
            switch toolChoice {
            case .stringValue(let value): body["tool_choice"] = value
            case .dictionaryValue(let value): body["tool_choice"] = value
            }
        }
        if let temperature = temperature { body["temperature"] = temperature }
        
        let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        return request
    }
    
    func chatCompletionV1(with model: String, messages: [[String: Any]], maxTokens: Int? = nil, tools: [[String: Any]]? = nil, toolChoice: ToolChoice? = nil, temperature: Float? = nil, completion: @escaping (Result<ChatCompletion, Error>) -> Void) {
        do {
            let request = try createRequest(model: model, messages: messages, maxTokens: maxTokens, tools: tools, toolChoice: toolChoice, temperature: temperature)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "OpenAINetworkManagerError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received."])))
                    return
                }
                
                do {
                    let chatCompletion = try JSONDecoder().decode(ChatCompletion.self, from: data)
                    completion(.success(chatCompletion))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        } catch {
            completion(.failure(error))
        }
    }

    func chatCompletionV1Async(with model: String, messages: [[String: Any]], maxTokens: Int? = nil, tools: [[String: Any]]? = nil, toolChoice: ToolChoice? = nil, temperature: Float? = nil) async throws -> ChatCompletion {
        let request = try createRequest(model: model, messages: messages, maxTokens: maxTokens, tools: tools, toolChoice: toolChoice, temperature: temperature)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.network(description: "HTTP request failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
        }
        // data is non-optional, so it does not need to be unwrapped
        return try JSONDecoder().decode(ChatCompletion.self, from: data)
    }

}

struct ChatCompletion: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let systemFingerprint: String?
    let choices: [Choice]
    let usage: Usage

    enum CodingKeys: String, CodingKey {
        case id, object, created, model, choices, usage
        case systemFingerprint = "system_fingerprint"
    }
}

struct Choice: Codable {
    let index: Int
    let message: Message
    let logprobs: JSONNull?
    let finishReason: String

    enum CodingKeys: String, CodingKey {
        case index, message, logprobs
        case finishReason = "finish_reason"
    }
}

struct Message: Codable {
    let role: String
    let content: String?
    let toolCalls: [ToolCall]?

    private enum CodingKeys: String, CodingKey {
        case role, content, toolCalls = "tool_calls"
    }
}

struct ToolCall: Codable {
    let id: String
    let type: String
    let function: ToolFunction
}

struct ToolFunction: Codable {
    let name: String
    let arguments: String
}

struct Usage: Codable {
    let promptTokens: Int
    let completionTokens: Int
    let totalTokens: Int

    enum CodingKeys: String, CodingKey {
        case promptTokens = "prompt_tokens"
        case completionTokens = "completion_tokens"
        case totalTokens = "total_tokens"
    }
}

struct JSONNull: Codable {
    public init() {}
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

enum ToolChoice {
    case stringValue(String)
    case dictionaryValue([String: Any])
}

enum NetworkError: Error {
    case noData
    case network(description: String)
    case decoding(description: String)
}
