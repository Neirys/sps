//
//  RBGTests.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 04/11/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import XCTest

@testable import SPS

class RBGTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRGBEquality() {
        let r1 = RGB(25, 12, 294, 100)
        let r2 = RGB(25, 12, 294, 100)
        XCTAssertEqual(r1, r2)
        
        let r3 = RGB(25, 12, 294, 100)
        let r4 = RGB(25, 12, 294, 45)
        XCTAssertNotEqual(r3, r4)
    }
    
}
