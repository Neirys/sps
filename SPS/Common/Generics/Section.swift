//
//  Section.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 08/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import RxDataSources

struct Section<Element> {
    var title: String
    var elements: [Element]
    var isCollapsed: Bool
    
    init(title: String, elements: [Element], isCollapsed: Bool = false) {
        self.title = title
        self.elements = elements
        self.isCollapsed = isCollapsed
    }
}

struct AnimatableSection<Element: IdentifiableType & Equatable> {
    var title: String
    var elements: [Element]
    var isCollapsed: Bool
    
    init(title: String, elements: [Element], isCollapsed: Bool = false) {
        self.title = title
        self.elements = elements
        self.isCollapsed = isCollapsed
    }
}
