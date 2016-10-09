//
//  Proposal+Realm.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 05/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import RealmSwift

class RealmProposal: Object, ProposalType {
    dynamic var id: String = ""
    dynamic var rawStatus: String = ""
    dynamic var swiftVersion: String? = nil
    dynamic var name: String = ""
    dynamic var filename: String = ""
    
    convenience init(id: String, rawStatus: String, swiftVersion: String?, name: String, filename: String) {
        self.init()
        self.id = id
        self.rawStatus = rawStatus
        self.swiftVersion = swiftVersion
        self.name = name
        self.filename = filename
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

extension RealmProposal {
    var status: Proposal.Status {
        return Proposal.Status(rawValue: rawStatus) ?? .unknown
    }
}

extension RealmProposal {
    convenience init(proposal: ProposalType) {
        self.init(
            id: proposal.id,
            rawStatus: proposal.status.rawValue,
            swiftVersion: proposal.swiftVersion,
            name: proposal.name,
            filename: proposal.filename
        )
    }
}

extension Proposal: RealmObjectConvertible {
    typealias RealmObject = RealmProposal
    
    func makeRealmObject() -> RealmProposal {
        return RealmProposal(proposal: self)
    }
}
