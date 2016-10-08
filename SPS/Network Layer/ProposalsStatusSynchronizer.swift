//
//  ProposalsStatusSynchronizer.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 05/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

protocol ProposalsStatusSynchronizerType {
    func synchronize() -> Observable<[Proposal]>
}

class ProposalsStatusSynchronizer: ProposalsStatusSynchronizerType {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let proposalsStatusService: ProposalsStatusServiceType
    
    // MARK: Initializers
    
    init(proposalsStatusService: ProposalsStatusServiceType) {
        self.proposalsStatusService = proposalsStatusService
    }
    
    func synchronize() -> Observable<[Proposal]> {
        return proposalsStatusService.request()
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global()))
            .do(onNext: { proposals in
                let realm = try! Realm()
                try! realm.write {
                    realm.add(proposals, update: true)
                }
            })
            .debug()
    }
}
