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
        
        //self.startApp()
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
//    guard let nickname = UserDefaults.standard.string(forKey: kUD_NICKNAME),
//          nickname.isEmpty else { return }

    FirebaseService.shared.signInAnonymously { user in
      debug(user.uid)
      UserDefaults.standard.setValue(user.uid, forKey: kUD_TOKEN)

      TooniNetworkService.shared.request(to: .login(user.uid), decoder: Login.self) { [weak self] response in
        guard let login = response.json as? Login else { return }
        UserDefaults.standard.setValue(login.nickname, forKey: kUD_NICKNAME)

        self?.startApp()
      }
    }
  }
}
