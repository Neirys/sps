//
//  ProposalChangeViewModelTests.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 02/11/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import XCTest
@testable import SPS

class ProposalChangeViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatProposalChangeViewModelHasCorrectOutputs() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = dateFormatter.date(from: "26/12/1990")!
        
        let proposal = Proposal(id: "001", status: .accepted, swiftVersion: nil, name: "Test proposal", filename: "001-test")
        let change = ProposalChange.add(proposal: proposal)
        let locale = Locale(identifier: "en_GB")
        let proposalChangeViewModel = ProposalChangeViewModel(change: change, createdAt: date, isNew: false, locale: locale)
        
        XCTAssertEqual(proposalChangeViewModel.id, "SE-001")
        XCTAssertEqual(proposalChangeViewModel.name, "Test proposal")
        XCTAssertEqual(proposalChangeViewModel.url, URL(string: "https://github.com/apple/swift-evolution/blob/master/proposals/001-test"))
        XCTAssertEqual(proposalChangeViewModel.cartBackgroundColor, Proposal.Status.accepted.backgroundColor)
        XCTAssertEqual(proposalChangeViewModel.cartTextColor, Proposal.Status.accepted.textColor)
        XCTAssertEqual(proposalChangeViewModel.identity, "\(proposalChangeViewModel.id)\(proposalChangeViewModel.createdAt.timeIntervalSince1970)")
        XCTAssertEqual(proposalChangeViewModel.changeDescription, "Added to \(Proposal.Status.accepted.displayName)")
        XCTAssertEqual(proposalChangeViewModel.changeDate, "26 Dec 90")
    }
    
    func testProposalChangeViewModelDifferentStatus() {
        let p1 = Proposal(id: "001", status: .accepted, swiftVersion: nil, name: "Test proposal", filename: "001-test")
        
        let c1 = ProposalChange.add(proposal: p1)
        let pcvm1 = ProposalChangeViewModel(change: c1, createdAt: Date(), isNew: false)
        XCTAssertEqual(pcvm1.changeDescription, "Added to \(Proposal.Status.accepted.displayName)")
        
        let c2 = ProposalChange.delete(proposal: p1)
        let pcvm2 = ProposalChangeViewModel(change: c2, createdAt: Date(), isNew: false)
        XCTAssertEqual(pcvm2.changeDescription, "Deleted")
        
        let c3 = ProposalChange.update(proposal: p1, fromStatus: .active, toStatus: .awaiting)
        let pcvm3 = ProposalChangeViewModel(change: c3, createdAt: Date(), isNew: false)
        XCTAssertEqual(pcvm3.changeDescription, "Updated from \(Proposal.Status.active.displayName) to \(Proposal.Status.awaiting.displayName)")
        
        let c4 = ProposalChange.unknown(proposal: p1)
        let pcvm4 = ProposalChangeViewModel(change: c4, createdAt: Date(), isNew: false)
        XCTAssertEqual(pcvm4.changeDescription, "Unknown")
    }
}
