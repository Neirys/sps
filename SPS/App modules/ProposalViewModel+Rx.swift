//
//  ProposalViewModel+Rx.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 08/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import RxDataSources

extension ProposalViewModel: IdentifiableType, Equatable {
    var identity: String {
        return id
    }
    
    static func == (lhs: ProposalViewModel, rhs: ProposalViewModel) -> Bool {
        return lhs.id == rhs.id
    }
}
