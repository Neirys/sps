//
//  ApplicationRouter.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 11/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit

class ApplicationRouter {
    
    // MARK: Properties
    
    private let splitViewController: UISplitViewController
    
    // TODO: Safer ?
    var masterViewController: ProposalsViewController {
        return (splitViewController.viewControllers[0] as! UINavigationController).topViewController as! ProposalsViewController
    }
    
    // MARK: Initializers
    
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
    }
}
