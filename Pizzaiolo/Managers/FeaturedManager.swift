//
//  FeaturedManager.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 02/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class FeaturedManager {
    
    private let disposeBag = DisposeBag()
    
    func all() -> Observable<[FeaturedViewModel]> {
        let network = Network().fetch(url: API.featured)
            .flatMap { FeaturedMapper(data: $0).fromJSON() }
        
        let local = FeaturedQuery().all()
        
        // merge() combines the two observables asynchronously,
        // returning each one once finished. Logically, the local
        // observer will finish first, followed by the network,
        // causing the UI to update twice. distinctUntilChanged()
        // prevents that as long as the local data is the same
        // as the remote. filter() removes empty results (ie. when
        // there's no local data).
        return Observable<Observable<[FeaturedViewModel]>>
            .of(network, local)
            .merge()
            .filter { $0.count > 1 }
            .distinctUntilChanged { v1, v2 in
                v1.map { $0.hashValue }.sorted() == v2.map { $0.hashValue }.sorted()
            }
            .shareReplay(1)
    }
    
    func photo(filename: String) -> Observable<Data> {
        return Network().downloadImage(url: API.photo(featured: filename))
    }
    
}
