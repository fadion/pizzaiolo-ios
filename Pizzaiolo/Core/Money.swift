//
//  Money.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 20/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation

class Money {
    
    private let value: Int
    
    init(_ value: Int) {
        self.value = value
    }
    
    func format() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        
        return formatter.string(from: self.toDouble(number: self.value))!
    }
    
    private func toDouble(number: Int) -> NSNumber {
        return (Double(number) / 100.0) as NSNumber
    }
    
}
