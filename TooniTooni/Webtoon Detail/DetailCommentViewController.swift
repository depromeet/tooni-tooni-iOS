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

  // MARK: - Vars

  @IBOutlet var mainTableView: UITableView!
  @IBOutlet var activity: GeneralActivity!
  @IBOutlet var inputViewContainer: UIView!
  @IBOutlet var inputViewContainerBottomConstraints: NSLayoutConstraint!
  @IBOutlet var inputTextView: UITextView!
  @IBOutlet var inputTextViewHeightConstraints: NSLayoutConstraint!
  @IBOutlet var sendButton: UIButton!

  let placeholder = "투니의 의견을 작성해주세요 :)"
  var didScroll: ((_ scrollView: UIScrollView) -> Void)?
  var webtoon: Webtoon?
  var webtoonDetail: WebtoonDetail? {
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
    if !isEmpty(inputTextView) {
      sendButton.backgroundColor = kGRAY_80
      sendButton.tintColor = kWHITE
    } else {
      sendButton.backgroundColor = kGRAY_10
      sendButton.tintColor = kBLACK
    }
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
    fetchDetail(with: webtoon)
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
}

// MARK: - Helper method

extension DetailCommentViewController {

  func fetchDetail(with webtoon: Webtoon?) {
    guard let webtoon = webtoon else { return }
    TooniNetworkService.shared.request(to: .webtoonDetail("\(webtoon.id)"), decoder: WebtoonDetail.self) { [weak self] response in
      switch response.result {
      case .success:
        guard let webtoonDetail = response.json as? WebtoonDetail else { return }
        self?.webtoonDetail = webtoonDetail
      case .failure:
        print(response)
      }
    }
  }

  func isEmpty(_ textView: UITextView) -> Bool {
    guard let text = textView.text,
          !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
      return false
    }

    return true
  }
}

// MARK: - UITableView

extension DetailCommentViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return webtoonDetail?.comments.count ?? 0
    return 10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier, for: indexPath) as? CommentCell {

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
    initSendButton()

    if text == "\n" {
      textView.resignFirstResponder()
    }

    return true
  }

  func textViewDidChange(_ textView: UITextView) {
    guard textView.contentSize.height <= Metric.inputViewContentSizeMaxHeight else { return }

    inputTextViewHeightConstraints.constant = textView.contentSize.height
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
