//
//  ImageExtensions.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/12.
//

import UIKit

extension UIImage {

    class func imageFromColor(_ color: UIColor, width: CGFloat = 1.0, height: CGFloat = 1.0) -> UIImage? {
        var image: UIImage?

        let rect = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: width, height: height))
        
        UIGraphicsBeginImageContext(rect.size)
        if let context: CGContext = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(rect)

            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }

        return image
    }
    
}
