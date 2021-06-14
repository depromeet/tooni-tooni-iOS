//
//  GeneralActivity.swift
//  LOLChang
//
//  Created by GENETORY on 05/03/2019.
//  Copyright © 2019 GENETORY. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class GeneralActivity: BaseCustomView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var activity: NVActivityIndicatorView!
    
    // MARK: - Life Cycle

    func initVars() {
        self.clipsToBounds = true
        self.alpha = 0.0
    }
    
    func initBackgroundView() {
        self.containerView.backgroundColor = kCLEAR
    }
    
    func initBaseView() {
        self.baseView.backgroundColor = kGRAY_90
        self.baseView.layer.cornerRadius = 20.0
        self.baseView.clipsToBounds = true
    }
    
    func initActivity() {
        self.activity.type = .circleStrokeSpin
        self.activity.color = kWHITE
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initBaseView()
        self.initActivity()
    }
    
    // MARK: - Activity
    
    func start() {
        if self.activity.isAnimating {
            return
        }
        
        self.activity.startAnimating()
        
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1.0
        }
    }
    
    func stop() {
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = 0.0
        }) { (_ ) in
            self.activity.stopAnimating()
        }
    }
    
    func isAnimating() -> Bool {
        return self.activity.isAnimating
    }
    
}

// MARK: -

extension GeneralActivity {
    
    func color(_ color: UIColor) {
        self.baseView.backgroundColor = color
    }
    
    func activityColor(_ color: UIColor) {
        self.activity.color = color
    }

    func corner(_ corner: CGFloat) {
        self.baseView.layer.cornerRadius = corner
    }
    
}
