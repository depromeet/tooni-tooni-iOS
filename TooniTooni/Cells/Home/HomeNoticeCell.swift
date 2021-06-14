//
//  HomeNoticeCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/28.
//

import UIKit

let kHomeNoticeCellID =                                             "HomeNoticeCell"

class HomeNoticeCell: UICollectionViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var cropView: GeneralCloverView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
    }
    
    func initLabels() {
        self.nameLabel.textColor = kWHITE
        self.nameLabel.font = kCAPTION1_REGULAR
        self.nameLabel.text = "투니투니"

        self.captionLabel.textColor = kWHITE
        self.captionLabel.font = kHEADING2_BOLD
        self.captionLabel.text = nil

        self.titleLabel.textColor = kWHITE
        self.titleLabel.font = kHEADING1_BOLD
        self.titleLabel.text = nil
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initLabels()
    }
    
}

// MARK: - Bind

extension HomeNoticeCell {
    
    func bind(_ homeBanner: HomeBanner) {        
        if let caption = homeBanner.caption {
            self.captionLabel.attributedText = caption.style(changeText: caption,
                                                   lineSpacing: 3.0)
        }
        
        if let title = homeBanner.webtoon?.title {
            self.titleLabel.text = title
        }
        
        if let image = homeBanner.webtoon?.thumbnail { //?.replacingOccurrences(of: "http://", with: "https://") {
            self.bgImageView.kf.setImage(with: URL.init(string: image),
                                           placeholder: nil,
                                           options: [.transition(.fade(0.25))], completionHandler: nil)
        }
        
        self.cropView.bind(homeBanner.webtoon)
        
        self.starImageView.rotate(duration: 10.0, repeatCount: 0)
    }
    
}
