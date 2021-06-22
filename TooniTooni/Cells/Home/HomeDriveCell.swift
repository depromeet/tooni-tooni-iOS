//
//  HomeGenreCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/27.
//

import UIKit

let kHomeDriveCellID =                                          "HomeDriveCell"

class HomeDriveCell: UITableViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var genreView: GeneralGenreView!
    @IBOutlet weak var webtoonView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var colorImageView: UIImageView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var badgeView: GeneralBadgeView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.backgroundView = UIView()
        self.backgroundView?.backgroundColor = kWHITE
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = UIColor(white: 0.98, alpha: 1.0)

        self.baseView.backgroundColor = .clear
    }
    
    func initImageViews() {
        self.webtoonView.layer.cornerRadius = 5.0
        self.webtoonView.clipsToBounds = true
        
        self.bgImageView.contentMode = .scaleAspectFill
        self.bgImageView.alpha = 0.5

        self.colorImageView.contentMode = .scaleToFill
        self.colorImageView.backgroundColor = kGRAY_90
        self.colorImageView.alpha = 0.8
        
        self.thumbImageView.clipsToBounds = true
        self.thumbImageView.contentMode = .scaleAspectFill
    }
    
    func initLabels() {
        self.titleLabel.textColor = kGRAY_90
        self.titleLabel.font = kBODY2_MEDIUM
        self.titleLabel.textAlignment = .center
        self.titleLabel.text = nil
        
        self.infoLabel.textColor = kWHITE
        self.infoLabel.font = kCAPTION2_BOLD
        self.infoLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initImageViews()
        self.initLabels()
    }
    
}

// MARK: - Bind

extension HomeDriveCell {
    
    func bind(_ webtoon: Webtoon) {
        self.titleLabel.text = webtoon.title
        
        if let color = webtoon.backgroundColor {
            self.colorImageView.image = UIImage.imageFromColor(UIColor.init(hex: color))
            self.colorImageView.alpha = 0.9
        }
        
        if let image = webtoon.thumbnail { //}?.replacingOccurrences(of: "http://", with: "https://") {
            self.bgImageView.kf.setImage(with: URL.init(string: image),
                                           placeholder: nil,
                                           options: [.transition(.fade(0.25))], completionHandler: nil)
            
            self.thumbImageView.kf.setImage(with: URL.init(string: image),
                                           placeholder: nil,
                                           options: [.transition(.fade(0.25))], completionHandler: nil)
        }
        
        if let score = webtoon.score {
            self.infoLabel.text = String.init(format: "%.2f", score)
        }
        
        self.badgeView.bind(webtoon)
        self.genreView.bind(webtoon)
    }
    
}
