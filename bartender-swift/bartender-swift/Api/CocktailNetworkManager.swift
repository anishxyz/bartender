//
//  CocktailNetworkManager.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/24/23.
//

import Foundation

struct CocktailNetworkManager {
    static let shared = CocktailNetworkManager()
    var baseURL: String {
        // Get the root URL from the environment variable
        let rootURL = ProcessInfo.processInfo.environment["ROOT_URL"] ?? "http://defaultroot.com"
        
        return rootURL + "/api/cocktail"
    }
    
    func uploadCocktailImage(menuID: Int, userID: String, file: Data?, base64Image: String?, completion: @escaping (Result<[Cocktail], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/ai/\(menuID)")!
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

                let cocktails = try decoder.decode([Cocktail].self, from: data)
                completion(.success(cocktails))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}

