//
//  CartCell.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 26/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

class CartTableCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    let photo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        
        return image
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Theme.Font.body)
        label.textColor = UIColor(hex: Theme.Color.title)
        
        return label
    }()
    
    let summary: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Theme.Font.small)
        label.textColor = UIColor(hex: Theme.Color.body)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        
        return label
    }()
    
    let quantity: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Theme.Font.small)
        label.textColor = UIColor(hex: Theme.Color.body)
        
        return label
    }()
    
    let rowTotal: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Theme.Font.small)
        label.textColor = UIColor(hex: Theme.Color.highlight)
        
        return label
    }()
    
    let quantityUp: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Quantity-Up"), for: .normal)
        
        return button
    }()
    
    let quantityDown: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Quantity-Down"), for: .normal)
        
        return button
    }()

    var item: CartItem? {
        didSet {
            guard let item = item else { return }
            
            self.name.text = item.name
            self.summary.text = item.summary
            self.photo.image = item.photo
            
            item.quantity.asObservable()
                .map { Money($0 * item.price).format() }
                .bindTo(self.rowTotal.rx.text)
                .disposed(by: self.disposeBag)
            
            item.quantity.asObservable()
                .map { "×\($0)" }
                .bindTo(self.quantity.rx.text)
                .disposed(by: self.disposeBag)
            
            item.quantity.asObservable()
                .map { $0 > 1 }
                .bindTo(self.quantityDown.rx.isEnabled)
                .disposed(by: self.disposeBag)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
    
    private func setupViews() {
        self.addSubview(self.photo)
        self.addSubview(self.name)
        self.addSubview(self.quantity)
        self.addSubview(self.rowTotal)
        self.addSubview(self.summary)
        self.addSubview(self.quantityUp)
        self.addSubview(self.quantityDown)
        
        self.photo.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(50)
        }
        
        self.name.snp.makeConstraints { [unowned self] make in
            make.top.equalToSuperview().offset(10)
            make.left.equalTo(self.photo.snp.right).offset(10)
        }
        
        self.quantity.snp.makeConstraints { [unowned self] make in
            make.left.equalTo(self.photo.snp.right).offset(10)
            make.top.equalTo(self.name.snp.bottom).offset(5)
        }
        
        self.rowTotal.snp.makeConstraints { [unowned self] make in
            make.left.equalTo(self.quantity.snp.right).offset(10)
            make.top.equalTo(self.name.snp.bottom).offset(5)
        }
        
        self.summary.snp.makeConstraints { [unowned self] make in
            make.width.equalToSuperview().offset(-70)
            make.left.equalToSuperview().offset(10)
            make.top.equalTo(self.photo.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        self.quantityUp.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview().offset(-20)
            make.right.equalToSuperview().offset(-10)
        }
        
        self.quantityDown.snp.makeConstraints { make in
            make.width.height.equalTo(30)
            make.centerY.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-10)
        }
    }

}
