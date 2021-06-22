//
//  GeneralNodataCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/06.
//

import UIKit

let kGeneralNodataCellID =                                          "GeneralNodataCell"

class GeneralNodataCell: UITableViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
    }
    
    func initLabel() {
        self.titleLabel.textColor = kGRAY_90
        self.titleLabel.font = kBODY2_REGULAR
        self.titleLabel.text = nil
        self.titleLabel.numberOfLines = 0
        self.titleLabel.textAlignment = .center
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initLabel()
    }
    
}

// MARK: - Bind

extension GeneralNodataCell {
    
    func bind(_ image: String, _ title: String) {
        self.thumbImageView.image = UIImage.init(named: image)
        
        self.titleLabel.attributedText = title.style(changeText: title,
                                                     lineSpacing: 3.0)
        self.titleLabel.textAlignment = .center
    }
    
}
