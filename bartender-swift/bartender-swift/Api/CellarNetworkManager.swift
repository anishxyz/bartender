//
//  NetworkManager.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/26/23.
//

import Foundation

struct CellarNetworkManager {
    static let shared = CellarNetworkManager()
    let baseURL = "http://127.0.0.1:8000/api"

    // Fetch all bottles from the cellar
    func fetchCellar(user_id: String, completion: @escaping (Result<[Bottle], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/cellar/")!
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(user_id)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                return
            }
            do {
                if let jsonResponse = String(data: data, encoding: .utf8) {
                    print("Cellar JSON Response: \(jsonResponse)")
                }
            
                let decoder = BottleJSONDecoder.standard()
                let bottles = try decoder.decode([Bottle].self, from: data)
                completion(.success(bottles))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // Add a new bottle to the cellar
    func addBottle(bottle: Bottle, user_id: String, completion: @escaping (Result<Bottle, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/cellar/add_bottle")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(user_id)", forHTTPHeaderField: "Authorization")
        
        do {
            let jsonData = try JSONEncoder().encode(bottle)
            request.httpBody = jsonData
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                guard let data = data else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
                    return
                }
                do {
                    let newBottle = try JSONDecoder().decode(Bottle.self, from: data)
                    completion(.success(newBottle))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }

    // Additional methods for updating and deleting bottles can be implemented similarly
}
