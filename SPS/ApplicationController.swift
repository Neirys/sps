//
//  ApplicationController.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 08/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit
import RxSwift

protocol ApplicationControllerType: UISplitViewControllerDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    func applicationDidBecomeActive(_ application: UIApplication)
}

class ApplicationController: NSObject, ApplicationControllerType {
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let splitViewController: UISplitViewController
    private let proposalsStatusSynchronizer: ProposalsStatusSynchronizerType
    
    // MARK: Initializers
    
    init(splitViewController: UISplitViewController, proposalsStatusSynchronizer: ProposalsStatusSynchronizerType) {
        self.splitViewController = splitViewController
        self.proposalsStatusSynchronizer = proposalsStatusSynchronizer
        
        super.init()
        
        self.splitViewController.delegate = self
        
        // TODO: find a better / safer way that injection
        let masterViewController = (splitViewController.viewControllers[0] as! UINavigationController).topViewController as! ProposalsViewController
        masterViewController.inject(proposalsStatusSynchronizer: proposalsStatusSynchronizer)
    }
    
    convenience init(splitViewController: UISplitViewController, proposalsStatusService: ProposalsStatusServiceType) {
        self.init(splitViewController: splitViewController,
                  proposalsStatusSynchronizer: ProposalsStatusSynchronizer(proposalsStatusService: proposalsStatusService))
    }
    
    // MARK: ApplicationControllerType conformance
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let (observableFactory, _) = proposalsStatusSynchronizer.synchronize()
        observableFactory().subscribe()
            .addDisposableTo(disposeBag)
    }
}
