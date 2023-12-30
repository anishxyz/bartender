//
//  BarNetworkManager.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/30/23.
//

import Foundation

struct BarNetworkManager {
    static let shared = BarNetworkManager()
    let baseURL = "http://127.0.0.1:8000/api/bar"

    // Fetch all bottles from the cellar
    func fetchBars(user_id: String, completion: @escaping (Result<[Bar], Error>) -> Void) {
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
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)

                let bars = try decoder.decode([Bar].self, from: data)
                completion(.success(bars))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    

}
