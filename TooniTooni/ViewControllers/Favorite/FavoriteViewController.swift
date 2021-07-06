//
//  FavoriteViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/12.
//

import UIKit

class FavoriteViewController: BaseViewController {

    // MARK: - Vars
    
    @IBOutlet weak var navigationView: GeneralNavigationView!
    @IBOutlet weak var menuView: GeneralMenuView!
    @IBOutlet weak var baseView: UIView!

    let titleList = ["최근 본 작품", "즐겨찾기"]
    
    var pageVC: UIPageViewController!
    var selectedIdx = 0
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.showBigTitle = false
    }
    
    func initBackgroundView() {
        self.view.backgroundColor = kWHITE
    }
    
    func initNavigationView() {
        self.setInteractiveRecognizer()
        
        self.navigationView.title("마이툰")
        self.navigationView.bigTitle(self.showBigTitle)
        
        self.navigationView.rightButton.isHidden = false
        self.navigationView.rightButton.setImage(UIImage.init(named: "icon_search"), for: .normal)
        self.navigationView.rightButton.addTarget(self, action: #selector(doSearch), for: .touchUpInside)
    }
    
    func initMenuView() {
        self.menuView.delegate = self
        self.menuView.bind(self.selectedIdx, self.titleList)
    }
    
    func initPageView() {
        self.pageVC = GeneralHelper.sharedInstance.makePageVC("Favorite", "FavoritePageViewController")
        self.pageVC.delegate = self
        self.pageVC.dataSource = self
        let startVC = self.viewControllerAtIndex(index: self.selectedIdx)
        let viewControllers = [startVC]
        
        self.pageVC.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        
        self.view.layoutIfNeeded()
        
        self.pageVC.view.frame = self.baseView.bounds
        self.addChild(self.pageVC)
        self.baseView.addSubview(self.pageVC.view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.initVars()
        self.initBackgroundView()
        self.initNavigationView()
        self.initMenuView()
        self.initPageView()
    }

}

// MARK: - Event

extension FavoriteViewController {
    
    @objc
    func doSearch() {
        self.openSearchVC()
    }
    
    func openSearchVC() {
        if let vc = GeneralHelper.sharedInstance.makeVC("Search", "SearchViewController") as? SearchViewController {
            vc.hidesBottomBarWhenPushed = true

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

// MARK: - GeneralMenuView

extension FavoriteViewController: GeneralMenuViewDelegate {
    
    func didMenuGeneralMenuView(view: GeneralMenuView, idx: Int) {
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

// MARK: - PageViewController

extension FavoriteViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func viewControllerAtIndex(index: Int) -> BaseViewController {
        if let vc = GeneralHelper.sharedInstance.makeVC("Favorite", "FavoriteListViewController") as? FavoriteListViewController {
            vc.pageIdx = index
            vc.type = FavoriteListViewType.init(rawValue: index)!
            vc.delegate = self
            
            return vc
        }
        
        return .init()
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            if let vc = self.pageVC.viewControllers![0] as? BaseViewController {
                self.selectedIdx = vc.pageIdx
                self.menuView.move(self.selectedIdx)
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
        
        return self.viewControllerAtIndex(index: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! BaseViewController
        var index = vc.pageIdx
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == FavoriteListViewType.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index: index)
    }
        
}

// MARK: - FavoriteListViewController

extension FavoriteViewController: FavoriteListViewControllerDelegate {
    
    func didWebtoonFavoriteListViewController(controller: FavoriteListViewController, webtoon: Webtoon) {
        self.openDetailVC(webtoon)
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
