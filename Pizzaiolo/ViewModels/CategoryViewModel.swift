//
//  CategoryViewModel.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 05/04/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CategoryViewModel: Hashable {
    
    private let model: Category
    private let disposeBag = DisposeBag()
    
    var id: Int
    var name: Variable<String>
    
    var hashValue: Int {
        return self.id + self.name.value.hash()
    }
    
    static func ==(lhs: CategoryViewModel, rhs: CategoryViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    required init(model: Category) {
        self.model = model
        
        self.id = model.id
        self.name = Variable<String>(model.name)
        
        self.name.asObservable()
            .subscribe(onNext: { [weak self] value in
                try! self?.model.update(fields: ["name": value])
            }).disposed(by: self.disposeBag)
    }
    
}
