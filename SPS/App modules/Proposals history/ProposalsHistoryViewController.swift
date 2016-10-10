//
//  ProposalsHistoryViewController.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 10/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit

class ProposalsHistoryViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: IBActions
    
    @IBAction private func closeButtonTouched(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}
