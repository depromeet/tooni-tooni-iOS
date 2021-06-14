//
//  GeneralGenreView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/27.
//

import UIKit

class GeneralGenreView: BaseCustomView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
        self.baseView.layer.cornerRadius = 2.0
        self.baseView.clipsToBounds = true
        self.baseView.layer.borderWidth = 1.0
        self.baseView.layer.borderColor = kGRAY_90.cgColor
    }
    
    func initLabel() {
        self.titleLabel.textColor = kGRAY_90
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

extension GeneralGenreView {
    
    func bind(_ webtoon: Webtoon) {
        self.titleLabel.text = webtoon.genres?.first
    }
    
}
