//
//  ProposalDetailViewController.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 08/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit

class ProposalDetailViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var webView: UIWebView!
    
    // MARK: Properties
    
    var proposal: ProposalViewModel?
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let proposal = proposal else { return }
        webView.loadRequest(URLRequest(url: proposal.url))
    }
}
