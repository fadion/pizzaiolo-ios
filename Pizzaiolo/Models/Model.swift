//
//  Model.swift
//  Pizzaiolo
//
//  Created by Fadion Dashi on 03/03/17.
//  Copyright © 2017 Fadion Dashi. All rights reserved.
//

import RealmSwift

protocol Model {
    
    var id: Int { get set }
    
}

extension Model {
    
    func createOrUpdate() throws {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(self as! Object, update: true)
            }
        }
        catch let error {
            throw error
        }
    }
    
    func update(fields: [String: Any?]) throws {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.create(Self.self as! Object.Type, value: fields.merge(with: ["id": self.id]), update: true)
            }
        }
        catch let error {
            throw error
        }
    }
    
    func create() throws {
        do {
            let realm = try Realm()
            
            try realm.write {
                realm.add(self as! Object)
            }
        }
        catch let error {
            throw error
        }
    }
    
}
