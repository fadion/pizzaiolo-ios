//
//  ScrollViewWithControls.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 21/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit

class ScrollViewWithControls: UIScrollView {

    override func touchesShouldCancel(in view: UIView) -> Bool {
        if view is UIControl {
            return true
        }
        
        return super.touchesShouldCancel(in: view)
    }

}
