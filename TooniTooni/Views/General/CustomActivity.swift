//
//  CustomActivity.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/12.
//

import UIKit

class CustomActivity: BaseCustomView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.alpha = 0.0
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kCLEAR
        self.baseView.layer.cornerRadius = 36.0
        self.baseView.backgroundColor = kGRAY_90
        self.baseView.clipsToBounds = true
    }
    
    func initImageView() {
        let imageList = [
            UIImage.init(named: "member_0")!,
            UIImage.init(named: "member_1")!,
            UIImage.init(named: "member_2")!,
            UIImage.init(named: "member_3")!,
            UIImage.init(named: "member_4")!,
            UIImage.init(named: "member_5")!,
            UIImage.init(named: "member_6")!,
            UIImage.init(named: "member_7")!,
            UIImage.init(named: "member_8")!,
            UIImage.init(named: "member_9")!
        ]
        
        self.thumbImageView.animationImages = imageList.shuffled()
        self.thumbImageView.animationDuration = 1.5
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initImageView()
    }
    
}

// MARK: -

extension CustomActivity {
    
    func start() {
        if self.thumbImageView.isAnimating {
            return
        }
        
        self.thumbImageView.startAnimating()
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1.0
        }
    }
    
    func stop() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0.0
        }) { (_ ) in
            self.thumbImageView.stopAnimating()
        }
    }
    
    func isAnimating() -> Bool {
        return self.thumbImageView.isAnimating
    }

}
