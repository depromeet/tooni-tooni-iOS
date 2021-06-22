//
//  GeneralNavigationView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/12.
//

import UIKit

class GeneralNavigationView: BaseCustomView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleLabelLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var bigTitleLabel: UILabel!

    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kCLEAR
    }
    
    func initButtons() {
        self.leftButton.isHidden = true
        self.subButton.isHidden = true
        self.rightButton.isHidden = true
    }
    
    func initLabels() {
        self.titleLabel.font = kBODY1_BOLD
        self.titleLabel.textColor = kGRAY_90
        self.titleLabel.textAlignment = .left
        self.titleLabel.text = nil

        self.bigTitleLabel.font = UIFont.systemFont(ofSize: 26.0, weight: UIFont.Weight.heavy)
        self.bigTitleLabel.textColor = kGRAY_90
        self.bigTitleLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initButtons()
        self.initLabels()
    }
    
}

// MARK: -

extension GeneralNavigationView {
    
    func leftButton(_ left: Bool) {
        self.titleLabelLeftConstraint.constant = left ? 60.0 : 20.0
    }
    
    func title(_ title: String?) {
        self.titleLabel.text = title
        self.bigTitleLabel.text = title
    }
    
    func bgColor(_ color: UIColor) {
        self.topView.backgroundColor = color
        self.baseView.backgroundColor = color
    }
    
    func bigTitle(_ bigTitle: Bool) {
        self.titleLabel.alpha = bigTitle ? 0.0 : 1.0
        self.bigTitleLabel.alpha = bigTitle ? 1.0 : 0.0
    }
    
}
