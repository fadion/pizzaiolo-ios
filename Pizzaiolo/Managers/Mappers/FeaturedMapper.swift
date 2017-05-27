//
//  FeaturedJsonMapper.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 28/02/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxCocoa
import RxSwift
import RealmSwift

class FeaturedMapper {
    
    private let data: Data
    
    init(data: Data) {
        self.data = data
    }
    
    public func fromJSON() -> Observable<[FeaturedViewModel]> {
        return Observable.create { observer in
            DispatchQueue(label: "com.pizzaiolo.mapper", qos: .utility).async {
                if let json = JSON(self.data).array {
                    let viewModels = json.map { item -> FeaturedViewModel in
                        let model = Featured()
                        
                        model.id = item["id"].intValue
                        model.title = item["title"].stringValue
                        model.subtitle = item["subtitle"].stringValue
                        model.priceWas.value = item["price_was"].int
                        model.price.value = item["price"].int
                        model.position = item["position"].intValue
                        model.photo = item["photo"].stringValue
                        
                        try! model.createOrUpdate()
                        
                        return FeaturedViewModel(model: model)
                    }
                    
                    let ids = viewModels.map { $0.id }
                    let realm = try! Realm()
                    let objects = realm.objects(Featured.self).filter(NSPredicate(format: "NOT id IN %@", ids))
                    
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
