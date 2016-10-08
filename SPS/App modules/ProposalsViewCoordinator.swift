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
    let proposalSections: Driver<[Section<ProposalViewModel>]>
    
    // MARK: Initializers
    
    init(realm: Realm) {
        let results = realm.objects(Proposal.RealmObject.self)
        self.proposals = Observable.arrayFrom(results)
            .map { $0.map(ProposalViewModel.init) }
            .asDriver(onErrorJustReturn: [])
        
        self.proposalSections = Observable.arrayFrom(results)
            // separate proposals by status
            .map { proposals -> [ProposalStatusVersion: [ProposalType]] in
                let dic = proposals.reduce([:]) { (dic, proposal) -> [ProposalStatusVersion: [ProposalType]] in
                    let proposalStatusVersion = ProposalStatusVersion(status: proposal.status, swiftVersion: proposal.swiftVersion)
                    var dic = dic
                    var proposals = dic[proposalStatusVersion] ?? []
                    proposals.append(proposal)
                    dic[proposalStatusVersion] = proposals
                    
                    return dic
                }
                
                return dic
            }
            // apply a custom display order
            .map { proposals in
                return proposals.sorted() { p1, p2 in
                    var ordered = p1.key.status.displayOrder < p2.key.status.displayOrder
                    if let s1 = p1.key.swiftVersion, let s2 = p2.key.swiftVersion {
                        ordered = ordered || (!ordered && s1 > s2)
                    }
                    
                    return ordered
                }
            }
            // transform them to minimal data for our table view
            .map { proposals -> [Section<ProposalViewModel>] in
                return proposals.map { proposal in
                    let version = proposal.key.swiftVersion != nil ? " (Swift \(proposal.key.swiftVersion!))"  : ""
                    let title = proposal.key.status.displayName + version
                    let proposalViewModels = proposal.value.map { ProposalViewModel($0) }
                    return Section(title: title, elements: proposalViewModels)
                }
            }
            .asDriver(onErrorJustReturn: [])
    }
}

fileprivate struct ProposalStatusVersion: Hashable {
    let status: Proposal.Status
    let swiftVersion: String?
    
    var hashValue: Int {
        var hashValue = status.rawValue.hashValue
        
        if let swiftVersion = swiftVersion {
            hashValue = hashValue ^ swiftVersion.hashValue
        }
        
        return hashValue
    }
    
    static func == (lhs: ProposalStatusVersion, rhs: ProposalStatusVersion) -> Bool {
        return lhs.status == rhs.status && lhs.swiftVersion == rhs.swiftVersion
    }
}
