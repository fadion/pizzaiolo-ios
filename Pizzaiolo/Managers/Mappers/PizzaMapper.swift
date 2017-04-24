//
//  PizzaMapper.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 07/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxCocoa
import RxSwift
import RealmSwift

class PizzaMapper {
    
    private let data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    public func fromJSON() -> Observable<[PizzaViewModel]> {
        return Observable.create { observer in
            DispatchQueue(label: "com.pizzaiolo.mapper", qos: .utility).async {
                if let json = JSON(self.data)["pizza"].array {
                    let realm = try! Realm()
                    
                    let viewModels = json.map { item -> PizzaViewModel in
                        let model = Pizza()
                        
                        model.id = item["id"].intValue
                        model.name = item["name"].stringValue
                        model.summary = item["summary"].stringValue
                        model.price = item["price"].intValue
                        model.photo = item["photo"].stringValue
                        
                        if let categories = item["category"].array?.map({ $0.intValue }) {
                            let objects = realm.objects(Category.self).filter(NSPredicate(format: "id IN %@", categories))
                            model.categories.append(objectsIn: objects)
                        }
                        
                        try! model.createOrUpdate()
                        
                        return PizzaViewModel(model: model)
                    }
                    
                    let ids = viewModels.map { $0.id }
                    let objects = realm.objects(Pizza.self).filter(NSPredicate(format: "NOT id IN %@", ids))
                    
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
