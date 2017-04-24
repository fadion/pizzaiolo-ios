//
//  UIButton+Action.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 10/04/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit

/*
 * Based on the implementation by "Armanoide".
 * http://stackoverflow.com/a/34016897
 */

extension UIButton {
    private func actionHandleBlock(action:(() -> Void)? = nil) {
        struct __ {
            static var action :(() -> Void)?
        }
        if action != nil {
            __.action = action
        } else {
            __.action?()
        }
    }
    
    @objc private func triggerActionHandleBlock() {
        self.actionHandleBlock()
    }
    
    func addAction(forEvent: UIControlEvents, action: @escaping () -> Void) {
        self.actionHandleBlock(action: action)
        self.addTarget(self, action: #selector(UIButton.triggerActionHandleBlock), for: forEvent)
    }
}
