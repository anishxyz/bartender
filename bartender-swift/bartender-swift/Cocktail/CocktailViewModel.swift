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
    private let menuNetworkManager = MenuNetworkManager.shared
    private let cocktailNetworkManager = CocktailNetworkManager.shared

    // TODO: MAKE IT A CALL FOR MENU SUMMARIES -> ALL MENU DATA for SPEEEEEDDDDYYYY
    func fetchAllMenus(userID: String) {
        menuNetworkManager.fetchMenus(userID: userID) { [weak self] result in
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
        menuNetworkManager.createMenu(name: name, userID: userID) { [weak self] result in
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
    
    func createCocktailsForMenu(fromImage file: Data?, base64Image: String?, menuID: Int, userID: String) {
        cocktailNetworkManager.uploadCocktailImage(menuID: menuID, userID: userID, file: file, base64Image: base64Image) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cocktails):
                    self?.addCocktails(cocktails, toMenuWithID: menuID)
                case .failure(let error):
                    print("Error creating cocktails: \(error)")
                    // TODO: HANDLE ERROR
                }
            }
        }
    }

    private func addCocktails(_ cocktails: [Cocktail], toMenuWithID menuID: Int) {
        if let index = menus.firstIndex(where: { $0.menu_id == menuID }) {
            menus[index].cocktails?.append(contentsOf: cocktails)
        }
    }
}
