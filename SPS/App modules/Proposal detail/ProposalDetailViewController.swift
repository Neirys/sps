//
//  ProposalDetailViewController.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 08/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit

// TODO: Create another file just for this one ?
protocol ProposalDetailType {
    var id: String { get }
    var url: URL { get }
}

class ProposalDetailViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet private weak var webView: UIWebView!
    @IBOutlet fileprivate weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: Properties
    
    var proposal: ProposalDetailType?
    
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
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return proposal?.url == request.url
    }
}
