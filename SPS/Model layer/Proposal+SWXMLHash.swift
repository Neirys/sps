//
//  Proposal+SWXMLHash.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 04/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import SWXMLHash

extension Proposal: XMLIndexerDeserializable {
    static func deserialize(_ node: XMLIndexer) throws -> Proposal {
        return try Proposal(
            id: node.value(ofAttribute: "id"),
            status: Status(rawValue: node.value(ofAttribute: "status")) ?? .unknown,
            swiftVersion: node.value(ofAttribute: "swift-version"),
            name: node.value(ofAttribute: "name"),
            filename: node.value(ofAttribute: "filename")
        )
    }
}
