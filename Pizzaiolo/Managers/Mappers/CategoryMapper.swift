//
//  CategoryMapper.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 05/04/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxCocoa
import RxSwift
import RealmSwift

class CategoryMapper {
    
    private let data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    public func fromJSON() -> Observable<[CategoryViewModel]> {
        return Observable.create { observer in
            DispatchQueue(label: "com.pizzaiolo.mapper", qos: .utility).async {
                if let json = JSON(self.data)["category"].array {
                    let viewModels = json.map { item -> CategoryViewModel in
                        let model = Category()
                        
                        model.id = item["id"].intValue
                        model.name = item["name"].stringValue
                        
                        try! model.createOrUpdate()
                        
                        return CategoryViewModel(model: model)
                    }
                    
                    let ids = viewModels.map { $0.id }
                    let realm = try! Realm()
                    let objects = realm.objects(Category.self).filter(NSPredicate(format: "NOT id IN %@", ids))
                    
                    try! realm.write {
                        realm.delete(objects)
                    }
                    
                    observer.onNext(viewModels)
                    observer.onCompleted()
                }
                else {
                    observer.onError(MapperError.couldntParse)
                }
            }
            
            return Disposables.create()
        }.observeOn(MainScheduler.instance)
    }
    
}
