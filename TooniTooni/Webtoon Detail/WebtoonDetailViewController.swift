//
//  WebtoonDetailViewController.swift
//  TooniTooni
//
//  Created by buzz on 2021/05/28.
//

import UIKit

protocol WebtoonDetailMenuTitle {
  var title: String? { get }
}

enum WebtoonDetailViewType: Int, WebtoonDetailMenuTitle {
  case home
  case comment

  var title: String? {
    switch self {
    case .home:
      return "투니 홈"
    case .comment:
      return "투니 댓글"
    }
  }

  static let count = 2
}

class WebtoonDetailViewController: BaseViewController {

  // MARK: - Constant

  private enum Metric {
    static let maxMenuViewTopConstraint: CGFloat = 114
  }

  // MARK: - Vars

  @IBOutlet weak var statusBarView: UIView!
  @IBOutlet weak var navigationView: GeneralNavigationView!
  @IBOutlet weak var badgeView: GeneralBadgeView!
  @IBOutlet weak var currentDayLabel: UILabel!
  @IBOutlet weak var webtoonMenuViewTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var thumbnailImageView: UIImageView!
  @IBOutlet weak var menuView: WebtoonMenuView!
  @IBOutlet weak var baseView: UIView!
  @IBOutlet weak var starLargeImageView: UIImageView!
  @IBOutlet weak var starSmallImageView: UIImageView!
  @IBOutlet weak var cloudImageView: UIImageView!

  var pageVC: UIPageViewController!
  var selectedIdx = 0
  var webtoon: Webtoon?
  var embededViewControllers: [BaseViewController] = [
    GeneralHelper.sharedInstance.makeVC("WebtoonDetail", "DetailHomeViewController"),
    GeneralHelper.sharedInstance.makeVC("WebtoonDetail", "DetailCommentViewController")
  ]

  override var preferredStatusBarStyle: UIStatusBarStyle {
    if isDarkStatusBarStyle {
      return .darkContent
    } else {
      return .lightContent
    }
  }

  // MARK: - Life Cycle

  func initVars() {
    showBigTitle = false
  }

  func initStatusBarView() {
    statusBarView.backgroundColor = kGRAY_80
  }

  func initNavigationView() {
    navigationView.bgColor(.clear)
    navigationView.leftButton.isHidden = false
    navigationView.leftButton.setImage(UIImage(named: "icon_left_arrow"), for: .normal)
    navigationView.leftButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
  }

  func initThumbnail() {
    thumbnailImageView.contentMode = .scaleAspectFill

    if let thumbnail = webtoon?.thumbnail {
      thumbnailImageView.kf.setImage(
        with: URL(string: thumbnail),
        placeholder: nil,
        options: [.transition(.fade(0.25))],
        completionHandler: nil
      )
    }

    makeCircularSector()
  }

  func initBadgeView() {
    if let webtoon = webtoon {
      badgeView.bind(webtoon)
    }
  }

  func initCurrentDayLabel() {
    currentDayLabel.font = kCAPTION1_REGULAR
    currentDayLabel.changeColor(for: webtoon?.site)
    if let weekday = webtoon?.weekday?.first {
      currentDayLabel.text = weekday.transformKorean
    }
  }

  func initPageView() {
    pageVC = GeneralHelper.sharedInstance.makePageVC("WebtoonDetail", "WebtoonDetailPageViewController")
    pageVC.delegate = self
    pageVC.dataSource = self
    let startVC = viewControllerAtIndex(index: selectedIdx)
    let viewControllers = [startVC]

    pageVC.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)

    view.layoutIfNeeded()

    pageVC.view.frame = baseView.bounds
    addChild(pageVC)
    baseView.addSubview(pageVC.view)
  }

  func initMenuView() {
    menuView.bind(selectedIdx, site: webtoon?.site)
    menuView.didMenuWeekMenuView = { [weak self] menuView, idx in
      guard let self = self else { return }
      if self.selectedIdx == idx { return }

      var direction: UIPageViewController.NavigationDirection = .forward
      if idx < self.selectedIdx {
        direction = .reverse
      }

      self.selectedIdx = idx

      let startVC = self.viewControllerAtIndex(index: self.selectedIdx)
      let viewControllers = [startVC]

      self.pageVC.setViewControllers(viewControllers, direction: direction, animated: true, completion: nil)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    statusBarEnterLightContent()
    initVars()
    initStatusBarView()
    initNavigationView()
    initBadgeView()
    initCurrentDayLabel()
    initThumbnail()
    initPageView()
    initMenuView()
    starAnimating()
    cloudAnimating()
  }
}

