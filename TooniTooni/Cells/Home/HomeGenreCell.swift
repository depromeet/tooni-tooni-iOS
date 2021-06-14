//
//  HomeGenreCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/15.
//

import UIKit

let kHomeGenreCellID =                                        "HomeGenreCell"

class HomeGenreCell: UICollectionViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var thumbView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var genreView: GeneralGenreView!
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
        self.thumbImageView.layer.cornerRadius = 4.0
        self.thumbImageView.clipsToBounds = true
        self.thumbImageView.backgroundColor = kGRAY_10
        self.thumbImageView.contentMode = .scaleAspectFill
    }
    
    func initLabel() {
        self.titleLabel.textColor = kGRAY_90
        self.titleLabel.font = kBODY2_MEDIUM
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
        self.initLabel()
    }
    
}

// MARK: - Bind

extension HomeGenreCell {
    
    func bind(_ webtoon: Webtoon) {
        self.titleLabel.text = webtoon.title
        self.authorLabel.text = webtoon.authors?.compactMap({ $0.name }).joined(separator: " / ")
        
        if let image = webtoon.thumbnail { //}?.replacingOccurrences(of: "http://", with: "https://") {
            self.thumbImageView.kf.setImage(with: URL.init(string: image),
                                           placeholder: nil,
                                           options: [.transition(.fade(0.25))], completionHandler: nil)
        }
        
        self.genreView.bind(webtoon)
    }
    
}
