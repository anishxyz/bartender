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
        // Check if we are in DEBUG mode; if so, load from Development.plist, otherwise load from Production.plist.
        #if DEBUG
        rootURL = loadRootURL(fromPlistNamed: "Development")
        #else
        rootURL = loadRootURL(fromPlistNamed: "Production")
        #endif
    }
    
    private func loadRootURL(fromPlistNamed plistName: String) -> String? {
        guard let plistPath = Bundle.main.path(forResource: plistName, ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: plistPath),
              let url = plistDict["RootURL"] as? String else {
            return nil
        }
        return url
    }
}

