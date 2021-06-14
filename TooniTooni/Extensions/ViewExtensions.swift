//
//  ViewExtensions.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/24.
//

import UIKit

extension UIView {
        
    private static let kRotationAnimationKey = "rotationanimationkey"
    private static let kBouncingAnimationKey = "bouncinganimationkey"

    func rotate(duration: Double = 1, repeatCount: Float = 0.0) {
        if layer.animation(forKey: UIView.kRotationAnimationKey) == nil {
            let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation")
            
            rotationAnimation.fromValue = 0.0
            rotationAnimation.toValue = Float.pi * 2.0
            rotationAnimation.duration = duration
            rotationAnimation.repeatCount = .infinity
            
            layer.add(rotationAnimation, forKey: UIView.kRotationAnimationKey)
        }
    }
    
    func stopRotating() {
        if layer.animation(forKey: UIView.kRotationAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kRotationAnimationKey)
        }
    }

    func bounce(duration: Double = 1, repeatCount: Float = 0.0) {
        if layer.animation(forKey: UIView.kBouncingAnimationKey) == nil {
            let bouncingAnimation = CABasicAnimation(keyPath: "transform.translation.y")
            
            bouncingAnimation.fromValue = 0.0
            bouncingAnimation.toValue = 10.0
            bouncingAnimation.duration = duration
            bouncingAnimation.repeatCount = .infinity
            bouncingAnimation.autoreverses = true
            
            layer.add(bouncingAnimation, forKey: UIView.kBouncingAnimationKey)
        }
    }
    
    func stopBouncing() {
        if layer.animation(forKey: UIView.kBouncingAnimationKey) != nil {
            layer.removeAnimation(forKey: UIView.kBouncingAnimationKey)
        }
    }

    static var reuseIdentifier: String {
        let nameSpace = NSStringFromClass(self)
        
        guard let className = nameSpace.components(separatedBy: ".").last else {
            return nameSpace
        }
        
        return className
    }

}

