//
//  ApplicationController.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 08/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit
import RxSwift
import Fabric
import Crashlytics
import UserNotifications

protocol ApplicationControllerType: UISplitViewControllerDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    func applicationDidBecomeActive(_ application: UIApplication)
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
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
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        // TODO: move to constants file
        let interval: TimeInterval
        #if DEBUG
        interval = UIApplicationBackgroundFetchIntervalMinimum
        #else
        interval = 60 * 60 * 2
        #endif
        
        application.setMinimumBackgroundFetchInterval(interval)
        
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        
        // FIXME: TO REMOVE
        #if DEBUG
            print(UserDefaults.standard.object(forKey: "background_refresh_last_updates"))
        #endif
        
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge])
            .subscribe()
            .addDisposableTo(disposeBag)
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        let (observableFactory, _) = proposalsStatusSynchronizer.synchronize()
        observableFactory().subscribe()
            .addDisposableTo(disposeBag)
    }
    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // FIXME: TO REMOVE
        #if DEBUG
            var lastUpdates = (UserDefaults.standard.object(forKey: "background_refresh_last_updates") as? [Date]) ?? []
            lastUpdates.append(Date())
            UserDefaults.standard.set(lastUpdates, forKey: "background_refresh_last_updates")
        #endif
        
        let (factory, _) = proposalsStatusSynchronizer.synchronize()
        let observable = factory()
        observable.subscribe(
            onNext: { _ in
                completionHandler(.newData)
            },
            onError: { error in
                completionHandler(.failed)
            }
        )
        .addDisposableTo(disposeBag)
    }
}

extension ApplicationController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Notification center did receive response \(response)")
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Notification center will present notification \(notification)")
        completionHandler([.alert, .badge, .sound])
    }
}
