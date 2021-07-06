//
//  WebtoonDetailViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/29.
//

import SafariServices
import UIKit

enum WebtoonDetailViewType: Int {
  case info
  case score
  case comments
  case recommend

  static let count = 4
}

let kWEBTOON_DETAIL_HEADER_HEIGHT: CGFloat = 252.0

class WebtoonDetailViewController: BaseViewController {

  // MARK: - Vars

  @IBOutlet var hideNavigationView: GeneralNavigationView!
  @IBOutlet var hideNavigationViewTopConstraint: NSLayoutConstraint!
  @IBOutlet var hideNavigationViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet var headerView: WebtoonDetailHeaderView!
  @IBOutlet var headerViewTopConstraint: NSLayoutConstraint!
  @IBOutlet var headerViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet var mainTableView: UITableView!
  @IBOutlet var commentView: WebtoonDetailCommentView!
  @IBOutlet var commentViewBottomConstraint: NSLayoutConstraint!
  @IBOutlet var portalView: UIView!
  @IBOutlet var portalButton: UIButton!
  @IBOutlet var portalLabel: UILabel!
  @IBOutlet var portalButtonHeightConstraint: NSLayoutConstraint!
  @IBOutlet var portalButtonBottomConstraint: NSLayoutConstraint!
  @IBOutlet var activity: CustomActivity!

  var selectedIdx = 0
  var showHideNavigationView = false

  var webtoonItem: Webtoon!
  var webtoonDetailItem: WebtoonDetail?

  var commentList: [Comment]?

  // MARK: - Life Cycle

  func initVars() {
    showBigTitle = false
  }

  func initBackgroundView() {
    view.backgroundColor = kWHITE
  }

