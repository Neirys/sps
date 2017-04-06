//
//  ProposalsHistoryViewCoordinatorTests.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 04/11/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import XCTest
import RealmSwift
import RxTest

@testable import SPS

class ProposalsHistoryViewCoordinatorTests: RxTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatHistoryIsReactivlyUpdated() { // rofl
        let _expectation = expectation(description: #function)
        
        let configuration = Realm.Configuration(inMemoryIdentifier: #function)
        let realm = try! Realm(configuration: configuration)
        
        let scheduler = TestScheduler(initialClock: 0)
        let observer = scheduler.createObserver(Int.self)
        
        let coordinator = ProposalsHistoryViewCoordinator(realm: realm)
    
        coordinator.history
            .scan(0) { acc, _ in return acc + 1 }
            .filter { $0 == 3 }
            .map { _ in return () }
            .drive(onNext: _expectation.fulfill)
            .addDisposableTo(disposeBag)
        
        coordinator.history
            .map { $0.first!.elements.count }
            .drive(observer)
            .addDisposableTo(disposeBag)
        
        scheduler.start()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            try! realm.write {
                let p1 = RealmProposal(id: "001", rawStatus: Proposal.Status.accepted.rawValue, swiftVersion: nil, name: "Test 1", filename: "001-test")
                let c1 = ProposalChange.add(proposal: p1)
                let pc1 = RealmProposalChange(c1)
                
                realm.add(pc1)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            try! realm.write {
                realm.delete(realm.objects(RealmProposalChange.self).first!)
            }
        }
        
        waitForExpectations(timeout: 2) { error in
            XCTAssertNil(error)
            XCTAssertEqual(observer.events.count, 3)
            XCTAssertEqual(observer.events[0].value.element!, 0)
            XCTAssertEqual(observer.events[1].value.element!, 1)
            XCTAssertEqual(observer.events[2].value.element!, 0)
        }
    }
}
