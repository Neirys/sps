//
//  Section+Rx.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 08/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation
import RxDataSources

extension Section: SectionModelType {
    var items: [Element] {
        return elements
    }
    
    init(original: Section<Element>, items: [Element]) {
        self = original
        self.elements = items
    }
}

extension AnimatableSection: AnimatableSectionModelType {
    typealias Item = Element
    typealias Identity = String
    
    var identity: String {
        return title
    }
    
    var items: [Element] {
        return elements
    }
    
    init(original: AnimatableSection<Element>, items: [Element]) {
        self = original
        self.elements = items
    }
}
