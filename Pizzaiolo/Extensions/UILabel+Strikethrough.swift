//
//  StrikethroughLabel.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 19/02/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit

extension UILabel {
    @IBInspectable var strikethrough: Bool {
        get {
            return self.attributedText?.attribute(NSStrikethroughStyleAttributeName, at: 0, effectiveRange: nil) != nil
        }
        set {
            if newValue {
                self.attributedText = NSAttributedString(string: self.text!, attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
            }
            else {
                self.attributedText = NSAttributedString(string: self.text!, attributes: [:])
            }
        }
    }
    
    func strikethrough(text: String) {
        self.attributedText = NSAttributedString(string: text, attributes: [NSStrikethroughStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue])
    }
}
