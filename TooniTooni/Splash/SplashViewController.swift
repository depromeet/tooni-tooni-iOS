//
//  SplashViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/13.
//

import UIKit
import FirebaseAuth
import Kingfisher

class SplashViewController: BaseViewController {
    
    // MARK: - Vars

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var bigStarImageView: UIImageView!
    @IBOutlet weak var smallStarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!

    // MARK: - Life Cycle
    
    func initBackgroundView() {
        self.view.backgroundColor = kBLACK
    }
    
    func initLabel() {
        self.titleLabel.textColor = kWHITE
        self.titleLabel.font = kPOINT_BOLD_24
        self.titleLabel.textAlignment = .center
        self.titleLabel.numberOfLines = 0
        self.titleLabel.text = "TOONI\nTOONI"

        self.titleLabel.transform = .init(scaleX: 0.001, y: 0.001)
    }
    
    func initImageViews() {
        self.smallStarImageView.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
        self.bigStarImageView.transform = CGAffineTransform.init(scaleX: 0.001, y: 0.001)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.initBackgroundView()
        self.initLabel()
        self.initImageViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.startAnimation()
    }
    
}

// MARK: - Animation

extension SplashViewController {
    
    func startAnimation() {
        let path = Bundle.main.path(forResource:"splash_animation", ofType:"gif")
        let url = URL(fileURLWithPath: path!)
        let provider = LocalFileImageDataProvider(fileURL: url)
        self.logoImageView.kf.setImage(with: provider,
                                       placeholder: nil,
                                       options: nil) { result in
            self.perform(#selector(self.sign), with: nil, afterDelay: 0.5)
        }

        UIView.animate(withDuration: 0.7,
                       delay: 0.0,
                       usingSpringWithDamping: 0.6,
                       initialSpringVelocity: 0.0,
                       options: .curveEaseInOut) {
            self.bigStarImageView.transform = .identity
            self.smallStarImageView.transform = .identity
            self.titleLabel.transform = .identity
        } completion: { _ in

        }
    }
    
}

// MARK: - Auth

extension SplashViewController {
    
    @objc
    func sign() {
        Auth.auth().signInAnonymously() { (authResult, error) in
            if error == nil, let loginToken = authResult?.user.uid {
                self.signIn(loginToken)
                print("loginToken: \(loginToken)")
            }
            else {
                self.failedSign()
            }
        }
    }
    
    func successSign() {
        DispatchQueue.main.async {
            self.startApp()
        }
    }
    
    func failedSign() {
        DispatchQueue.main.async {
            self.retry()
        }
    }
    
    func retry() {
        let alert = UIAlertController.init(title: "알림", message: "앱을 시작할 수 없어요\n잠시 후 다시 시도해주세요 😭", preferredStyle: .alert)
        
        let okAction = UIAlertAction.init(title: "확인", style: .default) { _  in
            self.sign()
        }
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Sign

extension SplashViewController {
    
    func signIn(_ loginToken: String) {
        TooniNetworkService.shared.request(to: .sign(loginToken: loginToken), decoder: User.self) { [weak self] response in
            switch response.result {
            case .success:
                guard let user = response.json as? User else { return }
                
                GeneralHelper.sharedInstance.user = user
                GeneralHelper.sharedInstance.user?.loginToken = loginToken
                
                self?.successSign()
            case .failure:
                print(response)
                self?.failedSign()
            }
        }
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

