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
import RxDataSources

class ProposalsViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let viewCoordinator = ProposalsViewCoordinator(realm: try! Realm())
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Proposal Status"
        
        let dataSource = RxTableViewSectionedReloadDataSource<Section<ProposalViewModel>>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, proposal in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProposalCellID", for: indexPath)
            cell.textLabel?.text = proposal.name
            cell.detailTextLabel?.text = proposal.id
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].title
        }
        
        viewCoordinator.proposalSections
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        
        tableView.rx.modelSelected(ProposalViewModel.self)
            .subscribe(onNext: { proposal in
                self.performSegue(withIdentifier: "ProposalDetailSegueID", sender: proposal)
            })
            .addDisposableTo(disposeBag)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController,
            let proposalDetailViewController = navigationController.topViewController as? ProposalDetailViewController,
            let proposal = sender as? ProposalViewModel else { return }
        proposalDetailViewController.proposal = proposal
    }
}
