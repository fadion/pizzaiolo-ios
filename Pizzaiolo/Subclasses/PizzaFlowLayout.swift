//
//  PizzaFlowLayout.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 17/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit

class PizzaFlowLayout: UICollectionViewFlowLayout {
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}
