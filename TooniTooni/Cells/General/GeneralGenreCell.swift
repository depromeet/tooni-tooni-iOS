//
//  GeneralGenreCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/29.
//

import UIKit

let kGeneralGenreCellID =                                       "GeneralGenreCell"

class GeneralGenreCell: UICollectionViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
        self.baseView.layer.cornerRadius = 12.0
        self.baseView.layer.borderWidth = 1.0
        self.baseView.layer.borderColor = kGRAY_50.cgColor
        self.baseView.clipsToBounds = true
    }
    
    func initLabel() {
        self.titleLabel.textColor = kGRAY_50
        self.titleLabel.font = kCAPTION2_REGULAR
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

extension GeneralGenreCell {
    
    func bind(_ genre: String) {
        self.titleLabel.text = "#" + genre
    }
    
}
