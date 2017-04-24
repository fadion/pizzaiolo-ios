//
//  UIBarButtonItem+Badge.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 19/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import SnapKit

/*
 * Based on the implementation by "yonat" and "basememara"
 * https://gist.github.com/yonat/75a0f432d791165b1fd6
 */

extension UIBarButtonItem {
    private static let badgeTag = 1985
    
    convenience init(badge: String?, button: UIButton, target: AnyObject?, action: Selector) {
        button.addTarget(target, action: action, for: .touchUpInside)
        button.sizeToFit()
        
        let label = PaddedLabel()
        label.text = badge ?? ""
        label.textColor = .white
        label.backgroundColor = UIColor(hex: Theme.Color.highlight)
        label.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tag = UIBarButtonItem.badgeTag
        label.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        label.alpha = 0
        label.layer.cornerRadius = 5.0
        label.clipsToBounds = true
        label.topInset = 0
        label.bottomInset = 0
        label.leftInset = 2.0
        label.rightInset = 2.0
        
        if badge == nil || label.text == "" {
            label.isHidden = true
        }
        
        button.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.width.greaterThanOrEqualTo(label.snp.height)
            make.top.equalTo(button.snp.top).offset(-7)
            make.centerX.equalTo(button).offset(-3)
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: {
            label.transform = CGAffineTransform.identity
            label.alpha = 1
        }, completion: nil)
        
        self.init(customView: button)
    }
    
    convenience init(badge: String?, image: UIImage?, target: AnyObject?, action: Selector) {
        let button = UIButton(type: .custom)
        
        if let image = image {
            button.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
            button.setBackgroundImage(image, for: .normal)
        }
        
        self.init(badge: badge, button: button, target: target, action: action)
    }
    
    var badgeLabel: UILabel? {
        return self.customView?.viewWithTag(UIBarButtonItem.badgeTag) as? UILabel
    }
    
    var badgeString: String? {
        get {
            return badgeLabel?.text?.trimmingCharacters(in: NSCharacterSet.whitespaces)
        }
        set {
            if let badgeLabel = self.badgeLabel {
                badgeLabel.text = newValue == nil ? nil : " \(newValue!) "
                badgeLabel.sizeToFit()
                badgeLabel.isHidden = newValue == nil
            }
        }
    }
}
