//
//  BottleType.swift
//  bartender-swift
//
//  Created by Anish Agrawal on 12/17/23.
//


import SwiftUI

enum BottleType: String, CaseIterable, Identifiable {
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
    
    var id: String { self.rawValue }

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
        }
    }
    
    var filledSymbolName: String {
        "case.\(self.rawValue.lowercased()).fill"
    }
    
    
    var symbolFilled: Image {
        Image(filledSymbolName)
    }

//    var symbolOutline: Image {
//        Image(systemName: outlineSymbolName)
//    }
}


