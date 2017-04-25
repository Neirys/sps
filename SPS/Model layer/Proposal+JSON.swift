//
//  Proposal+SWXMLHash.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 04/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation

extension Proposal {
    enum ProposalError: Error {
        case incorrectParsing
    }
    
    static func deserialize(_ node: Any) throws -> Proposal {
        guard let json = node as? [String: AnyObject] else { throw ProposalError.incorrectParsing }
        
        guard let identifier = json["id"] as? String,
            let name = (json["title"] as? String)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
            let filename = json["link"] as? String else {
                throw ProposalError.incorrectParsing
        }
        
        let swiftVersion = json["status"]?["version"] as? String
        let status = Status(rawValue: (json["status"]?["state"] as? String) ?? "") ?? .unknown
        
        return Proposal(id: identifier,
                        status: status,
                        swiftVersion: swiftVersion,
                        name: name,
                        filename: filename)
    }
}
