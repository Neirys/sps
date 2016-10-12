//
//  RGB.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 09/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import Foundation

// TODO: checks boundaries
struct RGB {
    var r, g, b, a: Int
    
    init(_ r: Int, _ g: Int, _ b: Int, _ a: Int = 100) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    
    static func white() -> RGB {
        return RGB(255, 255, 255)
    }
    
    static func black() -> RGB {
        return RGB(0, 0, 0)
    }
}
