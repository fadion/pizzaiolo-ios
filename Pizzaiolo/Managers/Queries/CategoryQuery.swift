//
//  CategoryQuery.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 05/04/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RealmSwift

class CategoryQuery {
    
    func all() -> Observable<[CategoryViewModel]> {
        return Observable.create { observer in
            let realm = try! Realm()
            let results = realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true)
            
            observer.onNext(self.map(results))
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    private func map(_ results: Results<Category>) -> [CategoryViewModel] {
        return Array(results).map { CategoryViewModel(model: $0) }
    }
    
}
