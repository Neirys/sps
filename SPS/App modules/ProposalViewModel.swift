//
//  ProposalViewModel.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 08/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation

class ProposalViewModel: ProposalDetailType {
    
    // MARK: Properties
    
    private let proposal: ProposalType
    
    // MARK: Initializers
    
    init(_ proposal: ProposalType) {
        // avoiding some weird stuff when passing Realm object (object inconsistency)
        self.proposal = Proposal(proposal)
    }
    
    // MARK: Computed properties
    
    var id: String {
        return proposal.id
    }
    
    var name: String {
        return proposal.name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    var url: URL {
        // TODO: export to Constants file
        return URL(string: "https://github.com/apple/swift-evolution/blob/master/proposals/\(proposal.filename)")!
    }
    
    var cartBackgroundColor: RGB {
        return proposal.status.backgroundColor
    }
    
    var cartTextColor: RGB {
        return proposal.status.textColor
    }
}
