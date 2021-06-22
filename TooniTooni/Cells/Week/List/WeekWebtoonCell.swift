//
//  WeekWebtoonCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/27.
//

import UIKit
import Kingfisher

let kWeekWebtoonCellID =                                            "WeekWebtoonCell"

class WeekWebtoonCell: UICollectionViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var thumbView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var badgeView: GeneralBadgeView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
        
        self.thumbView.layer.cornerRadius = 5.0
        self.thumbView.clipsToBounds = true
    }
    
    func initImageView() {
        self.thumbImageView.backgroundColor = kGRAY_10
        self.thumbImageView.contentMode = .scaleAspectFill
    }
    
    func initLabels() {
        self.infoLabel.textColor = kWHITE
        self.infoLabel.font = kCAPTION2_BOLD
        self.infoLabel.text = nil

        self.titleLabel.textColor = kGRAY_90
        self.titleLabel.font = kCAPTION1_MEDIUM
        self.titleLabel.text = nil
        
        self.authorLabel.textColor = kGRAY_50
        self.authorLabel.font = kCAPTION2_REGULAR
        self.authorLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initImageView()
        self.initLabels()
    }
    
}

// MARK: - Bind

extension WeekWebtoonCell {
    
    func bind(_ webtoon: Webtoon) {
        self.titleLabel.text = webtoon.title
        self.authorLabel.text = webtoon.authors?.compactMap({ $0.name }).joined(separator: " / ")
        
        if let image = webtoon.thumbnail { //}?.replacingOccurrences(of: "http://", with: "https://") {
            self.thumbImageView.kf.setImage(with: URL.init(string: image),
                                           placeholder: nil,
                                           options: [.transition(.fade(0.25))], completionHandler: nil)
        }
        
        if let score = webtoon.score {
            self.infoLabel.text = String.init(format: "%.2f", score)
        }
        
        self.badgeView.bind(webtoon)
    }
    
}
