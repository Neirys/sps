//
//  Proposal.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 04/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation

struct Proposal {
    enum Status: String {
        case implemented
        case accepted
        case active
        case scheduled
        case awaiting
        case deferred
        case returned
        case rejected
        case withdrawn
        case unknown
    }
    
    let id: String
    let status: Status
    let swiftVersion: String?
    let name: String
    let filename: String
}
