//
//  CategoryCollectionCell.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 06/04/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit

class CategoryCollectionCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    let name: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Theme.Font.body)
        label.textColor = UIColor(hex: Theme.Color.body)
        label.textAlignment = .center
        
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.name.textColor = UIColor(hex: Theme.Color.highlight)
            } else {
                self.name.textColor = UIColor(hex: Theme.Color.body)
            }
        }
    }
    
    var viewModel: CategoryViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            
            vm.name.asObservable()
                .subscribe(onNext: { [weak self] value in
                    self?.name.text = value
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
        self.addSubview(self.name)

        self.name.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
