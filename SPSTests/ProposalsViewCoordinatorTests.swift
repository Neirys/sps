//
//  ProposalsViewCoordinatorTests.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 02/11/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import XCTest
import RealmSwift
import RxSwift
import RxTest

@testable import SPS

class ProposalsViewCoordinatorTests: RxTestCase {
    
    private let synchronizer = ProposalsStatusSynchronizer()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatProposalSectionsHaveCorrectOutput() {
        let _expectation = expectation(description: #function)
        
        let configuration = Realm.Configuration(inMemoryIdentifier: #function)
        let realm = try! Realm(configuration: configuration)
        try! realm.write {
            let p1 = RealmProposal(id: "001", rawStatus: Proposal.Status.accepted.rawValue, swiftVersion: nil, name: "Test 1", filename: "001-test")
            let p5 = RealmProposal(id: "005", rawStatus: Proposal.Status.accepted.rawValue, swiftVersion: "4.0", name: "Test 5", filename: "005-test")
            let p2 = RealmProposal(id: "002", rawStatus: Proposal.Status.awaiting.rawValue, swiftVersion: nil, name: "Test 2", filename: "002-test")
            let p3 = RealmProposal(id: "003", rawStatus: Proposal.Status.awaiting.rawValue, swiftVersion: nil, name: "Test 3", filename: "003-test")
            let p4 = RealmProposal(id: "004", rawStatus: Proposal.Status.rejected.rawValue, swiftVersion: nil, name: "Test 4", filename: "004-test")
            
            realm.add([p1, p2, p3, p4, p5], update: true)
        }
        
        let viewCoordinator = ProposalsViewCoordinator(realm: realm, proposalsStatusSynchronizer: synchronizer, searchInput: Observable.just(nil))
        viewCoordinator.proposalSections.drive(onNext: { section in
            XCTAssertEqual(section.count, 4)
            
            XCTAssertEqual(section[0].title, Proposal.Status.awaiting.displayName)
            XCTAssertEqual(section[0].elements.count, 2)
            
            XCTAssertEqual(section[1].title, "\(Proposal.Status.accepted.displayName) (Swift 4.0)")
            XCTAssertEqual(section[1].elements.count, 1)
            
            XCTAssertEqual(section[2].title, Proposal.Status.accepted.displayName)
            XCTAssertEqual(section[2].elements.count, 1)
            
            XCTAssertEqual(section[3].title, Proposal.Status.rejected.displayName)
            XCTAssertEqual(section[3].elements.count, 1)
            
            _expectation.fulfill()
        })
        .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testThatProposalSectionsIsEmpty() {
        let _expectation = expectation(description: #function)
        
        let configuration = Realm.Configuration(inMemoryIdentifier: #function)
        let realm = try! Realm(configuration: configuration)
        
        let viewCoordinator = ProposalsViewCoordinator(realm: realm, proposalsStatusSynchronizer: synchronizer, searchInput: Observable.just(nil))
        viewCoordinator.isEmpty.drive(onNext: { isEmpty in
            XCTAssertTrue(isEmpty)
            
            _expectation.fulfill()
        })
        .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testThatProposalSectionsIsNotEmpty() {
        let _expectation = expectation(description: #function)
        
        let configuration = Realm.Configuration(inMemoryIdentifier: #function)
        let realm = try! Realm(configuration: configuration)
        try! realm.write {
            let p1 = RealmProposal(id: "001", rawStatus: Proposal.Status.accepted.rawValue, swiftVersion: nil, name: "Test 1", filename: "001-test")
            realm.add([p1], update: true)
        }
        
        let viewCoordinator = ProposalsViewCoordinator(realm: realm, proposalsStatusSynchronizer: synchronizer, searchInput: Observable.just(nil))
        viewCoordinator.isEmpty.drive(onNext: { isEmpty in
            XCTAssertFalse(isEmpty)
            
            _expectation.fulfill()
        })
        .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testThatThereAreNoProposalChanges() {
        let _expectation = expectation(description: #function)
        
        let configuration = Realm.Configuration(inMemoryIdentifier: #function)
        let realm = try! Realm(configuration: configuration)
        
        let viewCoordinator = ProposalsViewCoordinator(realm: realm, proposalsStatusSynchronizer: synchronizer, searchInput: Observable.just(nil))
        viewCoordinator.hasUnreadChanges.drive(onNext: { isEmpty in
            XCTAssertFalse(isEmpty)
            
            _expectation.fulfill()
        })
        .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testThatThereAreProposalChanges() {
        let _expectation = expectation(description: #function)
        
        let configuration = Realm.Configuration(inMemoryIdentifier: #function)
        let realm = try! Realm(configuration: configuration)
        try! realm.write {
            let p1 = RealmProposal(id: "001", rawStatus: Proposal.Status.accepted.rawValue, swiftVersion: nil, name: "Test 1", filename: "001-test")
            let c1 = RealmProposalChange(.add(proposal: p1))
            realm.add([c1])
        }
        
        let viewCoordinator = ProposalsViewCoordinator(realm: realm, proposalsStatusSynchronizer: synchronizer, searchInput: Observable.just(nil))
        viewCoordinator.hasUnreadChanges.drive(onNext: { isEmpty in
            XCTAssertTrue(isEmpty)
            
            _expectation.fulfill()
        })
        .addDisposableTo(disposeBag)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // FIXME: Please someone help, I can't make it work ....
    // Here's the thing : `proposalSections` should emit an event with filtered results everytime a new `searchInput` emits a new event
    // So I'm creating a scheduler to emulate `searchInput` events.
    // Problem is : `searchInput` is emitting all the values THEN `proposalSections` emits only once at the very end (instead of emitting event everytime `searchInput` emits too)
    // Even if I'm setting large virtual time to every events
//    func testFilteringProposals() {
//        let _expectation = expectation(description: #function)
//        
//        let configuration = Realm.Configuration(inMemoryIdentifier: #function)
//        let realm = try! Realm(configuration: configuration)
//        try! realm.write {
//            let p1 = RealmProposal(id: "001", rawStatus: Proposal.Status.accepted.rawValue, swiftVersion: nil, name: "Test 1", filename: "Condition blabla")
//            let p2 = RealmProposal(id: "002", rawStatus: Proposal.Status.awaiting.rawValue, swiftVersion: nil, name: "Test 2", filename: "Conditional conforming blabla")
//            
//            realm.add([p1, p2], update: true)
//        }
//        
//        let scheduler = TestScheduler(initialClock: 0)
//        let observer = scheduler.createObserver(Int.self)
//        
//        let searchInput: TestableObservable<String?> = scheduler.createHotObservable([
//                next(0, nil),
//                next(100, "Condit"),
//                next(1000, "Conditional"),
//                next(10000, "Conditional confor"),
//                next(100000, "Conditional conforaidnaoa"),
//                completed(1000000)
//            ])
//        let searchInputObservable = searchInput.asObservable()
//            .debug("searchInput")
        
        // Try n°1
        
//        let res: TestableObserver<Int> = scheduler.start {
//            let coordinator = ProposalsViewCoordinator(realm: realm, proposalsStatusSynchronizer: self.synchronizer, searchInput: searchInputObservable)
//            let observable: Observable<Int> = coordinator.proposalSections
//                .map { sections in
//                    let proposals = sections.flatMap { $0.elements }
//                    return proposals.count
//                }
//                .debug("proposalSections")
//                .asObservable()
//            
//            return observable
//        }
//        
//        waitForExpectations(timeout: 5) { error in
//            XCTAssertEqual(res.events.count, 3)
//        }
        
        // Try n°2
        
//        searchInputObservable
//            .debug("searchInput")
//            .subscribe(onCompleted: {
//                //                _expectation.fulfill()
//            })
//            .addDisposableTo(disposeBag)
        
//        scheduler.start()
        
//        let viewCoordinator = ProposalsViewCoordinator(realm: realm, proposalsStatusSynchronizer: synchronizer, searchInput: searchInputObservable)
//        
//        viewCoordinator.proposalSections
//            .map { sections in
//                let proposals = sections.flatMap { $0.elements }
//                return proposals.count
//            }
//            .debug("proposalSections")
//            .drive(observer)
//            .addDisposableTo(disposeBag)
//        
//        scheduler.start()
//        
//        waitForExpectations(timeout: 5) { error in
//            XCTAssertNil(error)
//            XCTAssertEqual(observer.events.count, 3)
////            XCTAssertEqual(observer.events[0].value.element!, 2)
////            XCTAssertEqual(observer.events[1].value.element!, 1)
////            XCTAssertEqual(observer.events[2].value.element!, 1)
//        }
//    }
    
    // FIXME: Same shit as above ...
//    func testTogglingSections() {
//        let _expectation = expectation(description: #function)
//        
//        let configuration = Realm.Configuration(inMemoryIdentifier: #function)
//        let realm = try! Realm(configuration: configuration)
//        try! realm.write {
//            let p1 = RealmProposal(id: "001", rawStatus: Proposal.Status.accepted.rawValue, swiftVersion: nil, name: "Test 1", filename: "")
//            let p2 = RealmProposal(id: "002", rawStatus: Proposal.Status.accepted.rawValue, swiftVersion: nil, name: "Test 2", filename: "")
//
//            realm.add([p1, p2], update: true)
//        }
//        
//        let section = AnimatableSection<ProposalViewModel>(title: "Accepted (awaiting implementation)", elements: [])
//        
//        let scheduler = TestScheduler(initialClock: 0)
//        let observer = scheduler.createObserver(Int.self)
//        
//        let toggle = scheduler.createHotObservable([
//                next(100, section),
//                next(1000, section),
//                next(10000, section),
//                completed(11000)
//            ])
//            .shareReplayLatestWhileConnected()
//        
//        let coordinator = ProposalsViewCoordinator(realm: realm, proposalsStatusSynchronizer: synchronizer, searchInput: Observable.just(nil))
//        
//        toggle
//            .debug("toggling")
//            .bindTo(coordinator.headerTapped)
//            .addDisposableTo(disposeBag)
//        
////        toggle
////            .subscribe(onCompleted: _expectation.fulfill)
////            .addDisposableTo(disposeBag)
//        
//        coordinator.proposalSections
//            .map { sections in
//                let section = sections.first!
//                return section.elements.count
//            }
//            .debug("sections")
//            .drive(observer)
//            .addDisposableTo(disposeBag)
//        
//        scheduler.start()
//        
//        waitForExpectations(timeout: 20) { error in
////            XCTAssertNil(error)
//            XCTAssertEqual(observer.events.count, 3)
//        }
//    }
}
