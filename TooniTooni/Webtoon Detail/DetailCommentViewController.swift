//
//  DetailCommentViewController.swift
//  TooniTooni
//
//  Created by buzz on 2021/05/28.
//

import UIKit

class DetailCommentViewController: BaseViewController {

  // MARK: - Constant

  private enum Metric {
    static let maxMenuViewTopConstraint: CGFloat = 114
    static let bottomConstraints: CGFloat = 20
    static let inputViewContentSizeMaxHeight: CGFloat = 80
    static let headerHeight: CGFloat = 32
  }

  let placeholder = "투니의 의견을 작성해주세요 :)"

  // MARK: - Vars

  @IBOutlet var mainTableView: UITableView!
  @IBOutlet var activity: GeneralActivity!
  @IBOutlet var inputViewContainer: UIView!
  @IBOutlet var inputViewContainerBottomConstraints: NSLayoutConstraint!
  @IBOutlet var inputTextView: UITextView!
  @IBOutlet var inputTextViewHeightConstraints: NSLayoutConstraint!
  @IBOutlet var sendButton: UIButton!

  var didScroll: ((_ scrollView: UIScrollView) -> Void)?
  var pageSize: Int = 10
  var webtoon: Webtoon?
  var commentItem: CommentItem? {
    didSet {
      DispatchQueue.main.async {
        self.mainTableView.reloadData()
        self.stopActivity()
      }
    }
  }

  // MARK: - Life Cycle

  func initVars() {
    showBigTitle = false
  }

  func initTableView() {
    let commentCell = UINib(nibName: CommentCell.reuseIdentifier, bundle: nil)
    mainTableView.register(commentCell, forCellReuseIdentifier: CommentCell.reuseIdentifier)

    mainTableView.dataSource = self
    mainTableView.delegate = self
    mainTableView.separatorStyle = .none
    mainTableView.rowHeight = UITableView.automaticDimension
    mainTableView.estimatedRowHeight = 100.0
    mainTableView.showsHorizontalScrollIndicator = false
    mainTableView.showsVerticalScrollIndicator = false
    mainTableView.keyboardDismissMode = .onDrag
  }

  func initInputTextView() {
    inputTextView.delegate = self

    if inputTextView.text == placeholder {
      inputTextView.text = ""
      inputTextView.textColor = kGRAY_80
    } else if inputTextView.text == "" {
      inputTextView.text = placeholder
      inputTextView.textColor = kGRAY_50
    }
  }

  func initSendButton() {
    sendButton.addTarget(self, action: #selector(sendButton(_:)), for: .touchUpInside)
  }

  func keyboardObserver() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(textViewMoveUp),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(textViewMoveDown),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  func removeObserver() {
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.removeObserver(
      self,
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    initSwipePop()
    initVars()
    initTableView()
    initInputTextView()
    initSendButton()
    keyboardObserver()

    startActivity()
    fetchComment(pageSize: pageSize)
  }

  deinit {
    removeObserver()
  }
}

// MARK: - Event

extension DetailCommentViewController {

  @objc
  func textViewMoveUp(_ notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      UIView.animate(withDuration: 0.25, animations: {
        self.inputViewContainerBottomConstraints.constant = keyboardSize.height
      })
    }
  }

  @objc
  func textViewMoveDown(_ notification: NSNotification) {
    UIView.animate(withDuration: 0.25, animations: {
      self.inputViewContainerBottomConstraints.constant = Metric.bottomConstraints
    })
  }

  @objc
  func sendButton(_ sender: UIButton) {
    guard !inputTextView.text.isEmpty && inputTextView.text != placeholder else { return }
    print(sender)

    startActivity()
    if let webtoon = webtoon {
      TooniNetworkService.shared.request(to: .writeComment(webtoon.id, inputTextView.text), decoder: String.self) { [weak self] response in
        guard let self = self else { return }
        print(response)

        self.inputTextView.text = ""
        self.inputTextView.resignFirstResponder()
        self.didChangeSendButton(by: self.inputTextView)

        self.fetchComment(pageSize: self.pageSize) { _ in
          self.stopActivity()
        }
      }
    }
  }
}

// MARK: - Helper method

extension DetailCommentViewController {

  func fetchComment(pageSize: Int, completion: ((Bool) -> Void)? = nil) {
    guard let webtoon = webtoon else { return }

    TooniNetworkService.shared.request(to: .readComment("\(webtoon.id)", "\(pageSize)"), decoder: CommentItem.self) { [weak self] response in
      switch response.result {
      case .success:
        guard let commentItem = response.json as? CommentItem else { return }
        self?.commentItem = commentItem
        completion?(true)
      case .failure:
        print(response)
        completion?(false)
      }
    }
  }

  func didChangeSendButton(by textView: UITextView) {
    if textView.text.isEmpty || inputTextView.text == placeholder {
      sendButton.backgroundColor = kGRAY_10
      sendButton.tintColor = kBLACK
    } else {
      sendButton.backgroundColor = kGRAY_80
      sendButton.tintColor = kWHITE
    }
  }
}

// MARK: - UITableView

extension DetailCommentViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return commentItem?.commentResponse?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier, for: indexPath) as? CommentCell {

      if let commentItem = commentItem,
         let comment = commentItem.commentResponse?[indexPath.row] {
        cell.bind(comment)

        cell.didTapReport = { button in

        }

        cell.didTapDelete = { button in
          self.startActivity()
          TooniNetworkService.shared.request(to: .deleteComment(comment.commentId), decoder: String.self) { [weak self] response in
            guard let self = self else { return }

            switch response.result {
            case .success:
              self.fetchComment(pageSize: self.pageSize)
            case .failure:
              print(response)
            }
          }
        }
      }

      return cell
    }

    return .init()
  }
}

extension DetailCommentViewController: UITableViewDelegate {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    didScroll?(scrollView)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Metric.headerHeight
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    if indexPath.row == pageSize - 1 {
      pageSize += 10
      startActivity()
      fetchComment(pageSize: pageSize)
    }
  }
}

// MARK: - UITextView

extension DetailCommentViewController: UITextViewDelegate {

  func textViewDidBeginEditing(_ textView: UITextView) {
    initInputTextView()
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text == "" {
      initInputTextView()
    }
  }

  func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {

    if text == "\n" {
      textView.resignFirstResponder()
    }

    return true
  }

  func textViewDidChange(_ textView: UITextView) {
    guard textView.contentSize.height <= Metric.inputViewContentSizeMaxHeight else { return }

    inputTextViewHeightConstraints.constant = textView.contentSize.height

    didChangeSendButton(by: textView)
  }
}

// MARK: - Activity

extension DetailCommentViewController {

  func startActivity() {
    if activity.isAnimating() { return }
    activity.start()
  }

  func stopActivity() {
    if !activity.isAnimating() { return }
    activity.stop()
  }
}

// MARK: - Gestrue recognizer

extension DetailCommentViewController: UIGestureRecognizerDelegate {

  func initSwipePop() {
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}
