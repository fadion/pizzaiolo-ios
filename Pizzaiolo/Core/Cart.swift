//
//  Cart.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 20/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class Cart {
    
    static let instance = Cart()
    
    private var items = Variable<[CartItem]>([])
    
    private init() {}
    
    func withItems(items: [CartItem]) {
        self.items.value = items
    }
    
    func add(item: CartItem) {
        if !self.update(item: item) {
            self.items.value.append(item)
        }
    }
    
    private func exists(item: CartItem) -> Array<Any>.Index? {
        return self.items.value.index(where: { $0.id == item.id })
    }
    
    @discardableResult
    func update(item: CartItem, onlyQuantity: Bool = true) -> Bool {
        if let index = self.exists(item: item) {
            if onlyQuantity {
                self.items.value[index].quantity.value += item.quantity.value
                
                // Maybe because it's an object property, but updating
                // the quantity doesn't always result in the correct value
                // in the count() method. This fixes the problem.
                self.items.value = self.items.value
            }
            else {
                self.items.value[index] = item
            }
            
            return true
        }
        
        return false
    }
    
    @discardableResult
    func remove(item: CartItem) -> Bool {
        if let index = self.exists(item: item) {
            self.items.value.remove(at: index)
            return true
        }
        
        return false
    }
    
    func clear() {
        self.items.value.removeAll()
    }
    
    @discardableResult
    func increment(item: CartItem) -> Bool {
        if let index = self.exists(item: item) {
            self.items.value[index].quantity.value += 1
            self.items.value = self.items.value
            return true
        }
        
        return false
    }
    
    @discardableResult
    func decrement(item: CartItem) -> Bool {
        if let index = self.exists(item: item) {
            if self.items.value[index].quantity.value > 0 {
                self.items.value[index].quantity.value -= 1
                
                // No need for items with zero quantity in the cart.
                if self.items.value[index].quantity.value == 0 {
                    self.remove(item: item)
                }
                
                self.items.value = self.items.value
                
                return true
            }
        }
        
        return false
    }
    
    func count() -> Observable<Int> {
        return self.items.asObservable()
            .flatMap { items -> Observable<Int> in
                return Observable.just(items.reduce(0) { $0 + $1.quantity.value })
            }
    }
    
    func sum() -> Observable<Int> {
        return self.items.asObservable()
            .flatMap { items -> Observable<Int> in
                return Observable.just(items.reduce(0) { $0 + $1.price * $1.quantity.value })
            }
    }
    
    func contents() -> Observable<[CartItem]> {
        return self.items.asObservable()
    }
    
}
