//
//  WebtoonDetailScoreCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/29.
//

import UIKit
import Cosmos

let kWebtoonDetailScoreCellID =                                     "WebtoonDetailScoreCell"

class WebtoonDetailScoreCell: UITableViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var badgeView: GeneralBadgeView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.selectionStyle = .none
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kGRAY_90
        self.baseView.layer.cornerRadius = 8.0
        self.baseView.clipsToBounds = true
    }
    
    func initLabels() {
        self.titleLabel.textColor = kWHITE
        self.titleLabel.font = kBODY2_MEDIUM
        self.titleLabel.text = "평점"

        self.scoreLabel.textColor = kWHITE
        self.scoreLabel.font = kPOINT_BOLD_32
        self.scoreLabel.textAlignment = .center
        self.scoreLabel.text = nil
        
        self.infoLabel.textColor = UIColor.init(white: 1.0, alpha: 0.5)
        self.infoLabel.font = kCAPTION2_REGULAR
        self.infoLabel.textAlignment = .center
        self.infoLabel.text = "투니투니만의 평점이 곧 들어올 예정이에요!"
    }
    
    func initRatingView() {
        self.ratingView.settings.fillMode = .precise
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initLabels()
        self.initRatingView()
    }
    
}

// MARK: - Bind

extension WebtoonDetailScoreCell {
    
    func bind(_ webtoon: Webtoon) {
        self.badgeView.bind(webtoon)
        
        if let score = webtoon.score {
            self.scoreLabel.text = String.init(format: "%.2f", score)
            
            self.ratingView.rating = score / 2.0
        }
    }
    
}
