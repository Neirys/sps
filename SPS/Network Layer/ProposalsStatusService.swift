//
//  ProposalsStatusService.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 05/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProposalsStatusServiceType {
    func request() -> Observable<[Proposal]>
}

class ProposalsStatusService: ProposalsStatusServiceType {
    
    // MARK: Properties
    
    private let session: URLSession
    
    // MARK: Initializers
    
    init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: Public methods
    
    func request() -> Observable<[Proposal]> {
        let url = URL(string: "https://data.swift.org/swift-evolution/proposals")!
        let request = URLRequest(url: url)
        
        return session.rx.data(request: request)
            .map { data in
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                let proposals: [Proposal] = (json as? [Any])?.flatMap { try? Proposal.deserialize($0) } ?? []
                return proposals
            }
    }
}

#if DEBUG
    class RandomProposalsStatusService: ProposalsStatusServiceType {
        
        private let proposals: [[Proposal]] = {
            let p1: [Proposal] = [
                Proposal(id: "001", status: .accepted, swiftVersion: nil, name: "001", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "002", status: .implemented, swiftVersion: "4.0", name: "002", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "003", status: .implemented, swiftVersion: "3.0", name: "003", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "004", status: .implemented, swiftVersion: "3.0", name: "004", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "005", status: .rejected, swiftVersion: nil, name: "005", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "006", status: .active, swiftVersion: nil, name: "006", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "007", status: .active, swiftVersion: nil, name: "007", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "008", status: .active, swiftVersion: nil, name: "008", filename: "0001-keywords-as-argument-labels.md")
            ]
            
            let p2: [Proposal] = [
                Proposal(id: "001", status: .accepted, swiftVersion: nil, name: "001", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "002", status: .implemented, swiftVersion: "4.0", name: "002", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "003", status: .implemented, swiftVersion: "3.0", name: "003", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "004", status: .implemented, swiftVersion: "3.0", name: "004", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "005", status: .rejected, swiftVersion: nil, name: "005", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "006", status: .active, swiftVersion: nil, name: "006", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "007", status: .active, swiftVersion: nil, name: "007", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "008", status: .accepted, swiftVersion: "4.0", name: "008", filename: "0001-keywords-as-argument-labels.md")
            ]
            
            let p3: [Proposal] = [
                Proposal(id: "001", status: .implemented, swiftVersion: "3.1", name: "001", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "002", status: .implemented, swiftVersion: "4.0", name: "002", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "003", status: .implemented, swiftVersion: "3.0", name: "003", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "004", status: .implemented, swiftVersion: "3.0", name: "004", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "005", status: .rejected, swiftVersion: nil, name: "005", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "006", status: .deferred, swiftVersion: nil, name: "006", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "007", status: .rejected, swiftVersion: nil, name: "007", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "008", status: .accepted, swiftVersion: "4.0", name: "008", filename: "0001-keywords-as-argument-labels.md"),
                Proposal(id: "009", status: .active, swiftVersion: nil, name: "009", filename: "0001-keywords-as-argument-labels.md")
            ]
            
            return [p1, p2, p3]
        }()
        
        func request() -> Observable<[Proposal]> {
            let index = Int(arc4random() % 3)
            let proposals = self.proposals[index]
            return Observable.just(proposals)
        }
    }
#endif
