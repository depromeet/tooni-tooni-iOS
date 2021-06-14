//
//  IntExtensions.swift
//  Aggro
//
//  Created by GENETORY on 2020/11/19.
//  Copyright © 2020 GENETORY. All rights reserved.
//

import UIKit

extension Int {
    
    var numString: String {
        let numberFormatter: NumberFormatter = NumberFormatter.init()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(from: NSNumber.init(value: self))!
    }

    var string: String {
        return String.init(format: "%d", self)
    }

}
