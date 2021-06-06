//
//  DetailHomeViewController.swift
//  TooniTooni
//
//  Created by buzz on 2021/05/28.
//

import UIKit

protocol DetailHomeSectionTitle {
  var title: String? { get }
}

enum DetailHomeSectionType: Int, DetailHomeSectionTitle {
  case info
  case comment
  case recommend

  var title: String? {
    switch self {
    case .info:
      return nil
    case .comment:
      return "투니베스트 댓글"
    case .recommend:
      return "이런 투니는 어때요?"
    }
  }

  static let count = 3
}

class DetailHomeViewController: BaseViewController {

  // MARK: - Constant

  private enum Metric {
    static let maxMenuViewTopConstraint: CGFloat = 114
    static let headerHeight: CGFloat = 86
    static let menuViewHeight: CGFloat = 50
    static let webtoonUrlButton: CGFloat = 76
    static let webtoonURLButtonBottomConstraints: CGFloat = 44
  }

  // MARK: - Vars

  @IBOutlet weak var mainTableView: UITableView!
  @IBOutlet weak var activity: GeneralActivity!
  @IBOutlet weak var webtoonURLButton: UIButton!

  var didScroll: ((_ scrollView: UIScrollView) -> Void)?
  var didTapToalComment: ((UIButton) -> Void)?

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
    let headerView = UINib(nibName: GeneralTitleRightDetailHeaderView.reuseIdentifier, bundle: nil)
    mainTableView.register(headerView, forHeaderFooterViewReuseIdentifier: GeneralTitleRightDetailHeaderView.reuseIdentifier)

    let webtoonDetailInfoCell = UINib(nibName: WebtoonDetailInfoCell.reuseIdentifier, bundle: nil)
    mainTableView.register(webtoonDetailInfoCell, forCellReuseIdentifier: WebtoonDetailInfoCell.reuseIdentifier)

    let commentCell = UINib(nibName: CommentCell.reuseIdentifier, bundle: nil)
    mainTableView.register(commentCell, forCellReuseIdentifier: CommentCell.reuseIdentifier)

    let webtoonRandomListCell = UINib(nibName: WebtoonRandomListCell.reuseIdentifier, bundle: nil)
    mainTableView.register(webtoonRandomListCell, forCellReuseIdentifier: WebtoonRandomListCell.reuseIdentifier)

    mainTableView.dataSource = self
    mainTableView.delegate = self
    mainTableView.separatorStyle = .none
    mainTableView.rowHeight = UITableView.automaticDimension
    mainTableView.estimatedRowHeight = 200.0
    mainTableView.showsHorizontalScrollIndicator = false
    mainTableView.showsVerticalScrollIndicator = false
    mainTableView.contentInset.bottom += webtoonURLButton.frame.height
  }

  func initWebToonURLButton() {
    webtoonURLButton.backgroundColor = kGRAY_80
    webtoonURLButton.layer.cornerRadius = 3
    webtoonURLButton.layer.masksToBounds = true
    webtoonURLButton.titleLabel?.font = kBODY2_MEDIUM
    webtoonURLButton.setTitle("투니 감상하기", for: .normal)
    webtoonURLButton.setTitleColor(kWHITE, for: .normal)
    webtoonURLButton.addTarget(self, action: #selector(pushWebView), for: .touchUpInside)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    initVars()
    initTableView()
    initWebToonURLButton()

    startActivity()
    fetchDetail(with: webtoon)
  }
}

// MARK: - Event

extension DetailHomeViewController {

  @objc
  func didTapTotalComment(sender: UIButton) {
    didTapToalComment?(sender)
  }

  @objc
  func pushWebView() {
    if let vc = GeneralHelper.sharedInstance.makeVC("WebtoonDetail", "DetailWebViewController") as? DetailWebViewController {
      vc.url = webtoon?.url
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}

// MARK: - Helper method

extension DetailHomeViewController {

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

extension DetailHomeViewController: UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    return DetailHomeSectionType.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let sectionType = DetailHomeSectionType(rawValue: section)
    switch sectionType {
    case .info:
      return 1
    case .comment:
      return webtoonDetail?.comments.count ?? 0
    case .recommend:
      return 1
    default:
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let sectionType = DetailHomeSectionType(rawValue: indexPath.section)
    switch sectionType {
    case .info:
      if let cell = tableView.dequeueReusableCell(withIdentifier: WebtoonDetailInfoCell.reuseIdentifier, for: indexPath) as? WebtoonDetailInfoCell {

        if let webtoonDetail = webtoonDetail {
          cell.bind(webtoonDetail)
        }

        return cell
      }

      return .init()
    case .comment:
      if let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.reuseIdentifier, for: indexPath) as? CommentCell {

        if let webtoonDetail = webtoonDetail {
          cell.bind(webtoonDetail.comments[indexPath.row])
        }

        return cell
      }

      return .init()
    case .recommend:
      if let cell = tableView.dequeueReusableCell(withIdentifier: WebtoonRandomListCell.reuseIdentifier, for: indexPath) as? WebtoonRandomListCell {

        if let webtoonDetail = webtoonDetail {
          let webtoons = webtoonDetail.randomRecommendWebtoons
          cell.bind(webtoons)
        }

        return cell
      }

      return .init()
    default:
      return .init()
    }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let sectionType = DetailHomeSectionType(rawValue: section)
    switch sectionType {
    case .info:
      return nil
    case .comment:
      if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: GeneralTitleRightDetailHeaderView.reuseIdentifier) as? GeneralTitleRightDetailHeaderView {
        headerView.bind(sectionType?.title, detailTitle: "전체보기")
        headerView.detailButton.addTarget(self, action: #selector(didTapTotalComment(sender:)), for: .touchUpInside)
        return headerView
      }

      return nil
    case .recommend:
      if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: GeneralTitleRightDetailHeaderView.reuseIdentifier) as? GeneralTitleRightDetailHeaderView {
        headerView.bind(sectionType?.title)
        return headerView
      }

      return nil
    default:
      return nil
    }
  }
}

extension DetailHomeViewController: UITableViewDelegate {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    didScroll?(scrollView)
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    let sectionType = DetailHomeSectionType(rawValue: section)

    switch sectionType {
    case .info:
      return .leastNormalMagnitude
    case .comment:
      if webtoonDetail?.comments.count == .zero {
        return .leastNormalMagnitude
      } else {
        return Metric.headerHeight
      }
    case .recommend:
      return Metric.headerHeight
    default:
      return .leastNormalMagnitude
    }
  }
}

// MARK: - Activity

extension DetailHomeViewController {

  func startActivity() {
    if activity.isAnimating() { return }
    activity.start()
  }

  func stopActivity() {
    if !activity.isAnimating() { return }
    activity.stop()
  }
}
