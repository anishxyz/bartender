//
//  CocktailViewModel.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/22/23.
//

import Foundation
import Combine

class CocktailViewModel: ObservableObject {
    @Published var menus: [CocktailMenu] = []
    private var cancellables = Set<AnyCancellable>()
    private let networkManager = MenuNetworkManager.shared

    // TODO: MAKE IT A CALL FOR MENU SUMMARIES -> ALL MENU DATA for SPEEEEEDDDDYYYY
    func fetchAllMenus(userID: String) {
        networkManager.fetchAllMenuDetails(userID: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let menus):
                    self?.menus = menus
                case .failure(let error):
                    print("Error fetching menus: \(error)")
                    // TODO: HANDLE ERROR
                }
            }
        }
    }
    
    func createMenu(name: String, userID: String) {
        networkManager.createMenu(name: name, userID: userID) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let newMenu):
                    self?.menus.append(newMenu)
                case .failure(let error):
                    print("Error creating menu: \(error)")
                    // TODO: HANDLE ERROR
                }
            }
        }
    }
    
}
