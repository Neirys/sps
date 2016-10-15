//
//  ApplicationRouter.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 11/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit
import RealmSwift

class ApplicationRouter: NSObject {
    
    // MARK: Properties
    
    private let splitViewController: UISplitViewController
    
    // TODO: Safer ?
    var masterViewController: ProposalsViewController {
        return (splitViewController.viewControllers[0] as! UINavigationController).viewControllers.first as! ProposalsViewController
    }
    
    // MARK: Initializers
    
    init(splitViewController: UISplitViewController) {
        self.splitViewController = splitViewController
        super.init()
        self.splitViewController.delegate = self
    }
    
    // MARK: Methods
    
    func route(afterReceiving notification: ProposalStatusNotificationType) {
        switch notification {
        case .multiple, .unknown:
            masterViewController.performSegue(withIdentifier: "ProposalsHistorySegueID", sender: nil)
        case .solo(let proposalID):
            let realm = try! Realm()
            // TODO: Do we need some DataManagers to abstract these kind of call ?
            guard let proposal = realm.object(ofType: Proposal.RealmObject.self, forPrimaryKey: proposalID) else { return }
            // FIXME: Still not OK on passing proposal in sender. I should consider banning storyboard in order to avoid falling into that kind of laziness
            let proposalViewModel = ProposalViewModel(proposal)
            masterViewController.performSegue(withIdentifier: "ProposalDetailSegueID", sender: proposalViewModel)
        }
    }
}

extension ApplicationRouter: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
