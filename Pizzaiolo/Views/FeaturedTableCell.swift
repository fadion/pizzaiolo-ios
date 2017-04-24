//
//  FeaturedTableCell.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 05/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class FeaturedTableCell: UITableViewCell {
    
    var disposeBag = DisposeBag()
    
    let photo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.backgroundColor = UIColor(hex: Theme.Color.placeholder)
        
        return image
    }()
    
    let overlay: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0x000000, alpha: 0.3)
        view.isHidden = true
        
        return view
    }()
    
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Theme.Font.heading1)
        label.textColor = UIColor.white
        
        return label
    }()
    
    let subtitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Theme.Font.heading3)
        label.textColor = UIColor.white
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    let priceWas: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Theme.Font.body)
        label.textColor = UIColor.white
        label.isHidden = true
        
        return label
    }()
    
    let price: PaddedLabel = {
        let label = PaddedLabel()
        label.font = UIFont.systemFont(ofSize: Theme.Font.body)
        label.textColor = UIColor.white
        label.backgroundColor = UIColor(hex: Theme.Color.highlight)
        label.cornerRadius = 10.0
        label.isHidden = true
        
        return label
    }()
    
    let priceHolder: UIStackView = {
        let stackview = UIStackView()
        stackview.alignment = .center
        
        return stackview
    }()
    
    var viewModel: FeaturedViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            
            var align: NSTextAlignment = .center
            
            // Vary the aligment once left and once
            // right, so it feels a tad less boring.
            if vm.position != 1 {
                align = vm.position % 2 == 0 ? .left : .right
            }
            
            vm.title.asObservable()
                .subscribe(onNext: { [weak self] value in
                    self?.title.text = value
                    self?.title.textAlignment = align
                }).disposed(by: self.disposeBag)
            
            vm.subtitle.asObservable()
                .subscribe(onNext: { [weak self] value in
                    self?.subtitle.text = value
                    self?.subtitle.textAlignment = align
                }).disposed(by: self.disposeBag)
            
            vm.priceWasAsCurrency()
                .subscribe(onNext: { [weak self] value in
                    self?.priceWas.isHidden = false
                    self?.priceWas.strikethrough(text: value)
                }).disposed(by: self.disposeBag)
            
            vm.priceAsCurrency()
                .subscribe(onNext: { [weak self] value in
                    self?.price.isHidden = false
                    self?.price.text = value
                }).disposed(by: self.disposeBag)
            
            
            FeaturedManager().photo(filename: vm.photo.value)
                .subscribe(onNext: { [weak self] data in
                    self?.photo.image = UIImage(data: data)
                    self?.overlay.isHidden = false
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
        self.addSubview(self.overlay)
        self.addSubview(self.title)
        self.addSubview(self.subtitle)
        
        self.priceHolder.addArrangedSubview(self.priceWas)
        self.priceHolder.addArrangedSubview(self.price)
        
        self.addSubview(self.priceHolder)
        
        self.photo.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.overlay.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.title.snp.makeConstraints { make in
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
        }
        
        self.subtitle.snp.makeConstraints { [unowned self] make in
            make.width.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.top.equalTo(self.title.snp.bottom)
        }
        
        self.priceHolder.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-25)
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
        }
    }
    
}
