//
//  AddToCartButton.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 26/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import SnapKit

class AddToCartView: UIView {

    let price: PaddedLabel = {
        let label = PaddedLabel()
        label.font = UIFont.boldSystemFont(ofSize: Theme.Font.heading3)
        label.backgroundColor = .white
        label.cornerRadius = 15.0
        label.textColor = UIColor(hex: Theme.Color.highlight)
        label.textAlignment = .center
        label.rightInset = 17.0
        
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(hex: Theme.Color.highlight)
        button.setImage(UIImage(named: "AddToCart"), for: .normal)
        button.setImage(UIImage(named: "AddToCart"), for: .highlighted)
        button.imageView?.contentMode = .center
        button.cornerRadius = 18.0
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
    }
    
    private func setupViews() {
        self.addSubview(self.price)
        self.addSubview(self.button)
        
        self.price.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(90)
            make.height.equalTo(35)
        }
        
        self.button.snp.makeConstraints { [unowned self] make in
            make.top.equalToSuperview().offset(-2)
            make.width.equalTo(60)
            make.height.equalTo(39)
            make.left.equalTo(self.price.snp.right).offset(-20)
        }
    }

}
