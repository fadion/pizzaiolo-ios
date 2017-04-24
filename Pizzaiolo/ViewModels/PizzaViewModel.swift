//
//  PizzaViewModel.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 07/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class PizzaViewModel: Hashable {
    
    private let model: Pizza
    private let disposeBag = DisposeBag()
    
    var id: Int
    var name: Variable<String>
    var summary: Variable<String>
    var price: Variable<Int>
    var photo: Variable<String>
    var categories: Variable<[CategoryViewModel]>
    
    var hashValue: Int {
        return self.id
            + self.name.value.hash()
            + self.summary.value.hash()
            + self.price.value
            + self.photo.value.hash()
    }
    
    static func ==(lhs: PizzaViewModel, rhs: PizzaViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    init(model: Pizza) {
        self.model = model
        
        self.id = model.id
        self.name = Variable<String>(model.name)
        self.summary = Variable<String>(model.summary)
        self.price = Variable<Int>(model.price)
        self.photo = Variable<String>(model.photo)
        self.categories = Variable<[CategoryViewModel]>(Array(model.categories)
            .map { CategoryViewModel(model: $0) })
        
        self.name.asObservable()
            .subscribe(onNext: { [weak self] value in
                try! self?.model.update(fields: ["name": value])
            }).disposed(by: self.disposeBag)
        
        self.summary.asObservable()
            .subscribe(onNext: { [weak self] value in
                try! self?.model.update(fields: ["summary": value])
            }).disposed(by: self.disposeBag)
        
        self.price.asObservable()
            .subscribe(onNext: { [weak self] value in
                try! self?.model.update(fields: ["price": value])
            }).disposed(by: self.disposeBag)
        
        self.photo.asObservable()
            .subscribe(onNext: { [weak self] value in
                try! self?.model.update(fields: ["photo": value])
            }).disposed(by: self.disposeBag)
    }
    
    func priceAsCurrency() -> Observable<String> {
        return self.price.asObservable()
            .map { Money($0).format() }
    }
    
}
