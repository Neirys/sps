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

class ProposalsStatusSynchronizer {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let proposalsStatusService: ProposalsStatusService
    
    // MARK: Initializers
    
    init(proposalsStatusService: ProposalsStatusService) {
        self.proposalsStatusService = proposalsStatusService
    }
    
    func synchronize() {
        proposalsStatusService.request()
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global()))
            .subscribe(Realm.add(update: true))
            .addDisposableTo(disposeBag)
    }
}
