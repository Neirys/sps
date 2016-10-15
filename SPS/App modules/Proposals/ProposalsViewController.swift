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
    private var refreshControl: UIRefreshControl!
    @IBOutlet private weak var emptyLabel: UILabel!
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private var viewCoordinator: ProposalsViewCoordinator!
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Proposal Status"
        
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSection<ProposalViewModel>>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, proposal in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProposalCellID", for: indexPath) as! ProposalsTableViewCell
            cell.configure(with: proposal)
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
                // FIXME: I'm not OK with passing model through `sender`
                self.performSegue(withIdentifier: "ProposalDetailSegueID", sender: proposal)
            })
            .addDisposableTo(disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.tableView.deselectRow(at: indexPath, animated: true)
            })
            .addDisposableTo(disposeBag)
        
        viewCoordinator.isEmpty
            .map { !$0 }
            .drive(emptyLabel.rx.hidden)
            .addDisposableTo(disposeBag)
    }
    
    // Man, the following code looks weird ... time to get ride off storyboards ?
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProposalDetailSegueID",
            let navigationController = segue.destination as? UINavigationController,
            let proposalDetailViewController = navigationController.topViewController as? ProposalDetailViewController,
            let proposal = sender as? ProposalDetailType {
            
            proposalDetailViewController.proposal = proposal
        }
        else if segue.identifier == "ProposalsHistorySegueID",
            let navigationController = segue.destination as? UINavigationController,
            let proposalsHistoryViewController = navigationController.topViewController as? ProposalsHistoryViewController {
            
            proposalsHistoryViewController.selectionHandler = { [weak self] change in
                guard let strongSelf = self else { return }
                strongSelf.performSegue(withIdentifier: "ProposalDetailSegueID", sender: change)
            }
        }
    }
    
    // WARNING: should be called before viewDidLoad, crash otherwise
    func inject(proposalsStatusSynchronizer: ProposalsStatusSynchronizerType) {
        viewCoordinator = ProposalsViewCoordinator(realm: try! Realm(), proposalsStatusSynchronizer: proposalsStatusSynchronizer)
    }
    
    // MARK: Methods
    
    private dynamic func refresh() {
        let (observableFactory, activity) = viewCoordinator.synchronize()
        
        observableFactory()
            .subscribe()
            .addDisposableTo(disposeBag)
        
        activity
            .drive(refreshControl.rx.refreshing)
            .addDisposableTo(disposeBag)
    }
}

extension ProposalsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
