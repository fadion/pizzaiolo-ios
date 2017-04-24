//
//  CategoryManager.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 05/04/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class CategoryManager {
    
    private let disposeBag = DisposeBag()
    
    func all() -> Observable<[CategoryViewModel]> {
        let network = Network().fetch(url: API.categories)
            .flatMap { CategoryMapper(data: $0).fromJSON() }
        
        let local = CategoryQuery().all()
        
        return Observable<Observable<[CategoryViewModel]>>
            .of(network, local)
            .merge()
            .filter { $0.count > 1 }
            .distinctUntilChanged { r1, r2 in
                r1.map { $0.hashValue }.sorted() == r2.map { $0.hashValue }.sorted()
            }
            .shareReplay(1)
    }
    
}
