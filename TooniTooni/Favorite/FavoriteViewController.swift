//
//  FavoriteViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/12.
//

import UIKit

class FavoriteViewController: BaseViewController {

  // MARK: - Vars

  @IBOutlet var navigationView: GeneralNavigationView!
  @IBOutlet var menuView: WebtoonMenuView!
  @IBOutlet var baseView: UIView!

  var pageVC: UIPageViewController!

  // MARK: - Life Cycle

  func initBackgroundView() {
    view.backgroundColor = kWHITE
  }

  func initNavigationView() {
    navigationView.title(tabItem?.title)
    navigationView.bigTitle(showBigTitle)
  }

//  func initPageView() {
//    pageVC = GeneralHelper.sharedInstance.makePageVC("WebtoonDetail", "WebtoonDetailPageViewController")
//    pageVC.delegate = self
//    pageVC.dataSource = self
//    let startVC = viewControllerAtIndex(index: selectedIdx)
//    let viewControllers = [startVC]
//
//    pageVC.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
//
//    view.layoutIfNeeded()
//
//    pageVC.view.frame = baseView.bounds
//    addChild(pageVC)
//    baseView.addSubview(pageVC.view)
//  }
//
//  func initMenuView() {
//    menuView.bind(selectedIdx, site: webtoon?.site)
//    menuView.didMenuWeekMenuView = { [weak self] menuView, idx in
//      guard let self = self else { return }
//      if self.selectedIdx == idx { return }
//
//      var direction: UIPageViewController.NavigationDirection = .forward
//      if idx < self.selectedIdx {
//        direction = .reverse
//      }
//
//      self.selectedIdx = idx
//
//      let startVC = self.viewControllerAtIndex(index: self.selectedIdx)
//      let viewControllers = [startVC]
//
//      self.pageVC.setViewControllers(viewControllers, direction: direction, animated: true, completion: nil)
//    }
//  }

  override func viewDidLoad() {
    super.viewDidLoad()

    initBackgroundView()
    initNavigationView()
  }
}
//
//// MARK: - PageViewController
//
//extension FavoriteViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//
//  func viewControllerAtIndex(index: Int) -> BaseViewController {
//    switch WebtoonMenuType(rawValue: index) {
//    case .home:
//      if let vc = embededViewControllers[index] as? DetailHomeViewController {
//        vc.pageIdx = index
//        vc.webtoon = webtoon
//        vc.didScroll = { [weak self] scrollView in
//          DispatchQueue.main.async {
//            self?.didScrollAnimating(with: scrollView)
//          }
//        }
//
//        vc.didTapToalComment = { [weak self] button in
//          guard let self = self else { return }
//          self.selectedIdx += 1
//
//          let startVC = self.viewControllerAtIndex(index: self.selectedIdx)
//          self.pageVC.setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
//          self.menuView.move(self.selectedIdx)
//
//          self.webtoonMenuViewTopConstraint.constant -= Metric.maxMenuViewTopConstraint
//          self.statusBarView.backgroundColor = kWHITE
//          self.navigationView.bgColor(.white)
//          self.navigationView.leftButton.setImage(
//            UIImage(named: "icon_arrow_round_back"),
//            for: .normal
//          )
//        }
//
//        return vc
//      }
//
//      return .init()
//    case .comment:
//      if let vc = embededViewControllers[index] as? DetailCommentViewController {
//        vc.pageIdx = index
//        vc.webtoon = webtoon
//
//        vc.didScroll = { [weak self] scrollView in
//          DispatchQueue.main.async {
//            self?.didScrollAnimating(with: scrollView)
//          }
//        }
//
//        return vc
//      }
//
//      return .init()
//    default:
//      return .init()
//    }
//  }
//
//  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//    if completed {
//      if let vc = pageVC.viewControllers![0] as? BaseViewController {
//        selectedIdx = vc.pageIdx
//        menuView.move(selectedIdx)
//      }
//    }
//  }
//
//  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//    let vc = viewController as! BaseViewController
//    var index = vc.pageIdx
//
//    if index == 0 || index == NSNotFound {
//      return nil
//    }
//
//    index -= 1
//
//    return viewControllerAtIndex(index: index)
//  }
//
//  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//    let vc = viewController as! BaseViewController
//    var index = vc.pageIdx
//
//    if index == NSNotFound {
//      return nil
//    }
//
//    index += 1
//
//    if index == WebtoonDetailViewType.count {
//      return nil
//    }
//
//    return viewControllerAtIndex(index: index)
//  }
//}
