//
//  HomeNewCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/27.
//

import UIKit

let kHomeNewCellID =                                        "HomeNewCell"

class HomeNewCell: UICollectionViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kGRAY_10
    }
    
    func initLabel() {
        self.titleLabel.textColor = kWHITE
        self.titleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.regular)
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

extension HomeNewCell {
    
    func bind(_ webtoon: Webtoon) {
        self.titleLabel.text = webtoon.title
    }
    
}
