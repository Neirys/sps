//
//  ProposalChange.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 10/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import RealmSwift

class RealmProposalChange: Object, ProposalType {
    enum ChangeType: String {
        case add
        case delete
        case update
        case unknown
    }
    
    dynamic var id: String = ""
    dynamic var name: String = ""
    dynamic var rawStatus: Proposal.Status.RawValue = ""
    dynamic var swiftVersion: String? = nil
    dynamic var filename: String = ""
    
    dynamic var rawChangeType: String = ""
    dynamic var rawFromStatus: Proposal.Status.RawValue? = nil
    dynamic var rawToStatus: Proposal.Status.RawValue? = nil
    
    dynamic var isNew: Bool = true
    dynamic var createdAt: NSDate = NSDate()
    
    convenience init(proposal: ProposalType,
                     changeType: ChangeType, fromStatus: Proposal.Status?, toStatus: Proposal.Status?) {
        self.init()
        self.id = proposal.id
        self.name = proposal.name
        self.rawStatus = proposal.status.rawValue
        self.swiftVersion = proposal.swiftVersion
        self.filename = proposal.filename
        
        self.rawChangeType = changeType.rawValue
        self.rawFromStatus = fromStatus?.rawValue
        self.rawToStatus = toStatus?.rawValue
    }
}

extension RealmProposalChange {
    var changeType: ChangeType {
        return ChangeType(rawValue: rawChangeType) ?? .unknown
    }
    
    var status: Proposal.Status {
        return Proposal.Status(rawValue: rawStatus) ?? .unknown
    }
    
    var fromStatus: Proposal.Status {
        guard let rawFromStatus = rawFromStatus else { return .unknown }
        return Proposal.Status(rawValue: rawFromStatus) ?? .unknown
    }
    
    var toStatus: Proposal.Status {
        guard let rawToStatus = rawToStatus else { return .unknown }
        return Proposal.Status(rawValue: rawToStatus) ?? .unknown
    }
}

extension RealmProposalChange {
    convenience init(_ change: ProposalChange) {
        switch change {
        case .add(let proposal):
            self.init(proposal: proposal, changeType: .add, fromStatus: nil, toStatus: nil)
        case .delete(let proposal):
            self.init(proposal: proposal, changeType: .delete, fromStatus: nil, toStatus: nil)
        case .update(let proposal, let fromStatus, let toStatus):
            self.init(proposal: proposal, changeType: .update, fromStatus: fromStatus, toStatus: toStatus)
        case .unknown(let proposal):
            self.init(proposal: proposal, changeType: .unknown, fromStatus: nil, toStatus: nil)
        }
    }
    
    var change: ProposalChange {
        switch changeType {
        case .add:
            return .add(proposal: Proposal(self))
        case .delete:
            return .delete(proposal: Proposal(self))
        case .update:
            return .update(proposal: Proposal(self), fromStatus: fromStatus, toStatus: toStatus)
        default:
            return .unknown(proposal: Proposal(self))
        }
    }
}
