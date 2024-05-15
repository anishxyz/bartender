//
//  LoadingStateViewModel.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/28/23.
//

import Foundation

class LoadingStateViewModel: ObservableObject {
    @Published private var loadingCount = 0

    var isLoading: Bool {
        loadingCount > 0
    }

    func startLoading() {
        DispatchQueue.main.async {
            self.loadingCount += 1
        }
    }

    func stopLoading() {
        DispatchQueue.main.async {
            if self.loadingCount > 0 {
                self.loadingCount -= 1
            }
        }
    }
}
