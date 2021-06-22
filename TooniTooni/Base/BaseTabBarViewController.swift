//
//  BaseTabBarViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/12.
//

import UIKit
import AVKit

class BaseTabBarViewController: UITabBarController {

    // MARK: - Vars
            
    // MARK: - Life Cycle
    
    func initVars() {
        self.delegate = self
        self.overrideUserInterfaceStyle = .light

        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func initNavigationView() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    func initTabBar() {
        let whiteView: UIView = UIView()
        whiteView.backgroundColor = kWHITE
        whiteView.frame = CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: kDEVICE_WIDTH, height: kDEVICE_HEIGHT))
        self.tabBar.addSubview(whiteView)

        UITabBar.appearance().tintColor = kGRAY_90
//        UITabBar.appearance().backgroundImage = UIImage.imageFromColor(kWHITE)
//        UITabBar.appearance().shadowImage = UIImage.imageFromColor(kGRAY_90)
//        UITabBar.appearance().selectionIndicatorImage = UIImage.imageFromColor(kGRAY_90)

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: kGRAY_90, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 8.0)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: kGRAY_90, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 8.0)], for: .disabled)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: kGRAY_90, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 8.0)], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: kGRAY_90, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 8.0)], for: .highlighted)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: kGRAY_90, NSAttributedString.Key.font:UIFont.systemFont(ofSize: 8.0)], for: .focused)

        if let tabBarItems = self.tabBar.items {
            for (index, tabItem) in GeneralHelper.sharedInstance.tabList.enumerated() {
                tabBarItem.tag = index

                let tabBarItem = tabBarItems[index]
                tabBarItem.title = tabItem.title
                tabBarItem.tag = index
                tabBarItem.image = UIImage.init(named: tabItem.iconImage!)?.withRenderingMode(.alwaysOriginal)
                tabBarItem.selectedImage = UIImage.init(named: tabItem.iconImage! + "_on")?.withRenderingMode(.alwaysOriginal)
            }
        }
    }
        
    func initViewControllers() {
        var controllers: [UINavigationController] = []
        
        for tabItem in GeneralHelper.sharedInstance.tabList {
            let vc: BaseViewController = GeneralHelper.sharedInstance.makeVC(tabItem.storyBoard, tabItem.viewController)
            vc.tabItem = tabItem
            
            let nc: UINavigationController = UINavigationController.init(rootViewController: vc)
            controllers.append(nc)
        }
        
        self.viewControllers = controllers
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initVars()
        self.initViewControllers()
        self.initTabBar()
    }
     
}

extension BaseTabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let tabViewControllers = tabBarController.viewControllers, let toIndex = tabViewControllers.firstIndex(of: viewController) else {
            return false
        }
        
        self.animateToTab(toIndex: toIndex)
        
        return true
    }
    
    func animateToTab(toIndex: Int) {
        guard let tabViewControllers = viewControllers,
            let selectedVC = selectedViewController else { return }
        
        guard let fromView = selectedVC.view,
            let toView = tabViewControllers[toIndex].view,
            let fromIndex = tabViewControllers.firstIndex(of: selectedVC),
            fromIndex != toIndex else { return }
        
        fromView.superview?.addSubview(toView)
        
        let scrollRight = toIndex > fromIndex
        let offset = (scrollRight ? kDEVICE_WIDTH : -kDEVICE_WIDTH)
        toView.center = CGPoint(x: fromView.center.x + offset, y: toView.center.y)
        
        view.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: 0.3,
                       delay: 0.0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut,
                       animations: {
                        fromView.center = CGPoint(x: fromView.center.x - offset, y: fromView.center.y)
                        toView.center = CGPoint(x: toView.center.x - offset, y: toView.center.y)
        }, completion: { finished in
            fromView.removeFromSuperview()
            self.selectedIndex = toIndex
            self.view.isUserInteractionEnabled = true
        })
    }

}
