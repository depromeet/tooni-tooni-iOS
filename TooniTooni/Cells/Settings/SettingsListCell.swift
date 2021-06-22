//
//  SettingsListCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/09.
//

import UIKit

let kSettingsListCellID =                                           "SettingsListCell"

class SettingsListCell: UITableViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = kWHITE
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = kWHITE_HIGHLIGHT
        
        self.baseView.backgroundColor = kCLEAR
    }
    
    func initLabel() {
        self.titleLabel.textColor = kGRAY_90
        self.titleLabel.font = kBODY2_REGULAR
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

extension SettingsListCell {
    
    func bind(_ type: SettingsType?) {
        if let title = type?.title {
            self.titleLabel.text = title
        }
        
        if let image = type?.image {
            self.iconImageView.image = UIImage.init(named: image)
        }
    }
    
}
