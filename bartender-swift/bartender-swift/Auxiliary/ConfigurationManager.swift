//
//  ConfigurationManager.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 1/7/24.
//

import Foundation

class ConfigurationManager {
    static let shared = ConfigurationManager()

    private(set) var rootURL: String?

    private init() {
        rootURL = ProcessInfo.processInfo.environment["ROOT_URL"]
    }
}

