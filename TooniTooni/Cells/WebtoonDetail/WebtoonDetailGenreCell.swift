//
//  WebtoonDetailGenreCell.swift
//  TooniTooni
//
//  Created by buzz on 2021/05/29.
//

import UIKit

class WebtoonDetailGenreCell: UICollectionViewCell {

  @IBOutlet var baseView: UIView!
  @IBOutlet var titleLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }

  private func setupUI() {
    baseView.layer.cornerRadius = 12
    baseView.layer.borderWidth = 1
    baseView.layer.borderColor = kGRAY_50.cgColor

    titleLabel.font = kCAPTION2_REGULAR
    titleLabel.textColor = kGRAY_50
    titleLabel.text = nil
  }
}

extension WebtoonDetailGenreCell {

  func bind(_ genre: String) {
    titleLabel.text = "#\(genre)"
  }
}
