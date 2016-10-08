//
//  ProposalsViewController.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 08/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit
import RealmSwift
import RxSwift

class ProposalsViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let viewCoordinator = ProposalsViewCoordinator(realm: try! Realm())
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewCoordinator.proposals
            .drive(tableView.rx.items(cellIdentifier: "ProposalCellID")) { index, proposal, cell in
                cell.textLabel?.text = proposal.name
                cell.detailTextLabel?.text = proposal.id
            }
            .addDisposableTo(disposeBag)
    }
}
