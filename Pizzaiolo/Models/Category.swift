//
//  Category.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 01/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import RealmSwift

class Category: Object, Model {
    
    dynamic var id = 0
    dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
