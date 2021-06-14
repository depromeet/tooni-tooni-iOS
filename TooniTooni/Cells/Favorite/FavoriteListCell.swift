//
//  FavoriteListCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/29.
//

import UIKit

let kFavoriteListCellID =                                "FavoriteListCell"

protocol FavoriteListCellDelegate: AnyObject {
    func didEventFavoriteListCell(cell: FavoriteListCell)
}

class FavoriteListCell: UITableViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var badgeView: GeneralBadgeView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var eventButton: UIButton!
    
    var type: FavoriteListViewType!
    
    weak var delegate: FavoriteListCellDelegate?
    
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
    
    func initImageView() {
        self.thumbImageView.layer.cornerRadius = 5.0
        self.thumbImageView.clipsToBounds = true
        self.thumbImageView.backgroundColor = kGRAY_10
        self.thumbImageView.contentMode = .scaleAspectFill
    }
    
    func initLabels() {
        self.titleLabel.textColor = kGRAY_90
        self.titleLabel.font = kBODY2_MEDIUM
        self.titleLabel.text = nil
        
        self.authorLabel.textColor = kGRAY_50
        self.authorLabel.font = kCAPTION2_REGULAR
        self.authorLabel.text = nil
        
        self.infoLabel.textColor = kGRAY_80
        self.infoLabel.font = kCAPTION2_REGULAR
        self.infoLabel.text = nil
        
        self.scoreLabel.textColor = kGRAY_80
        self.scoreLabel.font = kCAPTION2_BOLD
        self.scoreLabel.text = nil
    }
    
    func initBadgeView() {
        self.badgeView.layer.cornerRadius = 2.0
        self.badgeView.clipsToBounds = true
    }
    
    func initButton() {
        self.eventButton.addTarget(self, action: #selector(doEvent), for: .touchUpInside)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initImageView()
        self.initLabels()
        self.initBadgeView()
        self.initButton()
    }
    
}

// MARK: - Event

extension FavoriteListCell {

    @objc
    func doEvent() {
        self.delegate?.didEventFavoriteListCell(cell: self)
    }
    
}

// MARK: - Bind

extension FavoriteListCell {
    
    func bind(_ webtoon: Webtoon, _ type: FavoriteListViewType) {
        self.type = type
        
        self.eventButton.setImage(UIImage.init(named: type == .recents ? "icon_delete" : "icon_favorite"), for: .normal)
        
        self.titleLabel.text = webtoon.title
        self.authorLabel.text = webtoon.authors?.compactMap({ $0.name }).joined(separator: " / ")
        
        if let image = webtoon.thumbnail { //?.replacingOccurrences(of: "http://", with: "https://") {
            self.thumbImageView.kf.setImage(with: URL.init(string: image),
                                           placeholder: nil,
                                           options: [.transition(.fade(0.25))], completionHandler: nil)
        }
        
        let infoString = webtoon.genres?.joined(separator: " | ")
        self.infoLabel.text = infoString

        self.badgeView.bind(webtoon)
        
        if let score = webtoon.score {
            self.scoreLabel.text = String.init(format: "%.2f", score)
        }
    }
    
}
