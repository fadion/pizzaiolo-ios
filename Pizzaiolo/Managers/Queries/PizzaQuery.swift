//
//  PizzaQuery.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 10/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RealmSwift

class PizzaQuery {
    
    func all() -> Observable<[PizzaViewModel]> {
        return Observable.create { observer in
            let realm = try! Realm()
            let results = realm.objects(Pizza.self).sorted(byKeyPath: "id", ascending: true)
            
            observer.onNext(self.map(results))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func whereCategory(ids: [Int]) -> Observable<[PizzaViewModel]> {
        return Observable.create { observer in
            let realm = try! Realm()
            let results = realm.objects(Pizza.self)
                .filter(NSPredicate(format: "ANY categories.id IN %@", ids))
                .sorted(byKeyPath: "id", ascending: true)
            
            observer.onNext(self.map(results))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    private func map(_ results: Results<Pizza>) -> [PizzaViewModel] {
        return Array(results).map { PizzaViewModel(model: $0) }
    }
    
}
