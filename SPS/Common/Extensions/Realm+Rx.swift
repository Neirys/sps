//
//  Realm+Rx.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 08/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

class RealmObserver<E>: ObserverType {
    
    // MARK: Properties
    
    let configuration: Realm.Configuration
    let writes: (Realm, E) -> Void
    
    // MARK: Initializers
    
    init(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration, writes: @escaping (Realm, E) -> Void) {
        self.configuration = configuration
        self.writes = writes
    }
    
    // MARK: ObserverType conformance
    
    func on(_ event: Event<E>) {
        switch event {
        case .next(let element):
            let realm = try! Realm(configuration: configuration)
            writes(realm, element)
        default:
            break
        }
    }
}

extension RealmCollection {
    func toArray() -> [Element] {
        let collection = AnyRealmCollection(self)
        return Array(collection)
    }
}

extension Observable where Element: RealmCollection {
    static func arrayFrom(_ collection: Element) -> Observable<[Element.Element]> {
        return from(collection).map { $0.toArray() }
    }
    
    static func from(_ collection: Element) -> Observable<Element> {
        return Observable<Element>.create { observer in
            let token = collection.addNotificationBlock { changes in
                switch changes {
                case .initial(let elements):
                    observer.onNext(elements)
                case .update(let elements, _, _, _):
                    observer.onNext(elements)
                case .error(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                observer.onCompleted()
                token.stop()
            }
        }
    }
    
    static func changeSetFrom(_ collection: Element) -> Observable<RealmCollectionChange<Element>> {
        return Observable<RealmCollectionChange<Element>>.create { observer in
            let token = collection.addNotificationBlock { changes in
                switch changes {
                case .initial(_):
                    observer.onNext(changes)
                case .update(_, _, _, _):
                    observer.onNext(changes)
                case .error(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create {
                observer.onCompleted()
                token.stop()
            }
        }
    }
}

extension Realm {
    static func add<O: Object>(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration,
                    update: Bool = false) -> AnyObserver<O> {
        return RealmObserver(configuration: configuration) { realm, element in
            try! realm.write {
                realm.add(element, update: update)
            }
        }.asObserver()
    }
    
    static func add<S: Sequence>(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration,
                    update: Bool = false) -> AnyObserver<S> where S.Iterator.Element: Object {
        return RealmObserver(configuration: configuration) { realm, element in
            try! realm.write {
                realm.add(element, update: update)
            }
        }.asObserver()
    }
    
    static func add<O: RealmObjectConvertible>(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration,
                    update: Bool = false) -> AnyObserver<O> {
        return RealmObserver(configuration: configuration) { realm, element in
            try! realm.write {
                realm.add(element, update: update)
            }
        }.asObserver()
    }
    
    static func add<S: Sequence>(configuration: Realm.Configuration = Realm.Configuration.defaultConfiguration,
                    update: Bool = false) -> AnyObserver<S> where S.Iterator.Element: RealmObjectConvertible {
        return RealmObserver(configuration: configuration) { realm, element in
            try! realm.write {
                realm.add(element, update: update)
            }
        }.asObserver()
    }
}
