//
//  Cellar.swift
//  bartender
//
//  Created by Anish Agrawal on 3/22/24.
//

import SwiftData
import Foundation

@Model
class Bottle {
    var name: String
    var type: BottleType
    var qty: Int
    var price: Float?
    var info: String?
    var bar: Bar?
    
    init(name: String, type: BottleType, qty: Int, price: Float? = nil, info: String?, bar: Bar? = nil) {
        self.name = name
        self.type = type
        self.qty = qty
        self.price = price
        self.info = info
        self.bar = bar
    }
}

var exampleBottle: Bottle = Bottle(name: "Don Julio 1942", type: .tequila, qty: 1, price: 750.00, info: "Tequila Don Julio was established in 1942 when Don Julio Gonzalez was only 17 years old. He produced tequila for the locals, family, and special occasions. In the early 1980’s Don Julio suffered a very bad stroke and in 1985 they threw him an enormous party to celebrate his recovery as well as his 60th birthday. The original bottles were tall like many other brands but Don Julio wanted his guests to be able to see each other while seated at tables for the party. The brand officially launched in 1987 and is now a staple in the premium Tequila category.")

struct sampleBottles {
    static var contents: [Bottle] = [
        Bottle(name: "Don Julio 1942", type: .tequila, qty: 1, price: 750.00, info: "Tequila Don Julio was established in 1942 when Don Julio Gonzalez was only 17 years old. He produced tequila for the locals, family, and special occasions. In the early 1980’s Don Julio suffered a very bad stroke and in 1985 they threw him an enormous party to celebrate his recovery as well as his 60th birthday. The original bottles were tall like many other brands but Don Julio wanted his guests to be able to see each other while seated at tables for the party. The brand officially launched in 1987 and is now a staple in the premium Tequila category."),
        Bottle(name: "Macallan 18", type: .whiskey, qty: 1, price: 330.00, info: "The Macallan 18 is a legendary single malt Scotch whisky known for its rich, fruity, and complex character. Aged in sherry oak casks from Jerez, Spain, it represents the pinnacle of whisky craftsmanship."),
        Bottle(name: "Hennessy XO", type: .brandy, qty: 1, price: 200.00, info: "Hennessy XO, introduced in 1870 by Maurice Hennessy, is the original Extra Old cognac. Its rich, full-bodied flavors are the result of blending 100 eaux-de-vie aged for up to 30 years."),
        Bottle(name: "Grey Goose", type: .vodka, qty: 1, price: 40.00, info: "Grey Goose, crafted in France, is celebrated for its excellence. Made from fine French wheat and pure artesian water, it offers a clear, fresh, and elegantly aromatic experience."),
        Bottle(name: "Modicum Rutherford", type: .wine, qty: 1, price: 120.00, info: "Modicum Rutherford is an exquisite, limited-production wine from the prestigious Rutherford AVA in Napa Valley. Known for its depth, complexity, and balance, it embodies the essence of Rutherford terroir."),
        Bottle(name: "Dassai Beyond", type: .sake, qty: 1, price: 500.00, info: "Dassai Beyond is an unparalleled sake experience, transcending traditional classifications with its refined elegance, complexity, and depth. Crafted from the rare Yamada Nishiki rice, polished to an extreme, it represents the pinnacle of the brewery's pursuit of perfection."),
        Bottle(name: "The Botanist Gin", type: .gin, qty: 1, price: 40.00, info: "The Botanist Gin, from the Isle of Islay, is a complex, flavorful gin made using 22 hand-foraged local botanicals. It stands out for its distinctive character, offering a rich and mellow taste, perfect for crafting exquisite cocktails.")
    ]
}
