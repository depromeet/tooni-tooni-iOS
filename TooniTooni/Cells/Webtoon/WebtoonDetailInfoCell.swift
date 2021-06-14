//
//  WebtoonDetailInfoCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/29.
//

import UIKit

let kWebtoonDetailInfoCellID =                                      "WebtoonDetailInfoCell"

protocol WebtoonDetailInfoCellDelegate: AnyObject {
    func didFavoriteWebtoonDetailInfoCell(cell: WebtoonDetailInfoCell)
}

class WebtoonDetailInfoCell: UITableViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var genreView: GeneralGenreListView!
    @IBOutlet weak var genreViewHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: WebtoonDetailInfoCellDelegate?
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
    }
    
    func initLabels() {
        self.titleLabel.textColor = kGRAY_90
        self.titleLabel.font = kHEADING2_BOLD
        self.titleLabel.numberOfLines = 0
        self.titleLabel.text = nil
        
        self.authorLabel.textColor = kGRAY_90
        self.authorLabel.font = kBODY2_MEDIUM
        self.authorLabel.numberOfLines = 0
        self.authorLabel.text = nil
        
        self.descLabel.textColor = kGRAY_50
        self.descLabel.font = kBODY2_REGULAR
        self.descLabel.numberOfLines = 0
        self.descLabel.text = nil
    }
    
    func initButton() {
        self.favoriteButton.addTarget(self, action: #selector(doFavorite), for: .touchUpInside)
    }
    
    func initGenreView() {
        self.genreViewHeightConstraint.constant = 60.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initLabels()
        self.initButton()
        self.initGenreView()
    }
    
}

// MARK: - Event

extension WebtoonDetailInfoCell {
    
    @objc
    func doFavorite() {
        self.delegate?.didFavoriteWebtoonDetailInfoCell(cell: self)
    }
    
}

// MARK: - Bind

extension WebtoonDetailInfoCell {
    
    func bind(_ webtoon: Webtoon) {
        if let title = webtoon.title {
            self.titleLabel.attributedText = title.style(changeText: title,
                                                         lineSpacing: 3.0)
        }
        
        self.authorLabel.text = webtoon.authors?.compactMap({ $0.name }).joined(separator: " / ")
        print("webtoon.authors: \(webtoon.authors)")
        if let desc = webtoon.summary {
            self.descLabel.attributedText = desc.style(changeText: desc,
                                                       lineSpacing: 3.0)
        }
        
        if let genre = webtoon.genres, genre.count > 0 {
            self.genreView.bind(webtoon)
            self.genreViewHeightConstraint.constant = 60.0
        }
        
        if GeneralHelper.sharedInstance.existFavorite(webtoon) {
            self.favoriteButton.setImage(UIImage.init(named: "icon_favorite"), for: .normal)
        }
        else {
            self.favoriteButton.setImage(UIImage.init(named: "icon_heart"), for: .normal)
        }
    }
    
}
