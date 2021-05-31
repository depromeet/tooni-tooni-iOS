//
//  WebtoonDetailInfoCell.swift
//  TooniTooni
//
//  Created by buzz on 2021/05/29.
//

import UIKit

class WebtoonDetailInfoCell: UITableViewCell {

  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var favoriteButton: UIButton!
  @IBOutlet var authorLabel: UILabel!
  @IBOutlet var summaryLabel: UILabel!
  @IBOutlet var genreCollectionView: UICollectionView!
  @IBOutlet var ratingContainerView: UIView!
  @IBOutlet var badgeView: GeneralBadgeView!
  @IBOutlet var ratingTitle: UILabel!
  @IBOutlet var ratingValueLabel: UILabel!
  @IBOutlet var comingsoonLabel: UILabel!

  var webtoonDetail: WebtoonDetail? {
    didSet {
      DispatchQueue.main.async {
        self.genreCollectionView.reloadData()
      }
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  private func setupUI() {
    selectionStyle = .none
    initGenreCollectionView()

    titleLabel.font = kHEADING2_BOLD
    titleLabel.textColor = kGRAY_90
    titleLabel.text = nil

    authorLabel.font = kBODY2_MEDIUM
    authorLabel.textColor = kBLACK
    authorLabel.text = nil

    summaryLabel.font = kBODY2_REGULAR
    summaryLabel.textColor = kGRAY_50
    summaryLabel.numberOfLines = 0
    summaryLabel.text = nil

    ratingContainerView.layer.cornerRadius = 8
    ratingContainerView.clipsToBounds = true

    ratingTitle.font = kBODY2_MEDIUM
    ratingTitle.textColor = kWHITE
    ratingTitle.text = "투니 평점"

    ratingValueLabel.font = kHEADING1_BOLD
    ratingValueLabel.textColor = kWHITE
    ratingValueLabel.text = nil

    comingsoonLabel.font = kCAPTION2_REGULAR
    comingsoonLabel.textColor = kGRAY_50
    comingsoonLabel.text = "투니투니만의 평점이 곧 들어올 예정이에요!"
  }

  func initGenreCollectionView() {
    let genreCell = UINib.init(nibName: WebtoonDetailGenreCell.reuseIdentifier, bundle: nil)
    genreCollectionView.register(genreCell, forCellWithReuseIdentifier: WebtoonDetailGenreCell.reuseIdentifier)

    let layout = UICollectionViewFlowLayout.init()
    layout.scrollDirection = .horizontal
    layout.estimatedItemSize = CGSize(width: 50, height: 24)
    layout.minimumLineSpacing = 8.0
    layout.minimumInteritemSpacing = 8.0
    layout.headerReferenceSize = .zero
    layout.footerReferenceSize = .zero

    self.genreCollectionView.delegate = self
    self.genreCollectionView.dataSource = self
    self.genreCollectionView.backgroundColor = kWHITE
    self.genreCollectionView.showsVerticalScrollIndicator = false
    self.genreCollectionView.showsHorizontalScrollIndicator = false
    self.genreCollectionView.alwaysBounceHorizontal = false
    self.genreCollectionView.alwaysBounceVertical = false
    self.genreCollectionView.collectionViewLayout = layout
  }
}

extension WebtoonDetailInfoCell {

  func bind(_ webtoonDetail: WebtoonDetail) {
    self.webtoonDetail = webtoonDetail

    titleLabel.text = webtoonDetail.webtoon?.title
    authorLabel.text = webtoonDetail.webtoon?.authors?.compactMap { $0.name }.joined(separator: " / ")
    summaryLabel.text = webtoonDetail.webtoon?.summary
    badgeView.bind(webtoonDetail.webtoon?.site)
    ratingValueLabel.text = "\(webtoonDetail.webtoon?.score ?? 0.0)"
  }
}

// MARK: - UICollectionView

extension WebtoonDetailInfoCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let webtoonDetail = self.webtoonDetail,
              let genres = webtoonDetail.webtoon?.genres else { return 0 }

      return genres.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let webtoonDetail = self.webtoonDetail,
            let genres = webtoonDetail.webtoon?.genres else { return .init() }

      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WebtoonDetailGenreCell.reuseIdentifier, for: indexPath) as? WebtoonDetailGenreCell {
            let genre = genres[indexPath.row]

        cell.bind(genre)

            return cell
        }

        return .init()
    }
}
