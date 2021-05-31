//
//  CommentWritingView.swift
//  TooniTooni
//
//  Created by buzz on 2021/05/30.
//

import UIKit

class CommentWritingView: BaseCustomView {

  // MARK: - Vars

  @IBOutlet var baseView: UIView!
  @IBOutlet var inputTextView: UITextView!
  @IBOutlet var sendButton: UIButton!
  @IBOutlet var baseViewHeightConstraints: NSLayoutConstraint!

  var send: ((UIButton) -> Void)?

  // MARK: - Life Cycle

  override func awakeFromNib() {
    super.awakeFromNib()
    setupUI()
  }

  private func setupUI() {
    //textView
    textViewSetupView()

    // send button
    sendButton.addTarget(self, action: #selector(send(sender:)), for: .touchUpInside)
  }

  func textViewSetupView() {
    inputTextView.delegate = self

    if inputTextView.text == "투니의 의견을 작성해주세요 :)" {
      inputTextView.text = ""
      inputTextView.textColor = kGRAY_80

    } else if inputTextView.text == "" {
      inputTextView.text = "투니의 의견을 작성해주세요 :)"
      inputTextView.textColor = kGRAY_50
    }
  }
}

// MARK: - Event

extension CommentWritingView {

  @objc
  func send(sender: UIButton) {
    send?(sender)
  }
}

// MARK: - UITextView

extension CommentWritingView: UITextViewDelegate {

  func textViewDidBeginEditing(_ textView: UITextView) {
    textViewSetupView()
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == "" {
      textViewSetupView()
    }
  }

  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

    if text == "\n" {
      textView.resignFirstResponder()
    }
    return true
  }
}
