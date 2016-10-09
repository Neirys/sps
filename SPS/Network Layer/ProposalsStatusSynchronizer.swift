//
//  ProposalsStatusSynchronizer.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 05/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift

protocol ProposalsStatusSynchronizerType {
    func synchronize() -> (observableFactory: () -> Observable<Void>, activity: Driver<Bool>)
}

class ProposalsStatusSynchronizer: ProposalsStatusSynchronizerType {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let proposalsStatusService: ProposalsStatusServiceType
    
    // MARK: Initializers
    
    init(proposalsStatusService: ProposalsStatusServiceType = ProposalsStatusService()) {
        self.proposalsStatusService = proposalsStatusService
    }
    
    func synchronize() -> (observableFactory: () -> Observable<Void>, activity: Driver<Bool>) {
        let activity = ActivityIndicator()
        let activityDriver: Driver<Bool> = activity.asDriver()
        
        let observableFactory = {
            return self.proposalsStatusService.request()
                .subscribeOn(ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global()))
                .map { proposals -> [ProposalChange] in
                    let realm = try! Realm()
                    realm.refresh()
                    let proposalsInDB = realm.objects(Proposal.RealmObject.self).toArray()
                    let diffs = differential(from: proposalsInDB, to: proposals)

                    return diffs
                }
                .flatMapLatest { changes in
                    return Realm.write { realm in
                        let realmChanges = changes.map { RealmProposalChange($0) }
                        realm.add(realmChanges)

                        let addsOrUpdates = changes.filter { $0.addOrUpdate }.map { RealmProposal(proposal: $0.proposal) }
                        realm.add(addsOrUpdates, update: true)

                        let deleteIds = changes.filter { $0.delete }.map { $0.proposal.id }
                        let predicate = NSPredicate(format: "id IN %@", deleteIds)
                        let toDelete = realm.objects(Proposal.RealmObject.self).filter(predicate)
                        realm.delete(toDelete)
                    }
                }
                .trackActivity(activity)
                .debug()
        }
        
        return (observableFactory, activityDriver)
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
        
        func synchronize() -> (observableFactory: () -> Observable<Void>, activity: Driver<Bool>) {
            let (observableFactory, activity) = self.synchronizer.synchronize()
            let periodicObservable = {
                return Observable<Int>.interval(self.period, scheduler: ConcurrentDispatchQueueScheduler.init(queue: DispatchQueue.global()))
                .startWith(0)
                .flatMapLatest { _ in return observableFactory() }
            }
            
            return (periodicObservable, activity)
        }
    }
#endif
