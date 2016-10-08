//
//  ProposalViewModel.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 08/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation

class ProposalViewModel {
    
    // MARK: Properties
    
    private let proposal: ProposalType
    
    // MARK: Initializers
    
    init(_ proposal: ProposalType) {
        self.proposal = proposal
    }
    
    // MARK: Computed properties
    
    var id: String {
        return "SE-\(proposal.id)"
    }
    
    var name: String {
        return proposal.name
    }
    
    var url: URL {
        return URL(string: "https://github.com/apple/swift-evolution/blob/master/proposals/\(proposal.filename)")!
    }
}
