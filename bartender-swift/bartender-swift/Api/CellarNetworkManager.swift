//
//  NetworkManager.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/26/23.
//

import Foundation

struct CellarNetworkManager {
    static let shared = CellarNetworkManager()
    
    var baseURL: String {
        // Get the root URL from the environment variable
        let rootURL = ConfigurationManager.shared.rootURL ?? "http://defaultroot.com"
        return rootURL + "/api/cellar"
    }

    // Fetch all bottles from the cellar
    func fetchCellar(user_id: String, completion: @escaping (Result<[Bottle], Error>) -> Void) {
        let url = URL(string: "\(baseURL)")!
        
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
//                if let jsonResponse = String(data: data, encoding: .utf8) {
//                    print("Cellar JSON Response: \(jsonResponse)")
//                }
            
                let decoder = BottleJSONDecoder.standard()
                let bottles = try decoder.decode([Bottle].self, from: data)
                completion(.success(bottles))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func addBottle(bottleData: AddBottleData, userID: String, completion: @escaping (Result<Bottle, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/add_bottle")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(userID)", forHTTPHeaderField: "Authorization")

        do {
            let jsonData = try JSONEncoder().encode(bottleData)
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
//                    if let jsonString = String(data: data, encoding: .utf8) {
//                        print("JSON String: \(jsonString)")
//                    }
                    let decoder = BottleJSONDecoder.standard()
                    let newBottle = try decoder.decode(Bottle.self, from: data)
                    completion(.success(newBottle))
                } catch {
                    print("Decoding error: \(error)")
                    completion(.failure(error))
                }
            }.resume()
        } catch {
            completion(.failure(error))
        }
    }
    
    
    func deleteBottle(bottleID: Int, userID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/delete_bottle/\(bottleID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(userID)", forHTTPHeaderField: "Authorization")

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
                let result = try JSONDecoder().decode(Dictionary<String, String>.self, from: data)
                if let message = result["msg"] {
                    completion(.success(message))
                } else {
                    completion(.failure(NSError(domain: "UnexpectedResponse", code: -2, userInfo: nil)))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    
    func uploadBottlesImage(userID: String, file: Data?, base64Image: String?, bar_id: Int?, completion: @escaping (Result<[Bottle], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/ai/bottle")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer \(userID)", forHTTPHeaderField: "Authorization")
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()

        let boundaryPrefix = "--\(boundary)\r\n"

        // Function to append string as Data
        func append(_ string: String) {
            if let data = string.data(using: .utf8) {
                body.append(data)
            }
        }

        // Append file data if available
        if let fileData = file {
            append(boundaryPrefix)
            append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n")
            append("Content-Type: image/jpeg\r\n\r\n")
            body.append(fileData)
            append("\r\n")
        }

        // Append base64 image string if available
        if let base64String = base64Image {
            append(boundaryPrefix)
            append("Content-Disposition: form-data; name=\"base64_image\"\r\n\r\n")
            append(base64String)
            append("\r\n")
        }
        
        if let barId = bar_id {
            append(boundaryPrefix)
            append("Content-Disposition: form-data; name=\"bar_id\"\r\n\r\n")
            append("\(barId)")
            append("\r\n")
        }

        append("--\(boundary)--\r\n")

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

                let bottles = try decoder.decode([Bottle].self, from: data)
                completion(.success(bottles))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

}


struct AddBottleData: Codable {
    let name: String
    let type: String
    let qty: Int
    let current: Bool
    let price: Float?
    let description: String
    let bar_id: Int?
}
