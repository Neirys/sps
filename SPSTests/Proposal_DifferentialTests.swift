//
//  Proposal_DifferentialTests.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 04/11/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import XCTest

@testable import SPS

class Proposal_DifferentialTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testProposalDifferential() {
        let p1 = Proposal(id: "001", status: .active, swiftVersion: "4.0", name: "Test 001", filename: "001-test")
        let p2 = Proposal(id: "002", status: .rejected, swiftVersion: nil, name: "Test 002", filename: "002-test")
        let p3 = Proposal(id: "003", status: .awaiting, swiftVersion: "4.0", name: "Test 003", filename: "003-test")
        
        let p1b = Proposal(id: "001", status: .accepted, swiftVersion: "4.0", name: "Test 001", filename: "001-test")
        let p2b = Proposal(id: "002", status: .rejected, swiftVersion: nil, name: "Test 002", filename: "002-test")
        let p4 = Proposal(id: "004", status: .deferred, swiftVersion: nil, name: "Test 004", filename: "004-test")
        
        let changes = differential(from: [p1, p2, p3], to: [p1b, p2b, p4])
        
        XCTAssertEqual(changes.count, 3)
        
        XCTAssertEqual(changes[0].id, "004")
        XCTAssertTrue(changes[0].addOrUpdate)
        XCTAssertFalse(changes[0].delete)
        
        XCTAssertEqual(changes[1].id, "003")
        XCTAssertFalse(changes[1].addOrUpdate)
        XCTAssertTrue(changes[1].delete)
        
        guard case .update(_, let fromStatus, let toStatus) = changes[2] else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(changes[2].id, "001")
        XCTAssertTrue(changes[2].addOrUpdate)
        XCTAssertFalse(changes[2].delete)
        XCTAssertEqual(fromStatus, Proposal.Status.active)
        XCTAssertEqual(toStatus, Proposal.Status.accepted)
    }
}

private extension ProposalChange {
    var id: String {
        return proposal.id
    }
}
