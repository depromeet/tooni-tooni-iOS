//
//  SplashViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/13.
//

import UIKit

class SplashViewController: BaseViewController {
    
    // MARK: - Vars

    // MARK: - Life Cycle
    
    func initBackgroundView() {
        self.view.backgroundColor = kWHITE
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.initBackgroundView()
        self.requestAnonymouslyLogin()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.startApp()
    }
    
}

// MARK: - Start

extension SplashViewController {
    
    func startApp() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
            return
        }

        sceneDelegate.createTabVC()
    }
    
}

// MARK: - Login

extension SplashViewController {

  func requestAnonymouslyLogin() {
    FirebaseService.shared.signInAnonymously { user in
      debug(user.uid)
    }
  }
}
