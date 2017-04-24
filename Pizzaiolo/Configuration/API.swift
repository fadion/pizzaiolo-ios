//
//  API.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 20/02/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation

struct API {
    private static let baseUrl = URL(string: "http://localhost:3000")!
    
    static let featured = baseUrl.appendingPathComponent("featured")
    static let pizza = baseUrl.appendingPathComponent("pizza")
    static let categories = baseUrl.appendingPathComponent("categories")
    
    static func photo(featured: String) -> URL {
        return self.baseUrl
            .appendingPathComponent("photos")
            .appendingPathComponent("featured")
            .appendingPathComponent(featured)
    }
    
    static func photo(pizza: String) -> URL {
        return self.baseUrl
            .appendingPathComponent("photos")
            .appendingPathComponent("pizza")
            .appendingPathComponent(pizza)
    }
}
