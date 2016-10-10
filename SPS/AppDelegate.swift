//
//  AppDelegate.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 04/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit

import RealmSwift
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: Properties

    var window: UIWindow?
    
    private lazy var applicationController: ApplicationControllerType = {
        let splitViewController = self.window!.rootViewController as! UISplitViewController
        
        #if DEBUG
//            let service = RandomProposalsStatusService()
            let service = ProposalsStatusService()
            let synchronizer = ProposalsStatusSynchronizer(proposalsStatusService: service)
            let debugSynchronizer = PeriodicProposalsStatusSynchronizer(synchronizer: synchronizer, period: 10)
            
            return ApplicationController(splitViewController: splitViewController, proposalsStatusSynchronizer: synchronizer)
        #else
            return ApplicationController(splitViewController: splitViewController, proposalsStatusService: ProposalsStatusService())
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
