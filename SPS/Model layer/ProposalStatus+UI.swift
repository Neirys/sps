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
        case .accepted:     return 40
        case .active:       return 10
        case .awaiting:     return 30
        case .deferred:     return 60
        case .implemented:  return 50
        case .implementing: return 35
        case .rejected:     return 80
        case .returned:     return 70
        case .scheduled:    return 20
        case .withdrawn:    return 90
        case .unknown:      return 100
        }
    }
    
    var displayName: String {
        switch self {
        case .accepted:     return "Accepted (awaiting implementation)"
        case .active:       return "Active reviews"
        case .awaiting:     return "Proposals awaiting scheduling"
        case .deferred:     return "Deferred for future discussion"
        case .implemented:  return "Implemented"
        case .implementing: return "Implementation in progress"
        case .rejected:     return "Rejected"
        case .returned:     return "Returned for revision"
        case .scheduled:    return "Upcoming reviews"
        case .unknown:      return "Unknown status"
        case .withdrawn:    return "Withdrawn"
        }
    }
    
    var backgroundColor: RGB {
        switch self {
        case .active:       return RGB(41, 125, 228)
        case .accepted:     return RGB(90, 188, 78)
        case .implemented:  return RGB(49, 144, 33)
        case .implementing: return RGB(90, 188, 78)
        case .deferred:     return RGB(221, 221, 221)
        case .rejected:     return RGB(222, 91, 96)
        case .withdrawn:    return RGB(222, 91, 96)
        case .awaiting:     return RGB(221, 221, 221)
        case .scheduled:    return RGB(120, 184, 251)
        case .returned:     return RGB(241, 182, 183)
        case .unknown:      return RGB(221, 221, 221)
        }
    }
    
    var textColor: RGB {
        switch self {
        case .deferred, .awaiting:
            return RGB(0, 0, 0)
        default:
            return RGB(255, 255, 255)
        }
    }
}
