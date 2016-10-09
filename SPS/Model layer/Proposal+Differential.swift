//
//  Proposal+Differential.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 09/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation

enum ProposalChange {
    case add(proposal: ProposalType)
    case delete(proposal: ProposalType)
    case update(proposal: ProposalType, fromStatus: Proposal.Status, toStatus: Proposal.Status)
    
    var proposal: ProposalType {
        switch self {
        case .add(let proposal):
            return proposal
        case .delete(let proposal):
            return proposal
        case .update(let proposal, _, _):
            return proposal
        }
    }
    
    var addOrUpdate: Bool {
        switch self {
        case .add, .update:
            return true
        default:
            return false
        }
    }
    
    var delete: Bool {
        switch self {
        case .delete:
            return true
        default:
            return false
        }
    }
}

// very bad differential with no optimization at all but yeah, i'm lazy
// TODO: Unit test
func differential(from proposals1: [ProposalType], to proposals2: [ProposalType]) -> [ProposalChange] {
    
    let adds = proposals2.filter { p2 in
        return !proposals1.contains { p1 in p1.id == p2.id }
    }
    .map { ProposalChange.add(proposal: $0) }
    
    let deletes = proposals1.filter { p2 in
        return !proposals2.contains { p1 in p1.id == p2.id }
    }
    .map { ProposalChange.delete(proposal: $0) }
    
    let updates = proposals2.reduce([]) { (updates, p2) -> [(p1: ProposalType, p2: ProposalType)] in
        var updates = updates
        if let p1 = proposals1.filter({ p1 in return p1.id == p2.id && p1.status != p2.status }).first {
            updates.append((p1: p1, p2: p2))
        }
        
        return updates
    }
    .map { ProposalChange.update(proposal: $0.p2, fromStatus: $0.p1.status, toStatus: $0.p2.status) }
    
    return adds + deletes + updates
}
