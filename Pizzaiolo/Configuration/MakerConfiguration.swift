//
//  MakerConfiguration.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 24/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation

enum LayoutType {
    case title
    case button
}

struct MakerConfiguration {
    static let basePrice = 299
    
    static let layout = [
        ["type": LayoutType.title, "title": "Base"],
        ["type": LayoutType.button, "title": "Tomato Sauce", "price": 100],
        
        ["type": LayoutType.title, "title": "Cheese"],
        ["type": LayoutType.button, "title": "Parmigiano", "price": 200],
        ["type": LayoutType.button, "title": "Mozzarella", "price": 150],
        ["type": LayoutType.button, "title": "Gorgonzola", "price": 220],
        
        ["type": LayoutType.title, "title": "Meat & Fish"],
        ["type": LayoutType.button, "title": "Salami", "price": 130],
        ["type": LayoutType.button, "title": "Speck", "price": 220],
        ["type": LayoutType.button, "title": "Anchovies", "price": 170],
        ["type": LayoutType.button, "title": "Shrimps", "price": 260],
        ["type": LayoutType.button, "title": "Squid", "price": 210],
        
        ["type": LayoutType.title, "title": "Vegetables"],
        ["type": LayoutType.button, "title": "Peppers", "price": 60],
        ["type": LayoutType.button, "title": "Mushrooms", "price": 170],
        ["type": LayoutType.button, "title": "Tomatoes", "price": 70],
        ["type": LayoutType.button, "title": "Olives", "price": 90],
        ["type": LayoutType.button, "title": "Onions", "price": 40],
        ["type": LayoutType.button, "title": "Truffles", "price": 440],
        
        ["type": LayoutType.title, "title": "Herbs"],
        ["type": LayoutType.button, "title": "Basil", "price": 50],
        ["type": LayoutType.button, "title": "Rosemary", "price": 60],
        ["type": LayoutType.button, "title": "Parsley", "price": 40],
    ]
}
