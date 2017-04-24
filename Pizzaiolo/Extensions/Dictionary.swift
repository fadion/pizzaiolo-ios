//
//  Dictionary.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 03/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation

extension Dictionary {
    func merge(with: Dictionary...) -> Dictionary {
        var final = self
        
        for dictionary in with {
            for (key, value) in dictionary {
                final.updateValue(value, forKey: key)
            }
        }
        
        return final
    }
}
