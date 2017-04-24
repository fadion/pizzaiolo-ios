//
//  Pizza.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 01/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import RealmSwift

class Pizza: Object, Model {
    
    dynamic var id = 0
    dynamic var name = ""
    dynamic var summary = ""
    dynamic var price = 0
    dynamic var photo = ""
    let categories = List<Category>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
