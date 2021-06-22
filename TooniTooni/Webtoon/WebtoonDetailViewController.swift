//
//  WebtoonDetailViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/29.
//

import UIKit
import SafariServices

enum WebtoonDetailViewType: Int {
    case info
    case score
    case comments
    case recommend
    
    static let count = 4
}

let kWEBTOON_DETAIL_HEADER_HEIGHT: CGFloat =                            252.0

class WebtoonDetailViewController: BaseViewController {
    
    // MARK: - Vars
    
    @IBOutlet weak var hideNavigationView: GeneralNavigationView!
    @IBOutlet weak var hideNavigationViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var hideNavigationViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: WebtoonDetailHeaderView!
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var commentView: WebtoonDetailCommentView!
    @IBOutlet weak var commentViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var portalView: UIView!
    @IBOutlet weak var portalButton: UIButton!
    @IBOutlet weak var portalLabel: UILabel!
    @IBOutlet weak var portalButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var portalButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var activity: CustomActivity!

    var selectedIdx = 0
    var showHideNavigationView = false

    var webtoonItem: Webtoon!
    var webtoonDetailItem: WebtoonDetail?
    
    var commentList: [Comment]?

    // MARK: - Life Cycle
    
    func initVars() {
        self.showBigTitle = false
    }
    
    func initBackgroundView() {
        self.view.backgroundColor = kWHITE
    }
    
