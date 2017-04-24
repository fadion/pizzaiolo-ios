//
//  PizzaCollectionCell.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 12/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import EasyAnimation

class PizzaCollectionCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    let photo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.image = UIImage(named: "Pizza-Base")
        
        return image
    }()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Theme.Font.heading2)
        label.textColor = UIColor(hex: Theme.Color.title)
        label.textAlignment = .center
        
        return label
    }()
    
    let summary: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Theme.Font.body)
        label.textColor = UIColor(hex: Theme.Color.body)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        
        return label
    }()
    
    var addToCart = AddToCartView()
    
    var viewModel: PizzaViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            
            vm.name.asObservable()
                .subscribe(onNext: { [weak self] value in
                    self?.name.text = value
                }).disposed(by: self.disposeBag)
            
            vm.summary.asObservable()
                .subscribe(onNext: { [weak self] value in
                    self?.summary.text = value
                }).disposed(by: self.disposeBag)
            
            vm.priceAsCurrency()
                .subscribe(onNext: { [weak self] value in
                    self?.addToCart.price.text = value
                }).disposed(by: self.disposeBag)
            
            PizzaManager().photo(filename: vm.photo.value)
                .subscribe(onNext: { [weak self] data in
                    self?.photo.image = UIImage(data: data)
                }).disposed(by: self.disposeBag)
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
        self.addSubview(self.summary)
        
        self.addToCart = AddToCartView()
        self.addSubview(addToCart)
        
        self.photo.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.height.equalTo(220)
            make.centerX.equalToSuperview()
        }
        
        self.name.snp.makeConstraints { [unowned self] make in
            make.top.equalTo(self.photo.snp.bottom).offset(20)
            make.width.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
        
        self.summary.snp.makeConstraints { [unowned self] make in
            make.top.equalTo(self.name.snp.bottom).offset(10)
            make.width.equalToSuperview().offset(-20)
            make.centerX.equalToSuperview()
        }
        
        self.addToCart.snp.makeConstraints { [unowned self] make in
            make.bottom.equalTo(self.photo.snp.bottom).offset(-30)
            make.width.equalTo(120)
            make.height.equalTo(35)
            make.centerX.equalToSuperview().offset(50)
        }
    }
    
    func animateParallax(position: CGFloat) {
        // Position is multiplied with different factors
        // to give a subtle parallax effect.
        self.photo.transform = CGAffineTransform(rotationAngle: position / self.frame.width * 0.5)
        self.addToCart.transform = CGAffineTransform(translationX: position * 0.2, y: 0)
        self.name.transform = CGAffineTransform(translationX: position * 0.5, y: 0)
        self.summary.transform = CGAffineTransform(translationX: position * 0.7, y: 0)
    }
    
    func animateAddToCartButton() {
        UIView.animateAndChain(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
            self.addToCart.button.transform = CGAffineTransform(translationX: -self.addToCart.frame.size.width + self.addToCart.button.frame.width, y: 0)
            
            self.addToCart.price.alpha = 0
            
            self.photo.transform = CGAffineTransform(scaleX: 1.1, y: 1.1).concatenating(CGAffineTransform(rotationAngle: -0.1))
        }, completion: nil).animate(withDuration: 0.3, delay: 0.05, options: [.curveEaseInOut], animations: {
            self.addToCart.button.transform = CGAffineTransform.identity
            self.addToCart.price.alpha = 1
            
            self.photo.transform = CGAffineTransform.identity
        }, completion: nil)
    }
    
}
