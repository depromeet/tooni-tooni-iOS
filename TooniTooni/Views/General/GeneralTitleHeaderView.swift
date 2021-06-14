//
//  GeneralTitleHeaderView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/27.
//

import UIKit

let kGeneralTitleHeaderViewID =                                     "GeneralTitleHeaderView"

protocol GeneralTitleHeaderViewDelegate: AnyObject {
    func didMoreGeneralTitleHeaderView(view: GeneralTitleHeaderView)
}

class GeneralTitleHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    
    weak var delegate: GeneralTitleHeaderViewDelegate?
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
    }
    
    func initLabel() {
        self.titleLabel.textColor = kGRAY_90
        self.titleLabel.font = kHEADING3_BOLD
        self.titleLabel.text = nil
    }
    
    func initMoreView() {
        self.moreView.isHidden = true
        
        self.moreLabel.textColor = kGRAY_50
        self.moreLabel.font = kCAPTION1_REGULAR
        self.moreLabel.text = "+ 더보기"
        
        self.moreButton.addTarget(self, action: #selector(doMore), for: .touchUpInside)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initLabel()
        self.initMoreView()
    }
    
}

// MARK: - Event

extension GeneralTitleHeaderView {
    
    @objc
    func doMore() {
        self.delegate?.didMoreGeneralTitleHeaderView(view: self)
    }
    
}

// MARK: - Bind

extension GeneralTitleHeaderView {
    
    func bind(_ title: String?) {
        self.titleLabel.text = title
    }
    
    func more(_ more: Bool) {
        self.moreView.isHidden = !more
    }
    
}
