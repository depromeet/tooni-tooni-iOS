//
//  HomeGenreViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/05.
//

import UIKit

enum HomeGenreType: Int, CaseIterable {
    case life
    case fantasy
    case action
    case drama
    case romance
    
    var title: String {
        switch self {
        case .life: return "일상"
        case .fantasy: return "판타지"
        case .action: return "액션"
        case .drama: return "드라마"
        case .romance: return "순정"
        }
    }
    
    static let count = 5
}

class HomeGenreViewController: BaseViewController {
    
    // MARK: - Vars
    
    @IBOutlet weak var navigationView: GeneralNavigationView!
    @IBOutlet weak var menuView: GenreHeaderView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var activity: CustomActivity!

    let titleList = ["일상", "판타지", "액션", "드라마", "순정"]

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
        self.navigationView.bgColor(kWHITE)
        self.navigationView.title("장르별 추천 투니")
        self.navigationView.bigTitle(self.showBigTitle)
        self.navigationView.leftButton(true)
        
        self.navigationView.leftButton.isHidden = false
        self.navigationView.leftButton.setImage(UIImage.init(named: "icon_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.navigationView.leftButton.tintColor = kGRAY_90
        self.navigationView.leftButton.addTarget(self, action: #selector(doBack), for: .touchUpInside)
    }

    func initMenuView() {
        self.menuView.delegate = self
        self.menuView.bind(self.selectedIdx)
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

extension HomeGenreViewController {
    
    @objc
    func doBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - GeneralMenuView

extension HomeGenreViewController: GenreHeaderViewDelegate {
    
    func didMenuGenreHeaderView(view: GenreHeaderView, idx: Int) {
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

extension HomeGenreViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func viewControllerAtIndex(index: Int) -> BaseViewController {
        if let vc = GeneralHelper.sharedInstance.makeVC("Home", "HomeGenreListViewController") as? HomeGenreListViewController {
            vc.pageIdx = index
            vc.type = HomeGenreType.init(rawValue: index)!
//            vc.delegate = self
            
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
        
        if index == HomeGenreType.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index: index)
    }
        
}