// MARK: - Event

extension WebtoonDetailViewController {

  @objc
  func pop() {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - Helper method

extension WebtoonDetailViewController {

  private func didScrollAnimating(with scrollView: UIScrollView) {
    webtoonMenuViewTopConstraint.constant -= scrollView.contentOffset.y
    if webtoonMenuViewTopConstraint.constant <= .zero {
      webtoonMenuViewTopConstraint.constant = .zero
      updateUIDidScroll(isTop: true)
    } else {
      if webtoonMenuViewTopConstraint.constant >= Metric.maxMenuViewTopConstraint {
        webtoonMenuViewTopConstraint.constant = Metric.maxMenuViewTopConstraint
      }
      updateUIDidScroll(isTop: false)
    }
  }

  private func updateUIDidScroll(isTop: Bool) {
    if isTop {
      statusBarEnterDarkContent()
      statusBarView.backgroundColor = kWHITE
      navigationView.bgColor(.white)
      navigationView.leftButton.setImage(
        UIImage(named: "icon_arrow_round_back"),
        for: .normal
      )
    } else {
      statusBarEnterLightContent()
      statusBarView.backgroundColor = kGRAY_80
      navigationView.bgColor(.clear)
      navigationView.leftButton.setImage(
        UIImage(named: "icon_left_arrow"),
        for: .normal
      )
    }
  }

  private func makeCircularSector() {
    let circularSectorPath = UIBezierPath()
    circularSectorPath.move(to: CGPoint(x: thumbnailImageView.frame.width / 2, y: thumbnailImageView.frame.height))
    circularSectorPath.addArc(withCenter: CGPoint(x: thumbnailImageView.bounds.size.height, y: thumbnailImageView.bounds.size.width), radius: thumbnailImageView.bounds.size.width, startAngle: 180, endAngle: 315, clockwise: true)
    circularSectorPath.close()

    thumbnailImageView.image = thumbnailImageView.image?.imageByApplyingMaskingBezierPath(circularSectorPath, thumbnailImageView.frame)
  }

  private func starAnimating() {
    UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear, .repeat]) {
      self.starLargeImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
      self.starSmallImageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }
  }

  private func cloudAnimating() {
    UIView.animate(withDuration: 2, delay: 0, options: [.curveLinear, .repeat, .autoreverse]) {
      self.cloudImageView.transform = CGAffineTransform(translationX: 0, y: 10)
    }
  }
}

// MARK: - PageViewController

extension WebtoonDetailViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {

  func viewControllerAtIndex(index: Int) -> BaseViewController {
    switch WebtoonMenuType(rawValue: index) {
    case .home:
      if let vc = embededViewControllers[index] as? DetailHomeViewController {
        vc.pageIdx = index
        vc.webtoon = webtoon
        vc.didScroll = { [weak self] scrollView in
          DispatchQueue.main.async {
            self?.didScrollAnimating(with: scrollView)
          }
        }

        vc.didTapToalComment = { [weak self] button in
          guard let self = self else { return }
          self.selectedIdx += 1

          let startVC = self.viewControllerAtIndex(index: self.selectedIdx)
          self.pageVC.setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
          self.menuView.move(self.selectedIdx)

          self.webtoonMenuViewTopConstraint.constant -= Metric.maxMenuViewTopConstraint
          self.statusBarView.backgroundColor = kWHITE
          self.navigationView.bgColor(.white)
          self.navigationView.leftButton.setImage(
            UIImage(named: "icon_arrow_round_back"),
            for: .normal
          )
        }

        return vc
      }

      return .init()
    case .comment:
      if let vc = embededViewControllers[index] as? DetailCommentViewController {
        vc.pageIdx = index
        vc.webtoon = webtoon

        vc.didScroll = { [weak self] scrollView in
          DispatchQueue.main.async {
            self?.didScrollAnimating(with: scrollView)
          }
        }

        return vc
      }

      return .init()
    default:
      return .init()
    }
  }

  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    if completed {
      if let vc = pageVC.viewControllers![0] as? BaseViewController {
        selectedIdx = vc.pageIdx
        menuView.move(selectedIdx)
      }
    }
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    let vc = viewController as! BaseViewController
    var index = vc.pageIdx

    if index == 0 || index == NSNotFound {
      return nil
    }

    index -= 1

    return viewControllerAtIndex(index: index)
  }

  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let vc = viewController as! BaseViewController
    var index = vc.pageIdx

    if index == NSNotFound {
      return nil
    }

    index += 1

    if index == WebtoonDetailViewType.count {
      return nil
    }

    return viewControllerAtIndex(index: index)
  }
}
