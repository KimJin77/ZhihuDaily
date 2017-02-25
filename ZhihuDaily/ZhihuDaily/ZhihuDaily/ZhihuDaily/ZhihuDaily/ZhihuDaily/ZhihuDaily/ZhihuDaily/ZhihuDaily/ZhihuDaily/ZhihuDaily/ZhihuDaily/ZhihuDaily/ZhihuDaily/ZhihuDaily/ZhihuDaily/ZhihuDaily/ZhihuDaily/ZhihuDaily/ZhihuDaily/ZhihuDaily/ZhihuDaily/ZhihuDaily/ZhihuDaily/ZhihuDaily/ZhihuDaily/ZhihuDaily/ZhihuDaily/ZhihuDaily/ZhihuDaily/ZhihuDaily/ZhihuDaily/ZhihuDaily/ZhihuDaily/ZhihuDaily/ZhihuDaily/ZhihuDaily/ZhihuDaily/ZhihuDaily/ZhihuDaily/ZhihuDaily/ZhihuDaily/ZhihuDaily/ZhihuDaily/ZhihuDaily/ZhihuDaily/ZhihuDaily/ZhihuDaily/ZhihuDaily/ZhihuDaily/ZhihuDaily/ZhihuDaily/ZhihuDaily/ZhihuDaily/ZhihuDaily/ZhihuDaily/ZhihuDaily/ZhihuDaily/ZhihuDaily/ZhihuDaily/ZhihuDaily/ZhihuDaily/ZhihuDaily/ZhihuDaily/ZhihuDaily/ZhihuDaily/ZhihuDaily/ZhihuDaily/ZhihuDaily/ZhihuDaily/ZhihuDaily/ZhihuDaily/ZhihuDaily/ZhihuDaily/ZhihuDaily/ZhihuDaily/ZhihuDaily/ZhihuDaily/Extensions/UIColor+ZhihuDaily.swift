//
//  UIColor+ZhihuDaily.swift
//  ZhihuDaily
//
//  Created by Sim Jin on 2017/1/10.
//  Copyright © 2017年 Jin. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func color(of hex: Int) -> UIColor {
		let red = (hex & 0xFF0000) >> 16
		let green = (hex & 0x00FF00) >> 8
        let blue = (hex & 0x0000FF)
        return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
