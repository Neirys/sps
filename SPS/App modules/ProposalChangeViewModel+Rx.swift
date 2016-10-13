//
//  ProposalChangeViewModel+Rx.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 10/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import RxDataSources

extension ProposalChangeViewModel: IdentifiableType, Equatable {
    var identity: String {
        return "\(id)\(createdAt.timeIntervalSince1970)"
    }
    
    static func == (lhs: ProposalChangeViewModel, rhs: ProposalChangeViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
