//
//  SceneDelegate.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/12.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
        
}

// MARK: - UIViewController

extension SceneDelegate {
    
    func createTabVC() {
        self.dismissVC()
        
        if let vc = GeneralHelper.sharedInstance.makeTabBarVC("Base", "BaseTabBarViewController") as? BaseTabBarViewController {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
        }
    }

    func dismissVC() {
        if (self.window?.rootViewController?.presentedViewController != nil) {
            self.window?.rootViewController?.dismiss(animated: false, completion: nil)
        }
    }

}

