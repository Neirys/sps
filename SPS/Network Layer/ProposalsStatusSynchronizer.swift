//
//  ProposalsStatusSynchronizer.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 05/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation

class ProposalsStatusSynchronizer {
    
    // MARK: Properties
    
    private let proposalsStatusService: ProposalsStatusService
    
    // MARK: Initializers
    
    init(proposalsStatusService: ProposalsStatusService) {
        self.proposalsStatusService = proposalsStatusService
    }
}
