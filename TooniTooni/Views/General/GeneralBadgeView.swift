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
        if webtoon.site?.lowercased() == "naver" {
            self.titleLabel.text = "N"
            self.baseView.backgroundColor = kNAVER_100
        }
        else if webtoon.site?.lowercased() == "daum" {
            self.titleLabel.text = "D"
            self.baseView.backgroundColor = kDAUM_100
        }
        else if webtoon.site?.lowercased() == "kakao" {
            self.titleLabel.text = "K"
            self.baseView.backgroundColor = kKAKAO_100
        }
    }

    func bind(_ site: String?) {
        if site?.lowercased() == "naver" {
            self.titleLabel.text = "N"
            self.baseView.backgroundColor = kNAVER_100
        }
        else if site?.lowercased() == "daum" {
            self.titleLabel.text = "D"
            self.baseView.backgroundColor = kDAUM_100
        }
        else if site?.lowercased() == "kakao" {
            self.titleLabel.text = "K"
            self.baseView.backgroundColor = kKAKAO_100
        }
    }
    
}