  func initNavigationView() {
    hideNavigationView.bgColor(kWHITE)
    hideNavigationView.title(webtoonItem.title)
    hideNavigationView.bigTitle(false)
    hideNavigationView.leftButton(true)
    hideNavigationView.alpha = 0.0

    hideNavigationView.leftButton.isHidden = false
    hideNavigationView.leftButton.setImage(UIImage(named: "icon_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
    hideNavigationView.leftButton.tintColor = kGRAY_90
    hideNavigationView.leftButton.addTarget(self, action: #selector(doBack), for: .touchUpInside)

    hideNavigationViewHeightConstraint.constant = 44.0 + kDEVICE_TOP_AREA
    hideNavigationViewTopConstraint.constant = -hideNavigationViewHeightConstraint.constant - kDEVICE_TOP_AREA
  }

  func initHeaderView() {
    headerView.bind(webtoonItem)
    headerView.delegate = self
    headerView.alpha = 0.0

    view.layoutIfNeeded()
    headerViewHeightConstraint.constant = kWEBTOON_DETAIL_HEADER_HEIGHT
  }

  func initTableView() {
    let headerView = UINib(nibName: kGeneralTitleHeaderViewID, bundle: nil)
    mainTableView.register(headerView, forHeaderFooterViewReuseIdentifier: kGeneralTitleHeaderViewID)

    let infoCell = UINib(nibName: kWebtoonDetailInfoCellID, bundle: nil)
    mainTableView.register(infoCell, forCellReuseIdentifier: kWebtoonDetailInfoCellID)

    let scoreCell = UINib(nibName: kWebtoonDetailScoreCellID, bundle: nil)
    mainTableView.register(scoreCell, forCellReuseIdentifier: kWebtoonDetailScoreCellID)

    let commentCell = UINib(nibName: kWebtoonDetailCommentCellID, bundle: nil)
    mainTableView.register(commentCell, forCellReuseIdentifier: kWebtoonDetailCommentCellID)

    let recommendCell = UINib(nibName: kHomeWebtoonListCellID, bundle: nil)
    mainTableView.register(recommendCell, forCellReuseIdentifier: kHomeWebtoonListCellID)

    let nodataCell = UINib(nibName: kGeneralNodataCellID, bundle: nil)
    mainTableView.register(nodataCell, forCellReuseIdentifier: kGeneralNodataCellID)

    mainTableView.delegate = self
    mainTableView.dataSource = self
    mainTableView.separatorStyle = .none
    mainTableView.backgroundColor = kWHITE
    mainTableView.rowHeight = UITableView.automaticDimension
    mainTableView.estimatedRowHeight = 200.0
    mainTableView.sectionHeaderHeight = UITableView.automaticDimension
    mainTableView.estimatedSectionHeaderHeight = 40.0
    mainTableView.sectionFooterHeight = UITableView.automaticDimension
    mainTableView.estimatedSectionFooterHeight = 16.0
    mainTableView.contentInset = UIEdgeInsets(top: kWEBTOON_DETAIL_HEADER_HEIGHT - kDEVICE_TOP_AREA - 24.0, left: 0.0, bottom: portalButtonBottomConstraint.constant + portalButtonHeightConstraint.constant + 16.0, right: 0.0)
    mainTableView.showsVerticalScrollIndicator = false
    mainTableView.alpha = 0.0
  }

  func initCommentView() {
    commentView.commentInputView.contentTextView.keyboardDismissMode = .onDrag
    commentView.delegate = self
    commentView.isHidden = true
  }

  func initPortalView() {
    portalView.backgroundColor = kGRAY_80
    portalView.layer.cornerRadius = 3.0
    portalView.clipsToBounds = true

    portalView.layer.shadowOpacity = 0.5
    portalView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    portalView.layer.shadowRadius = 3.0
    portalView.layer.masksToBounds = false

    portalLabel.textColor = kWHITE
    portalLabel.font = kBODY2_MEDIUM
    portalLabel.textAlignment = .center
    portalLabel.text = "투니 감상하기"

    portalButton.addTarget(self, action: #selector(doPortal), for: .touchUpInside)

    portalButtonBottomConstraint.constant = -200.0
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    initVars()
    initBackgroundView()
    initNavigationView()
    initHeaderView()
    initTableView()
    initCommentView()
    initPortalView()

    startActivity()
    fetchAll()

    initObservers()
  }

  deinit {
    self.deInitObservers()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    headerView.bind(webtoonItem)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return showHideNavigationView ? .default : .lightContent
  }
}

// MARK: - Fetch

extension WebtoonDetailViewController {

  func fetchAll() {
    let group = DispatchGroup()

    fetchWebtoonDetail(group)
    fetchComment(group)

    group.notify(queue: .main) {
      DispatchQueue.main.async {
        self.stopActivity()

        self.commentView.reset()
        self.commentView.bind(self.commentList)
        self.mainTableView.reloadData()

        self.view.layoutIfNeeded()
        self.mainTableView.setContentOffset(CGPoint(x: 0.0, y: -kWEBTOON_DETAIL_HEADER_HEIGHT + kDEVICE_TOP_AREA + 24.0), animated: false)

        UIView.animate(withDuration: 0.3) {
          self.headerView.alpha = 1.0
          self.mainTableView.alpha = 1.0
          self.hideNavigationView.alpha = 1.0
        }

        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.7,
                       delay: 0.25,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.0,
                       options: .curveEaseInOut) {
          self.portalButtonBottomConstraint.constant = 16.0
          self.view.layoutIfNeeded()
        } completion: { _ in
        }
      }
    }
  }
}

// MARK: - Comment

extension WebtoonDetailViewController {

  func fetchComment(_ group: DispatchGroup? = nil) {
    group?.enter()

    guard let webtoonId = webtoonItem.id?.string else { return }

    TooniNetworkService.shared.request(to: .commentList(webtoonId), decoder: CommentData.self) { [weak self] response in
      switch response.result {
      case .success:
        guard let commentList = response.json as? CommentData else { return }

        self?.commentList = commentList.commentResponse

        group?.leave()

        if group == nil {
          DispatchQueue.main.async {
            self?.commentView.reset()

            self?.stopActivity()
            self?.commentView.bind(self?.commentList)
            self?.mainTableView.reloadData()
          }
        }
      case .failure:
        print(response)

        group?.leave()
      }
    }
  }

  func deleteComment(_ commentItem: Comment?) {
    guard let commentId = commentItem?.id?.string else { return }

    let alert = UIAlertController(title: "알림", message: "댓글을 삭제하실건가요?", preferredStyle: .alert)

    let noAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
    let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
      self.startActivity()
      TooniNetworkService.shared.request(to: .deleteComment(commentId), decoder: ResponseItem.self) { [weak self] response in
        switch response.result {
        case .success:
          self?.fetchAll()
        case .failure:

          DispatchQueue.main.async {
            self?.stopActivity()
          }
          print(response)
        }
      }
    }

    alert.addAction(noAction)
    alert.addAction(deleteAction)

    present(alert, animated: true, completion: nil)
  }
}

// MARK: - Week Webtoon

extension WebtoonDetailViewController {

  func fetchWebtoonDetail(_ group: DispatchGroup? = nil) {
    group?.enter()

    guard let webtoonId = webtoonItem.id?.string else { return }

    TooniNetworkService.shared.request(to: .webtoonDetail(webtoonId), decoder: WebtoonDetail.self) { [weak self] response in
      switch response.result {
      case .success:
        guard let webtoonDetail = (response.json as? WebtoonDetail) else { return }

        self?.webtoonItem = webtoonDetail.webtoon
        self?.webtoonDetailItem = webtoonDetail

        group?.leave()

        if group == nil {
          DispatchQueue.main.async {
            self?.stopActivity()
            self?.mainTableView.reloadData()

            self?.view.layoutIfNeeded()
            self?.mainTableView.setContentOffset(CGPoint(x: 0.0, y: -kWEBTOON_DETAIL_HEADER_HEIGHT + kDEVICE_TOP_AREA + 24.0), animated: false)

            UIView.animate(withDuration: 0.3) {
              self?.headerView.alpha = 1.0
              self?.mainTableView.alpha = 1.0
              self?.hideNavigationView.alpha = 1.0
            }

            self?.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.7,
                           delay: 0.25,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.0,
                           options: .curveEaseInOut) {
              self?.portalButtonBottomConstraint.constant = 16.0
              self?.view.layoutIfNeeded()
            } completion: { _ in
            }
          }
        }
      case .failure:
        group?.leave()

        print(response)
      }
    }
  }
}

// MARK: - Event

extension WebtoonDetailViewController {

