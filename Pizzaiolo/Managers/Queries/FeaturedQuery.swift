//
//  FeaturedQuery.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 08/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RealmSwift

class FeaturedQuery {
    
    func all() -> Observable<[FeaturedViewModel]> {
        return Observable.create { observer in
            let realm = try! Realm()
            let results = realm.objects(Featured.self).sorted(byKeyPath: "position", ascending: true)
            
            observer.onNext(self.map(results))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    private func map(_ results: Results<Featured>) -> [FeaturedViewModel] {
        return Array(results).map { FeaturedViewModel(model: $0) }
    }
    
}
