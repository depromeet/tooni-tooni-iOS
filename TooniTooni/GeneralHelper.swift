//
//  GeneralHelper.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/12.
//

import UIKit
import AudioToolbox

class GeneralHelper {

    // MARK: - Vars
    
    var tabList: [TabItem] = [] 
        
    static let sharedInstance = GeneralHelper()
    
    // MARK: - Life Cycle
    
    func setup() {
        self.initTabList()
    }

}

// MARK: - Tab

extension GeneralHelper {

    func initTabList() {
        let homeItem = TabItem.init(storyBoard: "Home",
                                    viewController: "HomeViewController",
                                    title: "홈",
                                    type: .home)
        let weekdayItem = TabItem.init(storyBoard: "Week",
                                       viewController: "WeekViewController",
                                       title: "요일별",
                                       type: .weekday)
        let favoriteItem = TabItem.init(storyBoard: "Favorite",
                                       viewController: "FavoriteViewController",
                                       title: "즐겨찾기",
                                       type: .favorite)
        let settingsItem = TabItem.init(storyBoard: "Settings",
                                       viewController: "SettingsViewController",
                                       title: "설정",
                                       type: .settings)

        self.tabList = [homeItem, weekdayItem, favoriteItem, settingsItem]
    }

}

// MARK: - Make ViewController

extension GeneralHelper {

    func makeVC(_ storyBoard: String, _ viewController: String) -> BaseViewController {
        let sb = UIStoryboard.init(name: storyBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewController) as! BaseViewController
        
        return vc
    }
        
    func makePageVC(_ storyBoard: String, _ viewController: String) -> UIPageViewController {
        let sb = UIStoryboard.init(name: storyBoard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: viewController) as! UIPageViewController
        
        return vc
    }

    func makeTabBarVC(_ storyBoard: String, _ viewController: String) -> UITabBarController {
        let sb: UIStoryboard = UIStoryboard.init(name: storyBoard, bundle: nil)
        let vc: BaseTabBarViewController = sb.instantiateViewController(withIdentifier: viewController) as! BaseTabBarViewController
        
        return vc
    }

}
