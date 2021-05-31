//
//  GeneralTitleRightDetailHeaderView.swift
//  TooniTooni
//
//  Created by buzz on 2021/05/28.
//

import UIKit

class GeneralTitleRightDetailHeaderView: UITableViewHeaderFooterView {

  // MARK: - Vars

  @IBOutlet weak var baseView: UIView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var detailButton: UIButton!

  // MARK: - Life Cycle

  func initVars() {
      self.clipsToBounds = true
  }

  func initBackgroundView() {
      self.baseView.backgroundColor = kWHITE
  }

  func initLabel() {
      self.titleLabel.textColor = kGRAY_90
      self.titleLabel.font = kHEADING3_BOLD
      self.titleLabel.text = nil
  }

  func initButton() {
      self.detailButton.titleLabel?.font = kBODY2_REGULAR
      self.detailButton.setTitleColor(kGRAY_30, for: .normal)
      self.detailButton.setTitle(nil, for: .normal)
  }

  override func awakeFromNib() {
      super.awakeFromNib()

      self.initVars()
      self.initBackgroundView()
      self.initLabel()
      self.initButton()
  }

}

// MARK: - Bind

extension GeneralTitleRightDetailHeaderView {

  func bind(_ title: String?, detailImage: UIImage? = nil, detailTitle: String? = nil) {
      self.titleLabel.text = title
      self.detailButton.setImage(detailImage, for: .normal)
      self.detailButton.setTitle(detailTitle, for: .normal)
  }

}
