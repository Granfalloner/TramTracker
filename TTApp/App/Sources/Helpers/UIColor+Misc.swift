//
//  UIColor+Misc.swift
//  TTKit
//
//  Created by Vasyl Myronchuk on 07/02/2019.
//  Copyright © 2019 Vasyl Myronchuk. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: UInt) {
        self.init(red: CGFloat((hex >> 16) & 0xff) / 255.0,
                  green: CGFloat((hex >> 8) & 0xff) / 255.0,
                  blue: CGFloat((hex >> 0) & 0xff) / 255.0,
                  alpha: 1.0)
    }

    convenience init(hexWithAlpha: UInt) {
        self.init(red: CGFloat((hexWithAlpha >> 24) & 0xff) / 255.0,
                  green: CGFloat((hexWithAlpha >> 16) & 0xff) / 255.0,
                  blue: CGFloat((hexWithAlpha >> 8) & 0xff) / 255.0,
                  alpha: CGFloat(hexWithAlpha & 0xff) / 255.0)
    }

    class var stopRegular: UIColor {
        return UIColor(hex: 0x19A8C2)
    }

    class var stopActive: UIColor {
        return .red
    }

    class var timetableTint: UIColor {
        return UIColor(hex: 0x4F476B)
    }
}
