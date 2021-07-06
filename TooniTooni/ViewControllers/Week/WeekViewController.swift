//
//  WeekViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/12.
//

import UIKit

class WeekViewController: BaseViewController {

    // MARK: - Vars
    
    @IBOutlet weak var navigationView: GeneralNavigationView!
    @IBOutlet weak var menuView: WeekMenuView!
    @IBOutlet weak var baseView: UIView!
    
    var pageVC: UIPageViewController!
    var selectedIdx = WeekMenuType.currentWeekday

    // MARK: - Life Cycle
    
    func initVars() {
        self.showBigTitle = false
    }
    
    func initBackgroundView() {
        self.view.backgroundColor = kWHITE
    }
    
    func initNavigationView() {
        self.setInteractiveRecognizer()
        
        self.navigationView.title("요일별 투니")
        self.navigationView.bigTitle(self.showBigTitle)
        
        self.navigationView.rightButton.isHidden = false
        self.navigationView.rightButton.setImage(UIImage.init(named: "icon_search"), for: .normal)
        self.navigationView.rightButton.addTarget(self, action: #selector(doSearch), for: .touchUpInside)
    }
    
    func initMenuView() {
        self.menuView.delegate = self
        self.menuView.bind(self.selectedIdx)
    }
    
    func initPageView() {
        self.pageVC = GeneralHelper.sharedInstance.makePageVC("Week", "WeekPageViewController")
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

extension WeekViewController {
    
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

// MARK: - WeekMenuView

extension WeekViewController: WeekMenuViewDelegate {
    
    func didMenuWeekMenuView(view: WeekMenuView, idx: Int) {
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

extension WeekViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func viewControllerAtIndex(index: Int) -> BaseViewController {
        if let vc = GeneralHelper.sharedInstance.makeVC("Week", "WeekListViewController") as? WeekListViewController {
            vc.pageIdx = index
            
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
        
        if index == WeekMenuType.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index: index)
    }
        
}
