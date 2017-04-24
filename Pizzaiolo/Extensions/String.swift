//
//  String.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 29/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation

extension String {
    func hash() -> Int {
        let sum =  self.characters
            .map { String($0).unicodeScalars.first?.value }
            .flatMap { $0 }
            .reduce(0, +)
        
        return Int(sum)
    }
}
