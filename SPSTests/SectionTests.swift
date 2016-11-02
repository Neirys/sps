//
//  SectionTests.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 04/11/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import XCTest

@testable import SPS

class SectionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testSectionCollapsedState() {
        var section = Section<Int>(title: "", elements: [1, 2, 3])
        XCTAssertEqual(section.elements.count, 3)
        XCTAssertEqual(section.items.count, 3)
        section.isCollapsed = true
        XCTAssertFalse(section.elements.isEmpty)
        XCTAssertTrue(section.items.isEmpty)
        section.isCollapsed = false
        XCTAssertFalse(section.elements.isEmpty)
        XCTAssertFalse(section.items.isEmpty)
        
        var animatableSection = AnimatableSection<Int>(title: "", elements: [1, 2, 3])
        XCTAssertEqual(animatableSection.elements.count, 3)
        XCTAssertEqual(animatableSection.items.count, 3)
        animatableSection.isCollapsed = true
        XCTAssertFalse(animatableSection.elements.isEmpty)
        XCTAssertTrue(animatableSection.items.isEmpty)
        animatableSection.isCollapsed = false
        XCTAssertFalse(animatableSection.elements.isEmpty)
        XCTAssertFalse(animatableSection.items.isEmpty)
    }
    
}
