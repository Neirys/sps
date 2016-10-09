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
    func synchronize() -> Observable<Void>
}

class ProposalsStatusSynchronizer: ProposalsStatusSynchronizerType {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let proposalsStatusService: ProposalsStatusServiceType
    
    // MARK: Initializers
    
    init(proposalsStatusService: ProposalsStatusServiceType) {
        self.proposalsStatusService = proposalsStatusService
    }
    
    func synchronize() -> Observable<Void> {
        return proposalsStatusService.request()
            .subscribeOn(ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global()))
            .map { proposals -> [ProposalChange] in
                let realm = try! Realm()
                realm.refresh()
                let proposalsInDB = realm.objects(Proposal.RealmObject.self).toArray()
                let diffs = differential(from: proposalsInDB, to: proposals)

                return diffs
            }
            .do(onNext: { changes in
                let realm = try! Realm()
                realm.refresh()
                
                try! realm.write {
                    let addsOrUpdates = changes.filter { $0.addOrUpdate }.map { RealmProposal(proposal: $0.proposal) }
                    realm.add(addsOrUpdates, update: true)
                    
                    let deleteIds = changes.filter { $0.delete }.map { $0.proposal.id }
                    let predicate = NSPredicate(format: "id IN %@", deleteIds)
                    let toDelete = realm.objects(Proposal.RealmObject.self).filter(predicate)
                    realm.delete(toDelete)
                }
            })
            .map { _ in return }
            .debug()
    }
}

#if DEBUG
    class PeriodicProposalsStatusSynchronizer: ProposalsStatusSynchronizerType {
        let synchronizer : ProposalsStatusSynchronizerType
        let period: RxTimeInterval
        
        init(synchronizer: ProposalsStatusSynchronizerType, period: RxTimeInterval) {
            self.synchronizer = synchronizer
            self.period = period
        }
        
        func synchronize() -> Observable<Void> {
            return Observable<Int>.interval(period, scheduler: ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global()))
                .startWith(0)
                .flatMapLatest { _ in return self.synchronizer.synchronize() }
        }
    }
#endif
