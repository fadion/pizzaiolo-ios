//
//  PizzaMenu.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 13/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import QuartzCore

class PizzaMenuCollectionCell: UICollectionViewCell {

    var disposeBag = DisposeBag()
    
    let photo: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.cornerRadius = 40.0
        image.isUserInteractionEnabled = true
        
        return image
    }()
    
    var viewModel: PizzaViewModel? {
        didSet {
            guard let vm = viewModel else { return }
            
            PizzaManager().photo(filename: vm.photo.value)
                .subscribe(onNext: { [weak self] data in
                    self?.photo.image = UIImage(data: data)
                }).disposed(by: self.disposeBag)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.addSubview(self.photo)
        
        self.photo.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }

}
