//
//  SettingsHeaderView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/09.
//

import UIKit

let kSettingsHeaderViewID =                                     "SettingsHeaderView"

class SettingsHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var profileView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var versionView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
    }
    
    func initProfileView() {
        self.profileView.backgroundColor = kGRAY_10
        self.profileView.layer.cornerRadius = 30.0
        self.profileView.clipsToBounds = true
        
        self.profileImageView.contentMode = .scaleAspectFill
    }
    
    func initVersionView() {
        self.versionView.backgroundColor = kSKYBLUE_100
        self.versionView.layer.cornerRadius = 5.0
        self.versionView.clipsToBounds = true
    }
    
    func initLabels() {
        self.nameLabel.textColor = kGRAY_90
        self.nameLabel.font = kHEADING3_BOLD
        self.nameLabel.text = nil
        
        self.statusLabel.textColor = kGRAY_50
        self.statusLabel.font = kCAPTION1_REGULAR
        self.statusLabel.text = "안녕하세요 투니투니입니다 😁"
        
        self.versionLabel.textColor = kWHITE
        self.versionLabel.font = kBODY2_REGULAR
        self.versionLabel.text = String().appLongVersion
        
        self.infoLabel.textColor = kWHITE
        self.infoLabel.font = kCAPTION1_REGULAR
        self.infoLabel.textAlignment = .right
        self.infoLabel.text = "열심히 업데이트 중이에요!"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initProfileView()
        self.initVersionView()
        self.initLabels()
    }
    
}

// MARK: - Bind

extension SettingsHeaderView {
    
    func bind() {
        if let nickname = GeneralHelper.sharedInstance.user?.nickname {
            self.nameLabel.text = nickname
        }
        
        if let profileImage = GeneralHelper.sharedInstance.user?.profileImage {
            self.profileImageView.kf.setImage(with: URL.init(string: profileImage),
                                              placeholder: nil,
                                              options: [.transition(.fade(0.25))], completionHandler: nil)
        }
    }
    
}
