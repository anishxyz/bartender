//
//  CellarViewModel.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 11/22/23.
//

import SwiftUI

@MainActor final class CellarViewModel: ObservableObject {
    
    @Published var cellar: [Bottle] = []
    @Published var bars: [Bar] = []
    
    // for states
    @Published var selectedBarID: Int? = nil
    
    func filterBottles(byBarID barID: Int?) {
        selectedBarID = barID // This will be used to determine which bottles to show
    }

    func fetchCellarData(forUserID userID: String, completion: (() -> Void)? = nil) {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        CellarNetworkManager.shared.fetchCellar(user_id: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let bottles):
                    self?.cellar = bottles.sorted {
                        if $0.last_updated == $1.last_updated {
                            return $0.name < $1.name
                        }
                        return $0.last_updated > $1.last_updated
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    // TODO: Handle the error
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        BarNetworkManager.shared.fetchBars(user_id: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let bars):
                    self?.bars = bars
                    print(bars)
                case .failure(let error):
                    print(error.localizedDescription)
                    // TODO: Handle the error
                }
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            completion?()
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
