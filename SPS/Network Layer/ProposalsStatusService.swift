//
//  ProposalsStatusService.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 05/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import SWXMLHash

enum ProposalsStatusServiceError: Error {
    case underlying(Error)
    case missingData
}

protocol ProposalsStatusServiceProtocol {
    func request(completionHandler: @escaping (Result<[Proposal], ProposalsStatusServiceError>) -> Void)
}

class ProposalsStatusService: ProposalsStatusServiceProtocol {
    
    // MARK: Properties
    
    private let session: URLSession
    
    // MARK: Initializers
    
    init(configuration: URLSessionConfiguration = URLSessionConfiguration.default) {
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: Public methods
    
    func request(completionHandler: @escaping (Result<[Proposal], ProposalsStatusServiceError>) -> Void) {
        session.dataTask(with: URL(string: "https://apple.github.io/swift-evolution/")!) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(.underlying(error)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.missingData))
                return
            }
            
            do {
                let xml = SWXMLHash.parse(data)
                let proposals: [Proposal] = try xml["proposals"]["proposal"].value()
                
                completionHandler(.success(proposals))
            } catch let error {
                completionHandler(.failure(.underlying(error)))
            }
        }.resume()
    }
}