  @objc
  func doBack() {
    navigationController?.popViewController(animated: true)
  }

  @objc
  func doPortal() {
    guard let vc = GeneralHelper.sharedInstance.makeVC("Webtoon", "WebtoonWebViewController") as? WebtoonWebViewController else {
      return
    }

    vc.webtoonItem = webtoonItem
    navigationController?.pushViewController(vc, animated: true)

    GeneralHelper.sharedInstance.addRecentWebtoon(webtoonItem)
  }

  func openDetailVC(_ webtoonItem: Webtoon) {
    guard let vc = GeneralHelper.sharedInstance.makeVC("Webtoon", "WebtoonDetailViewController") as? WebtoonDetailViewController else {
      return
    }

    vc.webtoonItem = webtoonItem
    vc.hidesBottomBarWhenPushed = true
    navigationController?.pushViewController(vc, animated: true)
  }
}

// MARK: - WebtoonDetailHeaderView

extension WebtoonDetailViewController: WebtoonDetailHeaderViewDelegate {

  func didMenuWebtoonDetailHeaderView(view: WebtoonDetailHeaderView, idx: Int) {
    selectedIdx = idx

    refreshUI()
  }

  func refreshUI() {
    commentView.isHidden = selectedIdx == 0 ? true : false
  }

  func didBackWebtoonDetailHeaderView(view: WebtoonDetailHeaderView) {
    doBack()
  }
}

// MARK: - UITableView

extension WebtoonDetailViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return WebtoonDetailViewType.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case WebtoonDetailViewType.info.rawValue:
      return 1
    case WebtoonDetailViewType.score.rawValue:
      return 1
    case WebtoonDetailViewType.comments.rawValue:
      if let comments = webtoonDetailItem?.comments, !comments.isEmpty {
        return comments.count
      } else {
        return 1
      }
    case WebtoonDetailViewType.recommend.rawValue:
      if let randomRecommendWebtoons = webtoonDetailItem?.randomRecommendWebtoons, !randomRecommendWebtoons.isEmpty {
        return 1
      }
    default:
      return 0
    }

    return 0
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == WebtoonDetailViewType.comments.rawValue,
       let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kGeneralTitleHeaderViewID) as? GeneralTitleHeaderView
    {
      headerView.bind("투니 베스트 댓글")

      return headerView
    } else if section == WebtoonDetailViewType.recommend.rawValue,
              let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kGeneralTitleHeaderViewID) as? GeneralTitleHeaderView
    {
      headerView.bind("이런 투니는 어때요?")

      return headerView
    }

    return nil
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == WebtoonDetailViewType.comments.rawValue ||
      section == WebtoonDetailViewType.recommend.rawValue
    {
      return UITableView.automaticDimension
    }

    return .leastNonzeroMagnitude
  }

  func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    if section == WebtoonDetailViewType.comments.rawValue {
      let headerView = UIView()
      return headerView
    }

    return nil
  }

  func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    if section == WebtoonDetailViewType.comments.rawValue {
      return 16.0
    }

    return .leastNonzeroMagnitude
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == WebtoonDetailViewType.info.rawValue,
       let cell = tableView.dequeueReusableCell(withIdentifier: kWebtoonDetailInfoCellID, for: indexPath) as? WebtoonDetailInfoCell
    {
      cell.bind(webtoonItem)
      cell.delegate = self

      return cell
    } else if indexPath.section == WebtoonDetailViewType.score.rawValue,
              let cell = tableView.dequeueReusableCell(withIdentifier: kWebtoonDetailScoreCellID, for: indexPath) as? WebtoonDetailScoreCell
    {
      cell.bind(webtoonItem)

      return cell
    } else if indexPath.section == WebtoonDetailViewType.comments.rawValue {
      if let comments = webtoonDetailItem?.comments, !comments.isEmpty,
         let cell = tableView.dequeueReusableCell(withIdentifier: kWebtoonDetailCommentCellID, for: indexPath) as? WebtoonDetailCommentCell
      {
        let commentItem = comments[indexPath.row]
        cell.bind(commentItem)
        cell.delegate = self
        cell.divider(indexPath.row == comments.count - 1 ? false : true)

        return cell
      } else if let cell = tableView.dequeueReusableCell(withIdentifier: kGeneralNodataCellID, for: indexPath) as? GeneralNodataCell {
        cell.bind("empty_comment", "아직 댓글이 없어요 😭")

        return cell
      }
    } else if indexPath.section == WebtoonDetailViewType.recommend.rawValue,
              let randomRecommendWebtoons = webtoonDetailItem?.randomRecommendWebtoons, !randomRecommendWebtoons.isEmpty,
              let cell = tableView.dequeueReusableCell(withIdentifier: kHomeWebtoonListCellID, for: indexPath) as? HomeWebtoonListCell
    {
      cell.bind(randomRecommendWebtoons)
      cell.delegate = self

      return cell
    }

    return .init()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

