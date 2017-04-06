//
//  Proposal_SWXMLHashTests.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 04/11/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import XCTest
import SWXMLHash

@testable import SPS

class Proposal_SWXMLHashTests: XCTestCase {
    
    private lazy var xml: XMLIndexer = {
        let filePath = Bundle.main.path(forResource: "test-proposals", ofType: "xml")!
        let url = URL(fileURLWithPath: filePath)
        let data = try! Data(contentsOf: url)
        return SWXMLHash.parse(data)
    }()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatParsingXMLHasCorrectOutputs() {
        do {
            let proposals: [Proposal] = try xml["proposals"]["proposal"].value()
            
            XCTAssertEqual(proposals.count, 1)
            XCTAssertEqual(proposals[0].id, "0001")
            XCTAssertEqual(proposals[0].status, .implemented)
            XCTAssertEqual(proposals[0].swiftVersion, "2.2")
            XCTAssertEqual(proposals[0].name, "Allow (most) keywords as argument labels")
            XCTAssertEqual(proposals[0].filename, "0001-keywords-as-argument-labels.md")
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
}
