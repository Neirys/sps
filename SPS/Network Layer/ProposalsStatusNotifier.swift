//
//  ProposalsStatusNotifier.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 11/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import UserNotifications
import RxSwift

protocol ProposalsStatusNotifierType {
    func notify(with changes: [ProposalChange])
}

class ProposalsStatusNotifier: ProposalsStatusNotifierType {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let currentNotificationIdentifier = "currentNotificationIdentifier"
    
    // MARK: Methods
    
    func notify(with changes: [ProposalChange]) {
        guard !changes.isEmpty else { return }
        
        let content: UNMutableNotificationContent = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default()
        
        if changes.count == 1 {
            let change = changes.first!
            let viewModel = ProposalChangeViewModel(change: change, createdAt: Date(), isNew: false) // date & isNew is not important here
            content.title = viewModel.id
            content.body = viewModel.changeDescription
            content.userInfo = ProposalStatusNotificationType.solo(proposalID: change.proposal.id).userInfo
        } else {
            content.body = "\(changes.count) new updates"
            content.userInfo = ProposalStatusNotificationType.multiple.userInfo
        }
        
        let request = UNNotificationRequest(identifier: Date().description, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request: request)
            .subscribe()
            .addDisposableTo(disposeBag)
    }
}

enum ProposalStatusNotificationType {
    case solo(proposalID: String)
    case multiple
    case unknown
    
    init?(userInfo: [AnyHashable: Any]) {
        guard let type = userInfo["type"] as? String else { self = .unknown; return }
        
        switch type {
        case "solo":
            guard let proposalID = userInfo["proposalID"] as? String else { self = .unknown; return }
            self = .solo(proposalID: proposalID)
        case "multiple":
            self = .multiple
        default:
            self = .unknown
        }
    }
    
    var userInfo: [AnyHashable: Any] {
        switch self {
        case .solo(let proposalID):
            return ["type": "solo", "proposalID": proposalID]
        case .multiple:
            return ["type": "multiple"]
        case .unknown:
            return [:]
        }
    }
}

extension UNNotificationContent {
    var proposalStatusNotificationType: ProposalStatusNotificationType? {
        return ProposalStatusNotificationType(userInfo: userInfo)
    }
}
