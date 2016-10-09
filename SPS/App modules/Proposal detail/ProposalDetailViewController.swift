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
    @IBOutlet fileprivate weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Properties
    
    var proposal: ProposalViewModel?
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let proposal = proposal else { return }

        title = proposal.id
        
        webView.delegate = self
        webView.loadRequest(URLRequest(url: proposal.url))
    }
}

extension ProposalDetailViewController: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicatorView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicatorView.stopAnimating()
    }
}
