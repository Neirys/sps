//
//  ProposalChangeViewModel+Rx.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 10/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import RxDataSources

// FIXME: Can't be animated because 2 different changes can have the same identity
extension ProposalChangeViewModel: IdentifiableType, Equatable {
    var identity: String {
        return id
    }
    
    static func == (lhs: ProposalChangeViewModel, rhs: ProposalChangeViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
