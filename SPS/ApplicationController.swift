//
//  ApplicationController.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 08/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit

protocol ApplicationControllerType {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    func applicationDidBecomeActive(_ application: UIApplication)
}

class ApplicationController: ApplicationControllerType {
    
    // MARK: Properties
    
    let proposalsStatusSynchronizer: ProposalsStatusSynchronizer
    
    // MARK: Initializers
    
    init(proposalsStatusSynchronizer: ProposalsStatusSynchronizer) {
        self.proposalsStatusSynchronizer = proposalsStatusSynchronizer
    }
    
    init(proposalsStatusService: ProposalsStatusService) {
        self.proposalsStatusSynchronizer = ProposalsStatusSynchronizer(proposalsStatusService: proposalsStatusService)
    }
    
    // MARK: ApplicationControllerType conformance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        proposalsStatusSynchronizer.synchronize()
    }
}
