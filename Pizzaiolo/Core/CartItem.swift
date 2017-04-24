//
//  CartItem.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 20/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources

class CartItem: IdentifiableType, Equatable {
    
    let id: Int
    let name: String
    let summary: String
    let price: Int
    let photo: UIImage
    var quantity = Variable<Int>(0)
    
    var identity: Int {
        return self.id + self.quantity.value
    }
    
    static func ==(lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.identity == rhs.identity
    }
    
    init(id: Int, name: String, summary: String, price: Int, photo: UIImage, quantity: Int = 1) {
        self.id = id
        self.name = name
        self.summary = summary
        self.price = price
        self.photo = photo
        self.quantity.value = quantity
    }
    
}
