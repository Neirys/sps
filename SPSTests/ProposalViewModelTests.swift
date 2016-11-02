//
//  ProposalViewModelTests.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 02/11/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import XCTest
@testable import SPS

class ProposalViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatProposalViewModelHasCorrectOutputs() {
        let proposal: ProposalType = Proposal(id: "001", status: .accepted, swiftVersion: "3.0", name: "This is a test proposal", filename: "001-test-proposal")
        let proposalViewModel = ProposalViewModel(proposal)
        
        XCTAssertEqual(proposalViewModel.id, "SE-001")
        XCTAssertEqual(proposalViewModel.name, "This is a test proposal")
        XCTAssertEqual(proposalViewModel.url, URL(string: "https://github.com/apple/swift-evolution/blob/master/proposals/001-test-proposal"))
        XCTAssertEqual(proposalViewModel.cartBackgroundColor, Proposal.Status.accepted.backgroundColor)
        XCTAssertEqual(proposalViewModel.cartTextColor, Proposal.Status.accepted.textColor)
        XCTAssertEqual(proposalViewModel.identity, proposalViewModel.id)
    }
    
    func testThatTwoProposalViewModelsAreEquals() {
        let p1: ProposalType = Proposal(id: "001", status: .accepted, swiftVersion: "3.0", name: "This is a test proposal", filename: "001-test-proposal")
        let p2: ProposalType = Proposal(id: "001", status: .active, swiftVersion: nil, name: "This is a test proposal 2", filename: "just-to-show-equality-is-based-on-id")
        let pvm1 = ProposalViewModel(p1)
        let pvm2 = ProposalViewModel(p2)
        
        XCTAssertEqual(pvm1, pvm2)
    }
}