// MARK: - WebtoonDetailInfoCell

extension WebtoonDetailViewController: WebtoonDetailInfoCellDelegate {

  func didFavoriteWebtoonDetailInfoCell(cell: WebtoonDetailInfoCell) {
    GeneralHelper.sharedInstance.doVibrate()

    if GeneralHelper.sharedInstance.existFavorite(webtoonItem) {
      GeneralHelper.sharedInstance.removeFavoriteWebtoon(webtoonItem)
    } else {
      GeneralHelper.sharedInstance.addFavoriteWebtoon(webtoonItem)
    }

    mainTableView.reloadRows(at: [IndexPath(row: WebtoonDetailViewType.info.rawValue, section: 0)], with: .none)
  }
}

// MARK: - WebtoonDetailCommentCell

extension WebtoonDetailViewController: WebtoonDetailCommentCellDelegate {

  func didMenuWebtoonDetailCommentCell(cell: WebtoonDetailCommentCell, commentItem: Comment?, type: WebtoonDetailCommentMenuType) {
    switch type {
    case .report:
      showAlertWithTitle(vc: self, title: "알림", message: "댓글을 신고했어요\n제보 감사합니다 😎")
    case .delete:
      deleteComment(commentItem)
    }
  }
}

// MARK: - WebtoonDetailCommentView

