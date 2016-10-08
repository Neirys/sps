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
