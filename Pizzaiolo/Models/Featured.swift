//
//  Featured.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 01/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import RealmSwift

class Featured: Object, Model {
    
    dynamic var id = 0
    dynamic var title = ""
    dynamic var subtitle = ""
    let priceWas = RealmOptional<Int>()
    let price = RealmOptional<Int>()
    dynamic var position = 0
    dynamic var photo = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
