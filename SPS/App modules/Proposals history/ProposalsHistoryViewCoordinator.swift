//
//  ProposalsHistoryViewCoordinator.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 10/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

class ProposalsHistoryViewCoordinator {
    
    // MARK: Properties
    
    // TODO: Is that good to inject Realm ? What if it use in another thread than the one used to create the instance (could happen if someone calls `markAllAsRead` is some background thread)
    private let realm: Realm
    
    // outputs
    let history: Driver<[AnimatableSection<ProposalChangeViewModel>]>
    
    // MARK: Initializers
    
    init(realm: Realm) {
        self.realm = realm
        let history = realm.objects(RealmProposalChange.self).sorted(byProperty: "createdAt", ascending: false)
        
        self.history = Observable.arrayFrom(history)
            .map { $0.map { ProposalChangeViewModel(change: $0.change, createdAt: ($0.createdAt as Date), isNew: $0.isNew) } }
            .map { [AnimatableSection(title: "History", elements: $0)] }
            .asDriver(onErrorJustReturn: [])
    }
    
    // MARK: Methods
    
    func markAllAsRead() {
        let unreadChanges = realm.objects(RealmProposalChange.self).filter { $0.isNew }

        try! realm.write {
            unreadChanges.forEach {
                $0.isNew = false
            }
        }
    }
}
