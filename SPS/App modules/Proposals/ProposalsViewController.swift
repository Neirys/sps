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
    @IBOutlet fileprivate weak var searchBar: UISearchBar!
    @IBOutlet private weak var emptyLabel: UILabel!
    private var refreshControl: UIRefreshControl!
    @IBOutlet private weak var historyBarButtonItem: UIBarButtonItem!
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    fileprivate var viewCoordinator: ProposalsViewCoordinator!
    private var proposalsStatusSynchronizer: ProposalsStatusSynchronizerType!
    fileprivate let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSection<ProposalViewModel>>()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // FIXME: I wanted to initialize `viewCoordinator` in `inject` so I can avoid having to retain `proposalsStatusSynchronizer` in the VC
        // But `inject` method is called before `viewDidLoad` and `searchBar` isn't initialized yet at that time
        // I could declare a Varible into the view coordinator then bind this variable to my search bar in `viewDidLoad` but I don't like this approach (I don't like the current one neither ..)
        viewCoordinator = ProposalsViewCoordinator(
            realm: try! Realm(),
            proposalsStatusSynchronizer: proposalsStatusSynchronizer,
            searchInput: searchBar.rx.text.asObservable()
        )

        title = "Proposal Status"
        
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        dataSource.configureCell = { dataSource, tableView, indexPath, proposal in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProposalCellID", for: indexPath) as! ProposalsTableViewCell
            cell.configure(with: proposal)
            return cell
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
            .map { !$0 } // FIXME: I don't like view controllers performing any Rx operator
            .drive(emptyLabel.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        
        viewCoordinator.hasUnreadChanges
            .drive(onNext: { hasUnreadChanges in
                let iconName = hasUnreadChanges ? "notification_plain" : "notification"
                let image = UIImage(named: iconName)
                self.historyBarButtonItem.image = image
            })
            .addDisposableTo(disposeBag)
    }
    
    // Man, the following code looks weird ... time to get ride of storyboards ?
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
        self.proposalsStatusSynchronizer = proposalsStatusSynchronizer
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let model = dataSource.sectionModels[section]
        let title = model.title.uppercased()
        
        let containerView = RxView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.darkGray
        label.text = title
        
        containerView.addSubview(label)
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[label]-15-|", options: [], metrics: nil, views: ["label": label]))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-5-|", options: [], metrics: nil, views: ["label": label]))
        
        let gesture = UITapGestureRecognizer()
        gesture.rx.event.asObservable()
            .debug()
            .map { _ in model }
            .bindTo(viewCoordinator.headerTapped)
            .addDisposableTo(containerView.disposeBag)
        
        containerView.addGestureRecognizer(gesture)
        
        return containerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let height: CGFloat = 35
        // Because Apple won't let me set a 0 height footer on a grouped table view ...
        return section == 0 ? height + tableView.sectionFooterHeight : height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
