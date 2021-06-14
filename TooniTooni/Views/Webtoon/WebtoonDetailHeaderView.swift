//
//  WebtoonDetailHeaderView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/30.
//

import UIKit

protocol WebtoonDetailHeaderViewDelegate: AnyObject {
    func didBackWebtoonDetailHeaderView(view: WebtoonDetailHeaderView)
    func didMenuWebtoonDetailHeaderView(view: WebtoonDetailHeaderView, idx: Int)
}

class WebtoonDetailHeaderView: BaseCustomView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var navigationView: GeneralNavigationView!
    @IBOutlet weak var navigationViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var badgeView: GeneralBadgeView!
    @IBOutlet weak var weekLabel: UILabel!
    @IBOutlet weak var coneView: GeneralConeView!
    @IBOutlet weak var menuView: GeneralMenuView!
    @IBOutlet weak var cloudImageView: UIImageView!
    @IBOutlet weak var bigStarImageView: UIImageView!
    @IBOutlet weak var smallStarImageView: UIImageView!
    
    var selectedIdx = 0
    
    weak var delegate: WebtoonDetailHeaderViewDelegate?
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kGRAY_90
    }
    
    func initNavigationView() {
        self.navigationView.bgColor(kCLEAR)
        self.navigationView.title(nil)
        self.navigationView.bigTitle(false)
        
        self.navigationView.leftButton.isHidden = false
        self.navigationView.leftButton.setImage(UIImage.init(named: "icon_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.navigationView.leftButton.tintColor = kWHITE
        self.navigationView.leftButton.addTarget(self, action: #selector(doBack), for: .touchUpInside)
    }
    
    func initTopView() {
        self.topView.backgroundColor = kGRAY_90
    }
    
    func initLabel() {
        self.weekLabel.font = kCAPTION1_REGULAR
        self.weekLabel.text = nil
    }
    
    func initMenuView() {
        self.menuView.bind(self.selectedIdx, ["투니 홈", "투니 댓글"])
        self.menuView.delegate = self
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initNavigationView()
        self.initTopView()
        self.initLabel()
        self.initMenuView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.navigationViewTopConstraint.constant = kDEVICE_TOP_AREA
    }
    
}

// MARK: - Event

extension WebtoonDetailHeaderView {
    
    @objc
    func doBack() {
        self.delegate?.didBackWebtoonDetailHeaderView(view: self)
    }
    
}

// MARK: - WebtoonDetailHeaderView

extension WebtoonDetailHeaderView {
    
    func bind(_ webtoon: Webtoon) {
        if let site = webtoon.site {
            self.menuView.color(site.siteColor)
            self.weekLabel.textColor = site.siteColor
        }
        
        self.badgeView.bind(webtoon)
        
        if let week = webtoon.weekday?.first {
            self.weekLabel.text = week.weekString + "요일"
        }
        
        self.coneView.bind(webtoon)
        
        self.cloudImageView.bounce(duration: 2.0, repeatCount: 0)
        self.bigStarImageView.rotate(duration: 10.0, repeatCount: 0)
        self.smallStarImageView.rotate(duration: 5.0, repeatCount: 0)
    }
    
}

// MARK: - GeneralMenuView

extension WebtoonDetailHeaderView: GeneralMenuViewDelegate {
    
    func didMenuGeneralMenuView(view: GeneralMenuView, idx: Int) {
        self.selectedIdx = idx
        self.delegate?.didMenuWebtoonDetailHeaderView(view: self, idx: idx)
    }
    
}
