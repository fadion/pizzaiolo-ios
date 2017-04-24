//
//  FeaturedViewModel.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 02/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxOptional

class FeaturedViewModel: Hashable {
    
    private let model: Featured
    private let disposeBag = DisposeBag()
    
    var id: Int
    var title: Variable<String>
    var subtitle: Variable<String>
    var priceWas: Variable<Int?>
    var price: Variable<Int?>
    var position: Int
    var photo: Variable<String>
    
    var hashValue: Int {
        return self.id
            + self.title.value.hash()
            + self.subtitle.value.hash()
            + (self.priceWas.value ?? 0 )
            + (self.price.value ?? 0)
            + self.position
            + self.photo.value.hash()
    }
    
    static func ==(lhs: FeaturedViewModel, rhs: FeaturedViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    init(model: Featured) {
        self.model = model
        
        self.id = model.id
        self.title = Variable<String>(model.title)
        self.subtitle = Variable<String>(model.subtitle)
        self.priceWas = Variable<Int?>(model.priceWas.value)
        self.price = Variable<Int?>(model.price.value)
        self.position = model.position
        self.photo = Variable<String>(model.photo)
        
        self.title.asObservable()
            .subscribe(onNext: { [weak self] value in
                try! self?.model.update(fields: ["title": value])
            }).disposed(by: self.disposeBag)
        
        self.subtitle.asObservable()
            .subscribe(onNext: { [weak self] value in
                try! self?.model.update(fields: ["subtitle": value])
            }).disposed(by: self.disposeBag)
        
        self.priceWas.asObservable()
            .subscribe(onNext: { [weak self] value in
                try! self?.model.update(fields: ["priceWas": value])
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
    
    func priceWasAsCurrency() -> Observable<String> {
        return self.priceWas.asObservable()
            .filterNil()
            .map { Money($0).format() }
    }
    
    func priceAsCurrency() -> Observable<String> {
        return self.price.asObservable()
            .filterNil()
            .map { Money($0).format() }
    }
    
}
