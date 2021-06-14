//
//  GeneralHelper.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/12.
//

import UIKit
import AudioToolbox

let kFAVORITE_WEBTOON_LIST =                                    "FAVORITE_WEBTOON_LIST"
let kRECENT_WEBTOON_LIST =                                      "RECENT_WEBTOON_LIST"
let kRECENT_SEARCH_LIST =                                       "RECENT_SEARCH_LIST"

class GeneralHelper {

    // MARK: - Vars
    
    var user: User?
    
    var tabList: [TabItem] = []
    
    var recentItem = RecentItem()
    var favoriteItem = FavoriteItem()
    var searchList: [String] = []
        
    static let sharedInstance = GeneralHelper()
    
    // MARK: - Life Cycle
    
    func setup() {
        self.initTabList()
        
        self.fetchSearches()
        self.fetchRecentWebtoons()
        self.fetchFavoriteWebtoons()
    }

}

// MARK: - User

extension GeneralHelper {

    func isSigning() -> Bool {
        return self.user == nil ? false : true
    }
    
    func loginToken() -> String? {
        return self.user?.loginToken
    }
    
}

// MARK: - Vibrate

extension GeneralHelper {
    
    func doVibrate() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

}

// MARK: - Search

extension GeneralHelper {
    
    func existSearches(_ text: String) -> Bool {
        return self.searchList.contains(where: { $0 == text })
    }

    func addSearches(_ text: String) {
        if let idx = self.searchList.firstIndex(where: { $0 == text }) {
            self.searchList.remove(at: idx)
            self.searchList.insert(text, at: 0)
        }
        else {
            self.searchList.insert(text, at: 0)
        }
        
        self.saveSearches()
    }
    
    func removeSearches(_ text: String) {
        if let idx = self.searchList.firstIndex(where: { $0 == text }) {
            self.searchList.remove(at: idx)
        }
        
        self.saveSearches()
    }

    func fetchSearches() {
        if let searchList = UserDefaults.standard.object(forKey: kRECENT_SEARCH_LIST) as? [String] {
            self.searchList = searchList
        }
        else {
            self.searchList = []
        }
        
        print("fetchSearches: \( self.searchList)")
    }
    
    func saveSearches() {
        if self.searchList.count > 5 {
            self.searchList = Array(self.searchList[0..<5])
        }
        
        self.saveUserDefault(item: self.searchList, key: kRECENT_SEARCH_LIST)
        self.fetchSearches()
    }
    
}

// MARK: - Recent

extension GeneralHelper {
    
    func existRecents(_ webtoon: Webtoon) -> Bool {
        return self.recentItem.webtoons.contains(where: { $0.id == webtoon.id })
    }

    func addRecentWebtoon(_ webtoon: Webtoon) {
        if let idx = self.recentItem.webtoons.firstIndex(where: { $0.id == webtoon.id }) {
            let webtoon = self.recentItem.webtoons[idx]
            self.recentItem.webtoons.remove(at: idx)
            self.recentItem.webtoons.insert(webtoon, at: 0)
        }
        else {
            self.recentItem.webtoons.insert(webtoon, at: 0)
        }
        
        self.saveRecentWebtoons()
    }
    
    func removeRecentWebtoon(_ webtoon: Webtoon) {
        if let idx = self.recentItem.webtoons.firstIndex(where: { $0.id == webtoon.id }) {
            self.recentItem.webtoons.remove(at: idx)
        }
        
        self.saveRecentWebtoons()
    }

    func fetchRecentWebtoons() {
        if let data = UserDefaults.standard.object(forKey: kRECENT_WEBTOON_LIST) as? Data,
           let recentItem = try? JSONDecoder.init().decode(RecentItem.self, from: data) {
            self.recentItem = recentItem
        }
        else {
            self.recentItem = RecentItem()
        }
        
        print("fetchRecentWebtoons: \( self.recentItem)")
    }
    
    func saveRecentWebtoons() {
        if let encodedData = try? JSONEncoder().encode(self.recentItem) {
            self.saveUserDefault(item: encodedData, key: kRECENT_WEBTOON_LIST)
        }

        self.fetchRecentWebtoons()
    }
    
}

// MARK: - Favorite

extension GeneralHelper {
    
    func existFavorite(_ webtoon: Webtoon) -> Bool {
        return self.favoriteItem.webtoons.contains(where: { $0.id == webtoon.id })
    }
    
    func addFavoriteWebtoon(_ webtoon: Webtoon) {
        if let idx = self.favoriteItem.webtoons.firstIndex(where: { $0.id == webtoon.id }) {
            let webtoon = self.favoriteItem.webtoons[idx]
            self.favoriteItem.webtoons.remove(at: idx)
            self.favoriteItem.webtoons.insert(webtoon, at: 0)
        }
        else {
            self.favoriteItem.webtoons.insert(webtoon, at: 0)
        }
        
        self.saveFavoriteWebtoons()
    }
    
    func removeFavoriteWebtoon(_ webtoon: Webtoon) {
        if let idx = self.favoriteItem.webtoons.firstIndex(where: { $0.id == webtoon.id }) {
            self.favoriteItem.webtoons.remove(at: idx)
        }
        
        self.saveFavoriteWebtoons()
    }
    
    func fetchFavoriteWebtoons() {
        if let data = UserDefaults.standard.object(forKey: kFAVORITE_WEBTOON_LIST) as? Data,
           let favoriteItem = try? JSONDecoder.init().decode(FavoriteItem.self, from: data) {
            self.favoriteItem = favoriteItem
        }
        else {
            self.favoriteItem = FavoriteItem()
        }
        
        print("fetchFavoriteWebtoons: \( self.favoriteItem)")
    }
    
    func saveFavoriteWebtoons() {
        if let encodedData = try? JSONEncoder().encode(self.favoriteItem) {
            self.saveUserDefault(item: encodedData, key: kFAVORITE_WEBTOON_LIST)
        }

        self.fetchFavoriteWebtoons()
    }
    
}

// MARK: - User Default

extension GeneralHelper {
    
    func saveUserDefault(item: Any?, key: String) {
        UserDefaults.standard.set(item, forKey: key)
        UserDefaults.standard.synchronize()
    }

}

// MARK: - Tab

extension GeneralHelper {

    func initTabList() {
        let homeItem = TabItem.init(storyBoard: "Home",
                                    viewController: "HomeViewController",
                                    title: "홈",
                                    iconImage: "icon_tab_0",
                                    type: .home)
        let weekdayItem = TabItem.init(storyBoard: "Week",
                                       viewController: "WeekViewController",
                                       title: "요일별",
                                       iconImage: "icon_tab_1",
                                       type: .weekday)
        let favoriteItem = TabItem.init(storyBoard: "Favorite",
                                       viewController: "FavoriteViewController",
                                       title: "마이툰",
                                       iconImage: "icon_tab_2",
                                       type: .favorite)
        let settingsItem = TabItem.init(storyBoard: "Settings",
                                       viewController: "SettingsViewController",
                                       title: "더보기",
                                       iconImage: "icon_tab_3",
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
