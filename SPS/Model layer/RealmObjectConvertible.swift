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

extension Sequence where Self.Iterator.Element: RealmObjectConvertible {
    func add(inRealm realm: Realm, update: Bool) -> () -> Void {
        return {
            let realmObjects = self.map { $0.makeRealmObject() }
            realm.add(realmObjects, update: update)
        }
    }
}
