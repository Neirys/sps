//
//  ProposalsStatusService.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 05/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import SWXMLHash
import RxSwift
import RxCocoa

protocol ProposalsStatusServiceProtocol {
    func request() -> Observable<[Proposal]>
}

class ProposalsStatusService: ProposalsStatusServiceProtocol {
    
    // MARK: Properties
    
    private let session: URLSession
    
    // MARK: Initializers
    
    init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: Public methods
    
    func request() -> Observable<[Proposal]> {
        let url = URL(string: "https://apple.github.io/swift-evolution/")!
        let request = URLRequest(url: url)
        
        return session.rx.data(request)
            .map { data in
                let xml = SWXMLHash.parse(data)
                let proposals: [Proposal] = try xml["proposals"]["proposal"].value()
                return proposals
            }
    }
}
