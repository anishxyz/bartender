//
//  IngredientUnitType.swift
//  bartender
//
//  Created by Anish Agrawal on 4/8/24.
//

import Foundation

enum IngredientUnitType: String, CaseIterable, Identifiable, Codable {
    case ounces = "oz"
    case milliliters = "ml"
    case tablespoons = "tbsp"
    case teaspoons = "tsp"
    case grams = "g"
    case miligrams = "mg"
    
    case pod = "pod"
    case cups = "cups"
    case slices = "slices"
    case leaves = "leaves"
    case dashes = "dashes"
    case pinches = "pinches"
    case sprigs = "sprigs"
    case sticks = "sticks"
    case eggs = "eggs"
    case pieces = "pieces"
    case bottles = "bottles"
    case units = "units"
    
    var id: String { self.rawValue }
}
