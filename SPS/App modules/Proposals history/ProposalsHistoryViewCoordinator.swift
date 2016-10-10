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

// TODO: Unit tests
class ProposalsHistoryViewCoordinator {
    
    // MARK: Properties
    
    // outputs
    let history: Driver<[AnimatableSection<ProposalChangeViewModel>]>
    
    // MARK: Initializers
    
    init(realm: Realm) {
        let history = realm.objects(RealmProposalChange.self).sorted(byProperty: "createdAt", ascending: false)
        
        self.history = Observable.arrayFrom(history)
            .map { $0.map { ProposalChangeViewModel(change: $0.change, createdAt: $0.createdAt as Date) } }
            .map { [AnimatableSection(title: "History", elements: $0)] }
            .asDriver(onErrorJustReturn: [])
    }
}
