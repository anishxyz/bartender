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
        loadingCount += 1
    }

    func stopLoading() {
        if loadingCount > 0 {
            loadingCount -= 1
        }
    }
}
