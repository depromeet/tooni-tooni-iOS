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
  }

  // MARK: - Vars

  @IBOutlet weak var mainTableView: UITableView!
  @IBOutlet weak var activity: GeneralActivity!
  @IBOutlet weak var commentWritingView: CommentWritingView!
  @IBOutlet weak var commentWritingViewBottomConstraints: NSLayoutConstraint!

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
    mainTableView.contentInset.bottom += Metric.maxMenuViewTopConstraint
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

    initVars()
    initTableView()
    keyboardObserver()

    startActivity()
    fetchDetail(with: webtoon)
  }

  deinit {
    removeObserver()
  }
}

// MARK: - Event {

extension DetailCommentViewController {

  @objc
  func textViewMoveUp(_ notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
      UIView.animate(withDuration: 0.25, animations: {
        self.commentWritingViewBottomConstraints.constant = keyboardSize.height
      })
    }
  }

  @objc
  func textViewMoveDown(_ notification: NSNotification) {
    UIView.animate(withDuration: 0.25, animations: {
      self.commentWritingViewBottomConstraints.constant = Metric.bottomConstraints
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
