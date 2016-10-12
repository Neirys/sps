//
//  UIColor+RGB.swift
//  SPS
//
//  Created by Yaman JAIOUCH on 09/10/2016.
//  Copyright © 2016 Yaman JAIOUCH. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(rgb: RGB) {
        self.init(red: CGFloat(rgb.r) / 255, green: CGFloat(rgb.g) / 255, blue: CGFloat(rgb.b) / 255, alpha: CGFloat(rgb.a) / 100)
    }
}

extension RGB {
    func color() -> UIColor {
        return UIColor(rgb: self)
    }
}
