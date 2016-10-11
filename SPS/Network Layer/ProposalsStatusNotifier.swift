//
//  ProposalsStatusNotifier.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 11/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import UserNotifications

protocol ProposalsStatusNotifierType {
    func notify(with changes: [ProposalChange])
}

class ProposalsStatusNotifier: ProposalsStatusNotifierType {
    
    func notify(with changes: [ProposalChange]) {
        let notifications = changes.map { change -> UNNotificationRequest in
            let content = UNMutableNotificationContent()
            let viewModel = ProposalChangeViewModel(change: change, createdAt: Date()) // date is not important here
            content.title = viewModel.id
            content.body = viewModel.changeDescription
            content.sound = UNNotificationSound.default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
            let request = UNNotificationRequest(identifier: viewModel.id, content: content, trigger: trigger)
            
            return request
        }
        
        notifications.forEach { request in
            UNUserNotificationCenter.current().add(request) { error in
                print("Request notification \(request.identifier) finish with error \(error)")
            }
        }
    }
}
