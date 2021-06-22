//
//  BaseViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/12.
//

import UIKit

class BaseViewController: UIViewController {
    
    // MARK: - Vars
    
    var showBigTitle = true
    var tabItem: TabItem?
    var pageIdx = 0
            
    var popRecognizer: InteractivePopRecognizer?

    // MARK: - Life Cycle
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overrideUserInterfaceStyle = .light

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.addObservers()
    }

    deinit {
        self.removeObservers()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
}

// MARK: - Observers

extension BaseViewController {
    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillResignActive(sender:)),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground(sender:)),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground(sender:)),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidBecomeActive(sender:)),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willResignActiveNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didEnterBackgroundNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.willEnterForegroundNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIApplication.didBecomeActiveNotification,
                                                  object: nil)
    }
    
    @objc
    func applicationWillResignActive(sender: AnyObject) {
        
    }
    
    @objc
    func applicationDidEnterBackground(sender: AnyObject) {
        
    }
    
    @objc
    func applicationWillEnterForeground(sender: AnyObject) {
        
    }
    
    @objc
    func applicationDidBecomeActive(sender: AnyObject) {

    }

}

// MARK: - Alert

extension BaseViewController {
    
    func showAlertWithTitle(vc: UIViewController, title: String?, message: String) {
        let alert: UIAlertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        
        let okAction: UIAlertAction = UIAlertAction.init(title: "확인",
                                                         style: .default,
                                                         handler: nil)
        alert.addAction(okAction)
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    func showReadyAlert(vc: UIViewController) {
        self.showAlertWithTitle(vc: vc, title: nil, message: "준비중")
    }
    
}

// MARK: - Navigation

extension BaseViewController {
    
    func setInteractiveRecognizer() {
        guard let controller = navigationController else { return }
        
        self.popRecognizer = InteractivePopRecognizer(controller: controller)
        controller.interactivePopGestureRecognizer?.delegate = self.popRecognizer
    }

}

// MARK: - InteractivePopRecognizer

class InteractivePopRecognizer: NSObject {
    
    var navigationController: UINavigationController
    
    init(controller: UINavigationController) {
        self.navigationController = controller
    }
    
}

// MARK: - UIGestureRecognizer Delegate

extension InteractivePopRecognizer: UIGestureRecognizerDelegate {

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return navigationController.viewControllers.count > 1
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }

}
