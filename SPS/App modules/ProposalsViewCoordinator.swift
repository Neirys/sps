//
//  ProposalsViewCoordinator.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 08/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa

class ProposalsViewCoordinator {
    
    // MARK: Properties

    // outputs
    let proposals: Driver<[ProposalViewModel]>
    
    // MARK: Initializers
    
    init(realm: Realm) {
        let results = realm.objects(Proposal.RealmObject.self)
        self.proposals = Observable.arrayFrom(results)
            .map { $0.map(ProposalViewModel.init) }
            .asDriver(onErrorJustReturn: [])
    }
}
