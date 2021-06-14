//
//  WeekMenuCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/27.
//

import UIKit

let kWeekMenuCellID =                                           "WeekMenuCell"

class WeekMenuCell: UICollectionViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kCLEAR
    }
    
    func initLabel() {
        self.titleLabel.font = kBODY1_REGULAR
        self.titleLabel.textColor = kGRAY_50
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

extension WeekMenuCell {
    
    func bind(_ title: String?) {
        self.titleLabel.text = title
    }
    
    func selected(_ selected: Bool) {
        self.titleLabel.font = selected ? kBODY1_BOLD : kBODY1_REGULAR
        self.titleLabel.textColor = selected ? kGRAY_90 : kGRAY_50
    }
    
}