    func initNavigationView() {
        self.hideNavigationView.bgColor(kWHITE)
        self.hideNavigationView.title(self.webtoonItem.title)
        self.hideNavigationView.bigTitle(false)
        self.hideNavigationView.leftButton(true)
        self.hideNavigationView.alpha = 0.0
        
        self.hideNavigationView.leftButton.isHidden = false
        self.hideNavigationView.leftButton.setImage(UIImage.init(named: "icon_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.hideNavigationView.leftButton.tintColor = kGRAY_90
        self.hideNavigationView.leftButton.addTarget(self, action: #selector(doBack), for: .touchUpInside)
        
        self.hideNavigationViewHeightConstraint.constant = 44.0 + kDEVICE_TOP_AREA
        self.hideNavigationViewTopConstraint.constant = -self.hideNavigationViewHeightConstraint.constant - kDEVICE_TOP_AREA
    }

    func initHeaderView() {
        self.headerView.bind(self.webtoonItem)
        self.headerView.delegate = self
        self.headerView.alpha = 0.0
        
        self.view.layoutIfNeeded()
        self.headerViewHeightConstraint.constant = kWEBTOON_DETAIL_HEADER_HEIGHT
    }
    
    func initTableView() {
        let headerView = UINib.init(nibName: kGeneralTitleHeaderViewID, bundle: nil)
        self.mainTableView.register(headerView, forHeaderFooterViewReuseIdentifier: kGeneralTitleHeaderViewID)

        let infoCell = UINib.init(nibName: kWebtoonDetailInfoCellID, bundle: nil)
        self.mainTableView.register(infoCell, forCellReuseIdentifier: kWebtoonDetailInfoCellID)
        
        let scoreCell = UINib.init(nibName: kWebtoonDetailScoreCellID, bundle: nil)
        self.mainTableView.register(scoreCell, forCellReuseIdentifier: kWebtoonDetailScoreCellID)

        let commentCell = UINib.init(nibName: kWebtoonDetailCommentCellID, bundle: nil)
        self.mainTableView.register(commentCell, forCellReuseIdentifier: kWebtoonDetailCommentCellID)

        let recommendCell = UINib.init(nibName: kHomeWebtoonListCellID, bundle: nil)
        self.mainTableView.register(recommendCell, forCellReuseIdentifier: kHomeWebtoonListCellID)
        
        let nodataCell = UINib.init(nibName: kGeneralNodataCellID, bundle: nil)
        self.mainTableView.register(nodataCell, forCellReuseIdentifier: kGeneralNodataCellID)

        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.separatorStyle = .none
        self.mainTableView.backgroundColor = kWHITE
        self.mainTableView.rowHeight = UITableView.automaticDimension
        self.mainTableView.estimatedRowHeight = 200.0
        self.mainTableView.sectionHeaderHeight = UITableView.automaticDimension
        self.mainTableView.estimatedSectionHeaderHeight = 40.0
        self.mainTableView.sectionFooterHeight = UITableView.automaticDimension
        self.mainTableView.estimatedSectionFooterHeight = 16.0
        self.mainTableView.contentInset = UIEdgeInsets.init(top: kWEBTOON_DETAIL_HEADER_HEIGHT - kDEVICE_TOP_AREA - 24.0, left: 0.0, bottom: self.portalButtonBottomConstraint.constant + self.portalButtonHeightConstraint.constant + 16.0, right: 0.0)
        self.mainTableView.showsVerticalScrollIndicator = false
        self.mainTableView.alpha = 0.0
    }
    
    func initCommentView() {
        self.commentView.commentInputView.contentTextView.keyboardDismissMode = .onDrag
        self.commentView.delegate = self
        self.commentView.isHidden = true
    }
    
    func initPortalView() {
        self.portalView.backgroundColor = kGRAY_80
        self.portalView.layer.cornerRadius = 3.0
        self.portalView.clipsToBounds = true
        
        self.portalView.layer.shadowOpacity = 0.5
        self.portalView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.portalView.layer.shadowRadius = 3.0
        self.portalView.layer.masksToBounds = false

        self.portalLabel.textColor = kWHITE
        self.portalLabel.font = kBODY2_MEDIUM
        self.portalLabel.textAlignment = .center
        self.portalLabel.text = "투니 감상하기"
        
        self.portalButton.addTarget(self, action: #selector(doPortal), for: .touchUpInside)
        
        self.portalButtonBottomConstraint.constant = -200.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initVars()
        self.initBackgroundView()
        self.initNavigationView()
        self.initHeaderView()
        self.initTableView()
        self.initCommentView()
        self.initPortalView()
        
        self.startActivity()
        self.fetchAll()
        
        self.initObservers()
    }
    
    deinit {
        self.deInitObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.headerView.bind(self.webtoonItem)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.showHideNavigationView ? .default : .lightContent
    }

}

// MARK: - Fetch

extension WebtoonDetailViewController {
    
    func fetchAll() {
        let group = DispatchGroup()
        
        self.fetchWebtoonDetail(group)
        self.fetchComment(group)
        
        group.notify(queue: .main) {
            DispatchQueue.main.async {
                self.stopActivity()
                
                self.commentView.reset()
                self.commentView.bind(self.commentList)
                self.mainTableView.reloadData()
                
                self.view.layoutIfNeeded()
                self.mainTableView.setContentOffset(CGPoint.init(x: 0.0, y: -kWEBTOON_DETAIL_HEADER_HEIGHT + kDEVICE_TOP_AREA + 24.0), animated: false)
                
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
        
        guard let webtoonId = self.webtoonItem.id?.string else { return }

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

        let alert = UIAlertController.init(title: "알림", message: "댓글을 삭제하실건가요?", preferredStyle: .alert)
        
        let noAction = UIAlertAction.init(title: "아니오", style: .default, handler: nil)
        let deleteAction = UIAlertAction.init(title: "삭제", style: .destructive) { _  in
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
        
        self.present(alert, animated: true, completion: nil)
    }

}

// MARK: - Week Webtoon

extension WebtoonDetailViewController {
    
    func fetchWebtoonDetail(_ group: DispatchGroup? = nil) {
        group?.enter()
        
        guard let webtoonId = self.webtoonItem.id?.string else { return }

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
                        self?.mainTableView.setContentOffset(CGPoint.init(x: 0.0, y: -kWEBTOON_DETAIL_HEADER_HEIGHT + kDEVICE_TOP_AREA + 24.0), animated: false)
                        
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
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    func doPortal() {
        if let webtoonUrl = self.webtoonItem.url,
           let url = URL.init(string: webtoonUrl) {
            let safariVC = SFSafariViewController(url: url)

            self.present(safariVC, animated: true) {
                GeneralHelper.sharedInstance.addRecentWebtoon(self.webtoonItem)
            }
        }
    }
    
    func openDetailVC(_ webtoonItem: Webtoon) {
        guard let vc = GeneralHelper.sharedInstance.makeVC("Webtoon", "WebtoonDetailViewController") as? WebtoonDetailViewController else {
            return
        }
        
        vc.webtoonItem = webtoonItem
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: - WebtoonDetailHeaderView

extension WebtoonDetailViewController: WebtoonDetailHeaderViewDelegate {
    
    func didMenuWebtoonDetailHeaderView(view: WebtoonDetailHeaderView, idx: Int) {
        self.selectedIdx = idx
        
        self.refreshUI()
    }
    
    func refreshUI() {
        self.commentView.isHidden = self.selectedIdx == 0 ? true : false
    }
    
    func didBackWebtoonDetailHeaderView(view: WebtoonDetailHeaderView) {
        self.doBack()
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
            if let comments = self.webtoonDetailItem?.comments, comments.count > 0 {
                return comments.count
            }
            else {
                return 1
            }
        case WebtoonDetailViewType.recommend.rawValue:
            if let randomRecommendWebtoons = self.webtoonDetailItem?.randomRecommendWebtoons, randomRecommendWebtoons.count > 0 {
                return 1
            }
        default:
            return 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == WebtoonDetailViewType.comments.rawValue,
           let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kGeneralTitleHeaderViewID) as? GeneralTitleHeaderView {
            headerView.bind("투니 베스트 댓글")
            
            return headerView
        }
        else if section == WebtoonDetailViewType.recommend.rawValue,
           let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kGeneralTitleHeaderViewID) as? GeneralTitleHeaderView {
            headerView.bind("이런 투니는 어때요?")
            
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == WebtoonDetailViewType.comments.rawValue ||
            section == WebtoonDetailViewType.recommend.rawValue {
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
           let cell = tableView.dequeueReusableCell(withIdentifier: kWebtoonDetailInfoCellID, for: indexPath) as? WebtoonDetailInfoCell {
            cell.bind(self.webtoonItem)
            cell.delegate = self
            
            return cell
        }
        else if indexPath.section == WebtoonDetailViewType.score.rawValue,
                let cell = tableView.dequeueReusableCell(withIdentifier: kWebtoonDetailScoreCellID, for: indexPath) as? WebtoonDetailScoreCell {
            cell.bind(self.webtoonItem)
            
            return cell
        }
        else if indexPath.section == WebtoonDetailViewType.comments.rawValue {
            if let comments = self.webtoonDetailItem?.comments, comments.count > 0,
               let cell = tableView.dequeueReusableCell(withIdentifier: kWebtoonDetailCommentCellID, for: indexPath) as? WebtoonDetailCommentCell {
                let commentItem = comments[indexPath.row]
                cell.bind(commentItem)
                cell.delegate = self
                cell.divider(indexPath.row == comments.count - 1 ? false : true)
                
                return cell
            }
            else if let cell = tableView.dequeueReusableCell(withIdentifier: kGeneralNodataCellID, for: indexPath) as? GeneralNodataCell {
                cell.bind("empty_comment", "아직 댓글이 없어요 😭")

                return cell
            }
        }
        
        else if indexPath.section == WebtoonDetailViewType.recommend.rawValue,
                let randomRecommendWebtoons = self.webtoonDetailItem?.randomRecommendWebtoons, randomRecommendWebtoons.count > 0,
                let cell = tableView.dequeueReusableCell(withIdentifier: kHomeWebtoonListCellID, for: indexPath) as? HomeWebtoonListCell {
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
        
        if GeneralHelper.sharedInstance.existFavorite(self.webtoonItem) {
            GeneralHelper.sharedInstance.removeFavoriteWebtoon(self.webtoonItem)
        }
        else {
            GeneralHelper.sharedInstance.addFavoriteWebtoon(self.webtoonItem)
        }
        
        self.mainTableView.reloadRows(at: [IndexPath.init(row: WebtoonDetailViewType.info.rawValue, section: 0)], with: .none)
    }
    
}

// MARK: - WebtoonDetailCommentCell

extension WebtoonDetailViewController: WebtoonDetailCommentCellDelegate {
    
    func didMenuWebtoonDetailCommentCell(cell: WebtoonDetailCommentCell, commentItem: Comment?, type: WebtoonDetailCommentMenuType) {
        switch type {
        case .report:
            self.showAlertWithTitle(vc: self, title: "알림", message: "댓글을 신고했어요\n제보 감사합니다 😎")
        case .delete:
            self.deleteComment(commentItem)
        }
    }
        
}

// MARK: - WebtoonDetailCommentView

extension WebtoonDetailViewController: WebtoonDetailCommentViewDelegate {
    
    func didMenuWebtoonDetailCommentView(view: WebtoonDetailCommentView, commentItem: Comment?, type: WebtoonDetailCommentMenuType) {
        switch type {
        case .report:
            self.showAlertWithTitle(vc: self, title: "알림", message: "댓글을 신고했어요\n제보 감사합니다 😎")
        case .delete:
            self.deleteComment(commentItem)
        }
    }
    
    func didSendWebtoonDetailCommentView(view: WebtoonDetailCommentView, text: String?) {
        guard let text = text, text.count > 0 else { return }
        guard let webtoonId = self.webtoonItem.id?.string else { return }

        self.startActivity()
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
        self.openDetailVC(webtoon)
    }
    
}

// MARK: - UIScrollView

extension WebtoonDetailViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = -scrollView.contentOffset.y + kDEVICE_TOP_AREA - kWEBTOON_DETAIL_HEADER_HEIGHT
        let zeroOffsetY = offsetY + 24.0
        let topMargin = kWEBTOON_DETAIL_HEADER_HEIGHT - self.hideNavigationViewHeightConstraint.constant - 50
        
        self.hideNavigationViewTopConstraint.constant = -self.hideNavigationViewHeightConstraint.constant - zeroOffsetY
        if zeroOffsetY <= -self.hideNavigationViewHeightConstraint.constant {
            self.hideNavigationViewTopConstraint.constant = 0.0
        }
                        
        if offsetY >= -24.0 {
            let height = kWEBTOON_DETAIL_HEADER_HEIGHT - kDEVICE_TOP_AREA - 24.0
            scrollView.contentOffset.y = -height

            self.headerViewTopConstraint.constant = 0.0
            
            self.showHideNavigationView = false
            self.setNeedsStatusBarAppearanceUpdate()
        }
        else if zeroOffsetY <= -topMargin {
            self.headerViewTopConstraint.constant = -topMargin
            
            self.showHideNavigationView = true
            self.setNeedsStatusBarAppearanceUpdate()
        }
        else {
            self.headerViewTopConstraint.constant = offsetY + 24.0
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
        
        self.commentViewBottomConstraint.constant = keyboardRect.size.height - kDEVICE_BOTTOM_AREA + 32.0
        self.view.layoutIfNeeded()
    }
    
    @objc
    func keyboardWillHide(sender: NSNotification) {
        self.commentViewBottomConstraint.constant = 0.0
        self.view.layoutIfNeeded()
    }
    
}


// MARK: - Activity

extension WebtoonDetailViewController {
    
    func startActivity() {
        if self.activity.isAnimating() { return }
        self.activity.start()
    }
    
    func stopActivity() {
        if !self.activity.isAnimating() { return }
        self.activity.stop()
    }
    
}

