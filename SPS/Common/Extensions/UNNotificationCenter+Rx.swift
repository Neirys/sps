//
//  UNNotificationCenter+Rx.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 11/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import UserNotifications
import RxSwift

extension UNUserNotificationCenter {
    
    func getNotificationSettings() -> Observable<UNNotificationSettings> {
        return Observable.create { observer in
            self.getNotificationSettings { (settings) in
                observer.onNext(settings)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
    func requestAuthorization(options: UNAuthorizationOptions) -> Observable<Bool> {
        return Observable.create { observer in
            self.requestAuthorization(options: options) { success, error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(success)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
}
