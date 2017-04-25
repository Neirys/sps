//
//  Proposal.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 04/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation

protocol ProposalType {
    var id: String { get }
    var status: Proposal.Status { get }
    var swiftVersion: String? { get }
    var name: String { get }
    var filename: String { get }
}

struct Proposal: ProposalType {
    enum Status: String {
        case implemented            = ".implemented"
        case implementing           = ".implementing"           // Do not appear anymore
        case accepted               = ".accepted"
        case acceptedWithRevision   = ".acceptedWithRevisions"
        case active                 = ".activeReview"
        case scheduled              = ".scheduled"
        case awaiting               = ".awaiting"
        case deferred               = ".deferred"
        case returned               = ".returned"
        case rejected               = ".rejected"
        case withdrawn              = ".withdrawn"
        case unknown                = ".unknown"
    }
    
    let id: String
    let status: Status
    let swiftVersion: String?
    let name: String
    let filename: String
}

extension Proposal {
    init(_ proposal: ProposalType) {
        self.init(id: proposal.id, status: proposal.status, swiftVersion: proposal.swiftVersion, name: proposal.name, filename: proposal.filename)
    }
}
