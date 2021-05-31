//
//  ViewExtensions.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/24.
//

import UIKit

extension UIView {
    
    static var reuseIdentifier: String {
        let nameSpace = NSStringFromClass(self)
        
        guard let className = nameSpace.components(separatedBy: ".").last else {
            return nameSpace
        }
        
        return className
    }
    
}

extension UILabel {

    func changeColor(for site: String?) {
        if site?.lowercased() == "naver" {
          self.textColor = kNAVER_100
        } else if site?.lowercased() == "daum" {
          self.textColor = kDAUM_100
        } else if site?.lowercased() == "kakao" {
          self.textColor = kKAKAO_100
        }
    }
}
