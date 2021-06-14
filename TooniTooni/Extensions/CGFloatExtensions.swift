//
//  CGFloatExtensions.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/30.
//

import UIKit

extension CGFloat {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
    var radiansToDegrees: CGFloat { return CGFloat(self) * 180 / .pi }
}
