//
//  IngredientType.swift
//  bartender
//
//  Created by Anish Agrawal on 4/7/24.
//

import Foundation
import SwiftUI


enum IngredientType: String, CaseIterable, Identifiable, Codable {
    case wine = "Wine"
    case whiskey = "Whiskey"
    case vodka = "Vodka"
    case tequila = "Tequila"
    case rum = "Rum"
    case gin = "Gin"
    case brandy = "Brandy"
    case liqueur = "Liqueur"
    case champagne = "Champagne"
    case beer = "Beer"
    case cider = "Cider"
    case sake = "Sake"
    case absinthe = "Absinthe"
    case mezcal = "Mezcal"
    case bitters = "Bitters"
    case mixer = "Mixer"
    case other = "Other"
    
    // additions to bottle type below
    case ice = "Ice"
    case garnish = "Garnish"

    var id: String { self.rawValue }
    
    init(type: String) {
        if let matchingCase = IngredientType(rawValue: type) {
            self = matchingCase
        } else {
            self = .other
        }
    }
    
    var color: Color {
        switch self {
        case .wine:
            return Color.red
        case .whiskey:
            return Color.brown
        case .vodka:
            return Color.blue
        case .tequila:
            return Color.green
        case .rum:
            return Color.orange
        case .gin:
            return Color.mint
        case .brandy:
            return Color.purple
        case .liqueur:
            return Color.pink
        case .champagne:
            return Color.yellow
        case .beer:
            return Color.orange
        case .cider:
            return Color.red
        case .sake:
            return Color.gray
        case .absinthe:
            return Color.green
        case .mezcal:
            return Color.green
        case .bitters:
            return Color.blue
        case .mixer:
            return Color.pink
        case .other:
            return Color.gray
        case .ice:
            return Color.blue
        case .garnish:
            return Color.green
        }
    }
    
    var filledSymbolName: String {
        switch self {
        case .ice:
            return "case.ice.tongs.fill"
        case .garnish:
            return "case.garnish2.fill"
        default:
            return "case.\(self.rawValue.lowercased()).fill"
        }
    }
    
    var outlinedSymbolName: String {
        switch self {
        case .ice:
            return "case.ice.tongs.2"
        case .garnish:
            return "case.garnish2.2"
        default:
            return "case.\(self.rawValue.lowercased())"
        }
    }
    
    var symbolFilled: Image {
        Image(filledSymbolName)
    }
    
    var symbolOutline: Image {
        Image(outlinedSymbolName)
    }
}
