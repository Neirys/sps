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
}

struct AnimatableSection<Element: IdentifiableType & Equatable> {
    var title: String
    var elements: [Element]
}
