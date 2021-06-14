//
//  SearchNoneFooterView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/06.
//

import UIKit

let kSearchNoneFooterViewID =                                   "SearchNoneFooterView"

protocol SearchNoneFooterViewDelegate: AnyObject {
    func didRefreshSearchNoneFooterView(view: SearchNoneFooterView)
}

class SearchNoneFooterView: UICollectionReusableView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var refreshButton: UIButton!
    
    weak var delegate: SearchNoneFooterViewDelegate?
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
        
        self.titleView.backgroundColor = kGRAY_90
        self.titleView.layer.cornerRadius = 22.0
        self.titleView.clipsToBounds = true
    }
    
    func initLabel() {
        self.titleLabel.textColor = kWHITE
        self.titleLabel.font = kBODY1_REGULAR
        self.titleLabel.text = "이런 웹툰 어때요?"
        self.titleLabel.textAlignment = .center
    }
    
    func initButton() {
        self.refreshButton.addTarget(self, action: #selector(doRefresh), for: .touchUpInside)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initLabel()
        self.initButton()
    }
    
}

// MARK: - Event

extension SearchNoneFooterView {
    
    @objc
    func doRefresh() {
        self.delegate?.didRefreshSearchNoneFooterView(view: self)
    }
    
}
