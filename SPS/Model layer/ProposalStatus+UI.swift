//
//  ProposalStatus+UI.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 08/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation

extension Proposal.Status {
    var displayOrder: Int {
        switch self {
        case .accepted: return 4
        case .active: return 1
        case .awaiting: return 3
        case .deferred: return 6
        case .implemented: return 5
        case .rejected: return 8
        case .returned: return 7
        case .scheduled: return 2
        case .withdrawn: return 9
        case .unknown: return 10
        }
    }
    
    var displayName: String {
        switch self {
        case .accepted:     return "Accepted (awaiting implementation)"
        case .active:       return "Active reviews"
        case .awaiting:     return "Proposals awaiting scheduling"
        case .deferred:     return "Deferred for future discussion"
        case .implemented:  return "Implemented"
        case .rejected:     return "Rejected"
        case .returned:     return "Returned for revision"
        case .scheduled:    return "Upcoming reviews"
        case .unknown:      return "Unknown status"
        case .withdrawn:    return "Withdrawn"
        }
    }
}
