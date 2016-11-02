//
//  ProposalChangeViewModel.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 10/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation

class ProposalChangeViewModel: ProposalDetailType {
    
    // MARK: Properties
    
    private let change: ProposalChange
    let createdAt: Date
    private let isNew: Bool
    private let dateFormatter: DateFormatter
    
    // MARK: Initializers
    
    init(change: ProposalChange, createdAt: Date, isNew: Bool, locale: Locale = Locale.current) {
        self.change = change
        self.createdAt = createdAt
        self.isNew = isNew
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyMMMd", options: 0, locale: locale)
    }
    
    // MARK: Computed properties
    
    var id: String {
        return "SE-\(change.proposal.id)"
    }
    
    var name: String {
        return change.proposal.name
    }
    
    var url: URL {
        // TODO: export to Constants file
        return URL(string: "https://github.com/apple/swift-evolution/blob/master/proposals/\(change.proposal.filename)")!
    }
    
    var cartBackgroundColor: RGB {
        return change.proposal.status.backgroundColor
    }
    
    var cartTextColor: RGB {
        return change.proposal.status.textColor
    }
    
    var changeDescription: String {
        switch change {
        case .add:
            return "Added to \(change.proposal.status.displayName)"
        case .delete:
            return "Deleted"
        case .update(_, let fromStatus, let toStatus):
            return "Updated from \(fromStatus.displayName) to \(toStatus.displayName)"
        case .unknown:
            return "Unknown"
        }
    }
    
    var changeDate: String {
        return dateFormatter.string(from: createdAt)
    }
    
    var cellBackgroundColor: RGB {
        return isNew ? RGB(66, 179, 244, 10) : RGB.white()
    }
}
