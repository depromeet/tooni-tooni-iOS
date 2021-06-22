//
//  GeneralBadgeView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/27.
//

import UIKit

class GeneralBadgeView: BaseCustomView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kCLEAR
        self.baseView.layer.cornerRadius = 2.0
        self.baseView.clipsToBounds = true
    }
    
    func initLabel() {
        self.titleLabel.textColor = kWHITE
        self.titleLabel.font = UIFont.systemFont(ofSize: 11.0, weight: .bold)
        self.titleLabel.textAlignment = .center
        self.titleLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initLabel()
    }
    
}

// MARK: - Bind

extension GeneralBadgeView {
    
    func bind(_ webtoon: Webtoon) {
        guard let site = webtoon.site else { return }
        
        self.titleLabel.text = site.siteShortString
        self.baseView.backgroundColor = site.siteColor
    }
    
}
