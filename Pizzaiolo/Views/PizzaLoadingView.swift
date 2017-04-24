//
//  PizzaLoadingView.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 10/04/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit

import UIKit
import SnapKit

class PizzaLoadingView: UIView {
    
    let photo: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: Theme.Color.placeholder)
        // Half of its width and height.
        view.layer.cornerRadius = 110
        
        return view
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Theme.Font.heading2)
        label.text = " "
        label.layer.backgroundColor = UIColor(hex: Theme.Color.placeholder)?.cgColor
        
        return label
    }()
    
    let summaryFirst: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Theme.Font.body)
        label.text = " "
        label.layer.backgroundColor = UIColor(hex: Theme.Color.placeholder)?.cgColor
        
        return label
    }()
    
    let summarySecond: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Theme.Font.body)
        label.text = " "
        label.layer.backgroundColor = UIColor(hex: Theme.Color.placeholder)?.cgColor
        
        return label
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
    
    private func setupViews() {
        self.addSubview(self.photo)
        self.addSubview(self.name)
        self.addSubview(self.summaryFirst)
        self.addSubview(self.summarySecond)
        
        self.photo.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(220)
            make.centerX.equalToSuperview()
        }
        
        self.name.snp.makeConstraints { [unowned self] make in
            make.top.equalTo(self.photo.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-160)
            make.centerX.equalToSuperview()
        }
        
        self.summaryFirst.snp.makeConstraints { [unowned self] make in
            make.top.equalTo(self.name.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
        }
        
        self.summarySecond.snp.makeConstraints { [unowned self] make in
            make.top.equalTo(self.summaryFirst.snp.bottom).offset(5)
            make.width.equalToSuperview().offset(-100)
            make.centerX.equalToSuperview()
        }
    }
    
    private func animate() {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [.repeat, .autoreverse], animations: {
            // Only the backgroundColor of the CALayer is animatable.
            self.name.layer.backgroundColor = UIColor(hex: 0xdddddd)?.cgColor
            self.summaryFirst.layer.backgroundColor = UIColor(hex: 0xdddddd)?.cgColor
            self.summarySecond.layer.backgroundColor = UIColor(hex: 0xdddddd)?.cgColor
            
            // For UIView, the backgroundColor can be animated as normal.
            self.photo.backgroundColor = UIColor(hex: 0xdddddd)
        }, completion: nil)
    }
    
}
