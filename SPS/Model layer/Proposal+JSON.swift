//
//  Proposal+SWXMLHash.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 04/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import SwiftyJSON

extension Proposal {
    static func deserialize(_ node: Any) -> Proposal? {
        let json = JSON(node)
        
        guard let identifier = json["id"].string,
            let name = json["title"].string,
            let filename = json["link"].string else {
                return nil
        }
        
        let swiftVersion = json["status"]["version"].string
        let status = Status(rawValue: json["status"]["state"].stringValue) ?? .unknown
        
        return Proposal(id: identifier,
                        status: status,
                        swiftVersion: swiftVersion,
                        name: name,
                        filename: filename)
    }
}
