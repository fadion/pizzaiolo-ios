//
//  ErrorView.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 10/04/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import SnapKit

class NetworkErrorView: UIView {
    
    let photo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "Pepperoni-Slice")
        
        return image
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Theme.Font.heading1)
        label.textColor = UIColor(hex: Theme.Color.title)
        label.text = "What’s this?"
        
        return label
    }()
    
    let message: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: Theme.Font.body)
        label.textColor = UIColor(hex: Theme.Color.body)
        label.text = "You appear to be offline or have some problem connecting to the server. Quick, the pizza is already in the oven!"
        label.numberOfLines = 0
        label.sizeToFit()
        
        return label
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Retry", for: .normal)
        button.backgroundColor = UIColor(hex: Theme.Color.highlight)
        button.layer.cornerRadius = 5.0
        
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
        self.animate()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupViews()
        self.animate()
    }
    
    convenience init(withAction: @escaping () -> Void) {
        self.init(frame: .zero)
        self.button.addAction(forEvent: .touchUpInside) {
            withAction()
        }
    }
    
    private func setupViews() {
        self.addSubview(self.photo)
        self.addSubview(self.message)
        self.addSubview(self.title)
        self.addSubview(self.button)
        
        self.photo.snp.makeConstraints { make in
            make.width.equalTo(84)
            make.height.equalTo(79)
            make.top.equalToSuperview().offset(130)
            make.centerX.equalToSuperview()
        }
        
        self.title.snp.makeConstraints { [unowned self] make in
            make.width.equalToSuperview().offset(-40)
            make.top.equalTo(self.photo.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
        }
        
        self.message.snp.makeConstraints { [unowned self] make in
            make.width.equalToSuperview().offset(-40)
            make.top.equalTo(self.title.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        self.button.snp.makeConstraints { [unowned self] make in
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.message.snp.bottom).offset(20)
        }
    }
    
    private func animate() {
        let scale = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        self.photo.transform = CGAffineTransform(translationX: 0, y: -50)
        self.photo.alpha = 0
        
        self.title.transform = scale
        self.title.alpha = 0
        
        self.message.transform = scale
        self.message.alpha = 0
        
        self.button.transform = scale
        self.button.alpha = 0
        
        UIView.animate(withDuration: 0.3) {
            self.photo.transform = CGAffineTransform.identity
            self.photo.alpha = 1
            
            self.title.transform = CGAffineTransform.identity
            self.title.alpha = 1
            
            self.message.transform = CGAffineTransform.identity
            self.message.alpha = 1
            
            self.button.transform = CGAffineTransform.identity
            self.button.alpha = 1
        }
    }

}
