//
//  MenuNetworkManager.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/24/23.
//


import Foundation

struct MenuNetworkManager {
    static let shared = MenuNetworkManager()
    let baseURL = "http://127.0.0.1:8000/api/menu"
    
    func fetchMenus(userID: String, completion: @escaping (Result<[CocktailMenu], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/all")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(userID)", forHTTPHeaderField: "Authorization")

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
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSX"
                dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(dateFormatter)
                
                let menus = try decoder.decode([CocktailMenu].self, from: data)
                completion(.success(menus))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func createMenu(name: String, userID: String, completion: @escaping (Result<CocktailMenu, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/create")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(userID)", forHTTPHeaderField: "Authorization")

        let requestBody = ["name": name]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: requestBody, options: [])
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }

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

                let menu = try decoder.decode(CocktailMenu.self, from: data)
                completion(.success(menu))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func uploadMenuImage(userID: String, file: Data?, base64Image: String?, completion: @escaping (Result<CocktailMenu, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/ai/create")!
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

                let cocktails = try decoder.decode(CocktailMenu.self, from: data)
                completion(.success(cocktails))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func deleteMenu(menuID: Int, userID: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/id/\(menuID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("Bearer \(userID)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Server error"])))
                return
            }

            completion(.success(()))
        }.resume()
    }
    
    // UNVERIFIED BELOW //

    // Fetch a specific menu by its ID
    func fetchMenu(menuID: Int, userID: String, completion: @escaping (Result<CocktailMenu, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/\(menuID)")!
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(userID)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            handleNetworkResponse(data: data, error: error, completion: completion)
        }.resume()
    }

    // Fetch all cocktails for a specific menu
    func fetchCocktailsForMenu(menuID: Int, userID: String, completion: @escaping (Result<[Cocktail], Error>) -> Void) {
        let url = URL(string: "\(baseURL)/\(menuID)/cocktails")!
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(userID)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            handleNetworkResponse(data: data, error: error, completion: completion)
        }.resume()
    }

    // Fetch full details of a specific menu, including cocktails, ingredients, and steps
    func fetchAllMenus(menuID: Int, userID: String, completion: @escaping (Result<CocktailMenu, Error>) -> Void) {
        let url = URL(string: "\(baseURL)/\(menuID)/details")!
        
        var request = URLRequest(url: url)
        request.addValue("Bearer \(userID)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            handleNetworkResponse(data: data, error: error, completion: completion)
        }.resume()
    }

    // Generic network response handler
    private func handleNetworkResponse<T: Decodable>(data: Data?, error: Error?, completion: (Result<T, Error>) -> Void) {
        if let error = error {
            completion(.failure(error))
            return
        }
        guard let data = data else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
            return
        }
        do {
            let decoder = JSONDecoder()
            // Customize the date decoding strategy if necessary
            decoder.dateDecodingStrategy = .iso8601
            let result = try decoder.decode(T.self, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(error))
        }
    }
}