extension WebtoonDetailViewController: WebtoonDetailCommentViewDelegate {

  func didMenuWebtoonDetailCommentView(view: WebtoonDetailCommentView, commentItem: Comment?, type: WebtoonDetailCommentMenuType) {
    switch type {
    case .report:
      showAlertWithTitle(vc: self, title: "알림", message: "댓글을 신고했어요\n제보 감사합니다 😎")
    case .delete:
      deleteComment(commentItem)
    }
  }

  func didSendWebtoonDetailCommentView(view: WebtoonDetailCommentView, text: String?) {
    guard let text = text, !text.isEmpty else { return }
    guard let webtoonId = webtoonItem.id?.string else { return }

    startActivity()
    TooniNetworkService.shared.request(to: .writeComment(webtoonId, text), decoder: ResponseItem.self) { [weak self] response in
      switch response.result {
      case .success:
        guard let response = response.json as? ResponseItem else { return }
        print(response)

        self?.fetchAll()
      case .failure:
        print(response)
      }
    }
  }
}

// MARK: - HomeWebtoonListCell

extension WebtoonDetailViewController: HomeWebtoonListCellDelegate {

  func didWebtoonHomeWebtoonListCell(cell: HomeWebtoonListCell, webtoon: Webtoon) {
    openDetailVC(webtoon)
  }
}

// MARK: - UIScrollView

extension WebtoonDetailViewController: UIScrollViewDelegate {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offsetY = -scrollView.contentOffset.y + kDEVICE_TOP_AREA - kWEBTOON_DETAIL_HEADER_HEIGHT
    let zeroOffsetY = offsetY + 24.0
    let topMargin = kWEBTOON_DETAIL_HEADER_HEIGHT - hideNavigationViewHeightConstraint.constant - 50

    hideNavigationViewTopConstraint.constant = -hideNavigationViewHeightConstraint.constant - zeroOffsetY
    if zeroOffsetY <= -hideNavigationViewHeightConstraint.constant {
      hideNavigationViewTopConstraint.constant = 0.0
    }

    if offsetY >= -24.0 {
      let height = kWEBTOON_DETAIL_HEADER_HEIGHT - kDEVICE_TOP_AREA - 24.0
      scrollView.contentOffset.y = -height

      headerViewTopConstraint.constant = 0.0

      showHideNavigationView = false
      setNeedsStatusBarAppearanceUpdate()
    } else if zeroOffsetY <= -topMargin {
      headerViewTopConstraint.constant = -topMargin

      showHideNavigationView = true
      setNeedsStatusBarAppearanceUpdate()
    } else {
      headerViewTopConstraint.constant = offsetY + 24.0
    }
  }
}

// MARK: -

extension WebtoonDetailViewController {

  func initObservers() {
    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillShow(sender:)),
                                           name: UIResponder.keyboardWillShowNotification,
                                           object: nil)

    NotificationCenter.default.addObserver(self,
                                           selector: #selector(keyboardWillHide(sender:)),
                                           name: UIResponder.keyboardWillHideNotification,
                                           object: nil)
  }

  func deInitObservers() {
    NotificationCenter.default.removeObserver(self,
                                              name: UIResponder.keyboardWillShowNotification,
                                              object: nil)

    NotificationCenter.default.removeObserver(self,
                                              name: UIResponder.keyboardWillHideNotification,
                                              object: nil)
  }

  @objc
  func keyboardWillShow(sender: NSNotification) {
    let userInfo = sender.userInfo
    let value = userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
    let keyboardRect = (value as! NSValue).cgRectValue

    commentViewBottomConstraint.constant = keyboardRect.size.height - kDEVICE_BOTTOM_AREA + 32.0
    view.layoutIfNeeded()
  }

  @objc
  func keyboardWillHide(sender: NSNotification) {
    commentViewBottomConstraint.constant = 0.0
    view.layoutIfNeeded()
  }
}

// MARK: - Activity

extension WebtoonDetailViewController {

  func startActivity() {
    if activity.isAnimating() { return }
    activity.start()
  }

  func stopActivity() {
    if !activity.isAnimating() { return }
    activity.stop()
  }
}
