//
//  RealmObjectConvertible.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 05/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import RealmSwift

protocol RealmObjectConvertible {
    associatedtype RealmObject: Object
    
    func makeRealmObject() -> RealmObject
}

extension Realm {
    func add<R: RealmObjectConvertible>(_ object: R, update: Bool = false) {
        let realmObject = object.makeRealmObject()
        self.add(realmObject, update: update)
    }
    
    func add<S: Sequence>(_ objects: S, update: Bool = false) where S.Iterator.Element: RealmObjectConvertible {
        let realmObjets = objects.map { $0.makeRealmObject() }
        self.add(realmObjets, update: update)
    }
}
