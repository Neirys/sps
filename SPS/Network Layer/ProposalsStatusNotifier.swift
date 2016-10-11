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
            let viewModel = ProposalChangeViewModel(change: changes.first!, createdAt: Date()) // date is not important here
            content.title = viewModel.id
            content.body = viewModel.changeDescription
        } else {
            content.body = "\(changes.count) new updates"
        }
        
        let request = UNNotificationRequest(identifier: currentNotificationIdentifier, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request: request)
            .subscribe()
            .addDisposableTo(disposeBag)
    }
}
