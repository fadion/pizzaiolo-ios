//
//  CondimentView.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 21/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import SnapKit

class MakerCondimentView: UIStackView {
    
    private var active = false

    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: 0xE9E9E9)
        button.setTitleColor(UIColor(hex: Theme.Color.body), for: .normal)
        button.setTitleColor(UIColor(hex: Theme.Color.body), for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: Theme.Font.body)
        button.cornerRadius = 5.0
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hex: 0xC2C2C2)?.cgColor
        
        return button
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(hex: Theme.Color.title)
        label.font = UIFont.systemFont(ofSize: Theme.Font.body)
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
    }
    
    convenience init(title: String, price: Int) {
        self.init(frame: .zero)
        
        self.button.setTitle(title, for: .normal)
        self.label.text = "+\(Money(price).format())"
    }
    
    private func setupViews() {
        self.axis = .horizontal
        self.alignment = .fill
        self.spacing = 15.0
        self.isLayoutMarginsRelativeArrangement = true
        
        self.addArrangedSubview(self.button)
        self.addArrangedSubview(self.label)
    }
    
    func toggleState(callback: (Bool) -> Void) {
        if self.active {
            self.button.backgroundColor = UIColor(hex: 0xE9E9E9)
            self.button.layer.borderColor = UIColor(hex: 0xC2C2C2)?.cgColor
            
            self.button.setTitleColor(UIColor(hex: Theme.Color.body), for: .normal)
            self.button.setTitleColor(UIColor(hex: Theme.Color.body), for: .selected)
            
            self.label.textColor = UIColor(hex: Theme.Color.body)
            
            self.active = false
        }
        else {
            self.button.backgroundColor = UIColor(hex: Theme.Color.highlight)
            self.button.layer.borderColor = UIColor(hex: Theme.Color.highlight)?.cgColor
            
            self.button.setTitleColor(.white, for: .normal)
            self.button.setTitleColor(.white, for: .selected)
            
            self.label.textColor = UIColor(hex: Theme.Color.highlight)
            
            self.active = true
        }
        
        callback(self.active)
    }

}
