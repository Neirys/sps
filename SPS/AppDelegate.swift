//
//  AppDelegate.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 04/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Properties

    var window: UIWindow?
    
    private let applicationController: ApplicationControllerType = {
        #if DEBUG
            let service = RandomProposalsStatusService()
            let synchronizer = ProposalsStatusSynchronizer(proposalsStatusService: service)
            let debugSynchronizer = PeriodicProposalsStatusSynchronizer(synchronizer: synchronizer, period: 2)
            
            return ApplicationController(proposalsStatusSynchronizer: debugSynchronizer)
        #else
            return ApplicationController(proposalsStatusService: ProposalsStatusService())
        #endif
    }()

    // MARK: UIApplicationDelegate conformance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        return applicationController.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        applicationController.applicationDidBecomeActive(application)
    }
}

