//
//  Proposal+SWXMLHash.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 04/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation

extension Proposal {
    static func deserialize(_ node: Any) -> Proposal? {
        guard let json = node as? [String: AnyObject] else { return nil }
        
        guard let identifier = json["id"] as? String,
            let name = (json["title"] as? String)?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines),
            let filename = json["link"] as? String else {
                return nil
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
