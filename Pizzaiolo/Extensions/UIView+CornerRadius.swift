//
//  RoundedLabel.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 19/02/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = newValue > 0
        }
    }
}
