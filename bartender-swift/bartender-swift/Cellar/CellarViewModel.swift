//
//  CellarViewModel.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/22/23.
//

import SwiftUI

@MainActor final class CellarViewModel: ObservableObject {
    
    @Published var cellar: [Bottle] = []
        

    func fetchCellarData(forUserID userID: String) {
        CellarNetworkManager.shared.fetchCellar(user_id: userID) { [weak self] result in
            switch result {
            case .success(let bottles):
                DispatchQueue.main.async {
                    self?.cellar = bottles
                }
            case .failure(let error):
                print(error.localizedDescription)
                // Handle the error, maybe by showing an alert to the user
            }
        }
    }

}
