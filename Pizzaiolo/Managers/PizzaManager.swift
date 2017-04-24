//
//  PizzaManager.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 07/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class PizzaManager {
    
    private let disposeBag = DisposeBag()
    
    func all() -> Observable<[PizzaViewModel]> {
        let network = Network().fetch(url: API.pizza)
            .flatMap { PizzaMapper(data: $0).fromJSON() }
        
        let local = PizzaQuery().all()
        
        return Observable<Observable<[PizzaViewModel]>>
            .of(network, local)
            .merge()
            .filter { $0.count > 1 }
            .distinctUntilChanged { v1, v2 in
                v1.map { $0.hashValue }.sorted() == v2.map { $0.hashValue }.sorted()
            }
            .shareReplay(1)
    }
    
    func whereCategory(ids: [Int]) -> Observable<[PizzaViewModel]> {
        return PizzaQuery().whereCategory(ids: ids)
    }
    
    func photo(filename: String) -> Observable<Data> {
        return Network().downloadImage(url: API.photo(pizza: filename))
    }
    
}
