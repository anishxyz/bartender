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
                    self?.cellar = bottles.sorted {
                        if $0.last_updated == $1.last_updated {
                            return $0.name < $1.name
                        }
                        return $0.last_updated > $1.last_updated
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
                // TODO: Handle the error
            }
        }
    }
    
    func addBottleToCellar(bottleData: AddBottleData, forUserID userID: String) {
        CellarNetworkManager.shared.addBottle(bottleData: bottleData, userID: userID) { [weak self] result in
            switch result {
            case .success(let newBottle):
                DispatchQueue.main.async {
                    self?.cellar.insert(newBottle, at: 0)
                }
            case .failure(let error):
                print(error.localizedDescription)
                // TODO: Handle the error
            }
        }
    }


    func deleteBottleFromCellar(bottleID: Int, forUserID userID: String) {
        CellarNetworkManager.shared.deleteBottle(bottleID: bottleID, userID: userID) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.cellar.removeAll { $0.id == bottleID }
                }
            case .failure(let error):
                print(error.localizedDescription)
                // TODO: Handle the error
            }
        }
    }
    

}
