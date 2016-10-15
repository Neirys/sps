//
//  ProposalsHistoryViewController.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 10/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources
import RealmSwift

class ProposalsHistoryViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let viewCoordinator = ProposalsHistoryViewCoordinator(realm: try! Realm())
    
    var selectionHandler: ((ProposalChangeViewModel) -> Void)?
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "History"
        
        tableView.delegate = self
        
        let dataSource = RxTableViewSectionedAnimatedDataSource<AnimatableSection<ProposalChangeViewModel>>()
        
        dataSource.configureCell = { dataSource, tableView, indexPath, proposalChange in
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProposalHistoryCellID", for: indexPath) as! ProposalHistoryTableViewCell
            cell.configure(with: proposalChange)
            return cell
        }
        
        tableView.rx.modelSelected(ProposalChangeViewModel.self)
            .subscribe(onNext: { change in
                self.dismiss(animated: true) {
                    self.selectionHandler?(change)
                }
            })
            .addDisposableTo(disposeBag)
        
        viewCoordinator.history
            .drive(tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        viewCoordinator.markAllAsRead()
    }
    
    // MARK: IBActions
    
    @IBAction private func closeButtonTouched(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProposalsHistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
