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
    
    func fetchAllMenuDetails(userID: String, completion: @escaping (Result<[CocktailMenu], Error>) -> Void) {
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
