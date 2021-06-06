//
//  CommentCell.swift
//  TooniTooni
//
//  Created by buzz on 2021/05/30.
//

import UIKit

class CommentCell: UITableViewCell {

  @IBOutlet var nicknameLabel: UILabel!
  @IBOutlet var dateLabel: UILabel!
  @IBOutlet var commentLabel: UILabel!
  @IBOutlet var reportButton: UIButton!
  @IBOutlet var deleteButton: UIButton!

  var didTapReport: ((UIButton) -> Void)?
  var didTapDelete: ((UIButton) -> Void)?

  override func awakeFromNib() {
    super.awakeFromNib()

    setupUI()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

  private func setupUI() {
    nicknameLabel.font = kCAPTION2_BOLD
    nicknameLabel.textColor = kGRAY_80
    nicknameLabel.text = nil

    dateLabel.font = kCAPTION2_REGULAR
    dateLabel.textColor = kGRAY_30
    dateLabel.text = nil

    commentLabel.font = kBODY2_REGULAR
    commentLabel.textColor = kGRAY_80
    commentLabel.text = nil

    reportButton.titleLabel?.font = kCAPTION2_REGULAR
    reportButton.setTitleColor(kGRAY_50, for: .normal)
    reportButton.setTitle("신고", for: .normal)
    reportButton.sizeToFit()
    reportButton.addTarget(self, action: #selector(reportAction(_:)), for: .touchUpInside)

    deleteButton.titleLabel?.font = kCAPTION2_REGULAR
    deleteButton.setTitleColor(kGRAY_50, for: .normal)
    deleteButton.setTitle("삭제", for: .normal)
    deleteButton.sizeToFit()
    deleteButton.addTarget(self, action: #selector(deleteAction(_:)), for: .touchUpInside)
  }
}

extension CommentCell {

  func bind(_ comment: Comment) {
    nicknameLabel.text = comment.account.nickname
    dateLabel.text = comment.writeDate
    commentLabel.text = comment.content
  }

  @objc
  func reportAction(_ sender: UIButton) {
    didTapReport?(sender)
  }

  @objc
  func deleteAction(_ sender: UIButton) {
    didTapDelete?(sender)
  }
}
