//
//  FavoriteListViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/29.
//

import UIKit

enum FavoriteListViewType: Int, CaseIterable {
    case recents
    case favorite
    
    var title: String {
        switch self {
        case .recents: return "최근 본 작품"
        case .favorite: return "즐겨찾기"
        }
    }

    static let count = 2
}

protocol FavoriteListViewControllerDelegate: AnyObject {
    func didWebtoonFavoriteListViewController(controller: FavoriteListViewController, webtoon: Webtoon)
}

class FavoriteListViewController: BaseViewController {
    
    // MARK: - Vars
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var activity: CustomActivity!

    var type: FavoriteListViewType = .recents

    weak var delegate: FavoriteListViewControllerDelegate?
    
    // MARK: - Life Cycle
    
    func initVars() {
        
    }
    
    func initBackgroundView() {
        self.view.backgroundColor = kWHITE
    }
    
    func initTableView() {
        let listCell = UINib.init(nibName: kFavoriteListCellID, bundle: nil)
        self.mainTableView.register(listCell, forCellReuseIdentifier: kFavoriteListCellID)
        
        let nodataCell = UINib.init(nibName: kGeneralNodataCellID, bundle: nil)
        self.mainTableView.register(nodataCell, forCellReuseIdentifier: kGeneralNodataCellID)
        
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.separatorStyle = .none
        self.mainTableView.backgroundColor = kWHITE
        self.mainTableView.rowHeight = UITableView.automaticDimension
        self.mainTableView.estimatedRowHeight = 200.0
        self.mainTableView.sectionHeaderHeight = UITableView.automaticDimension
        self.mainTableView.estimatedSectionHeaderHeight = 44.0
        self.mainTableView.contentInset = UIEdgeInsets.init(top: 16.0, left: 0.0, bottom: 16.0, right: 0.0)
        self.mainTableView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.initVars()
        self.initBackgroundView()
        self.initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.mainTableView.reloadData()
        }
    }
    
}

// MARK: - UITableView

extension FavoriteListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.type == .recents, GeneralHelper.sharedInstance.recentItem.webtoons.count > 0 {
            return GeneralHelper.sharedInstance.recentItem.webtoons.count
        }
        else if self.type == .favorite, GeneralHelper.sharedInstance.favoriteItem.webtoons.count > 0 {
            return GeneralHelper.sharedInstance.favoriteItem.webtoons.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.type == .recents, GeneralHelper.sharedInstance.recentItem.webtoons.count > 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: kFavoriteListCellID, for: indexPath) as? FavoriteListCell {
            let webtoonItem = GeneralHelper.sharedInstance.recentItem.webtoons[indexPath.row]
            cell.bind(webtoonItem, self.type)
            cell.delegate = self
            
            return cell
        }
        else if self.type == .favorite, GeneralHelper.sharedInstance.favoriteItem.webtoons.count > 0,
                let cell = tableView.dequeueReusableCell(withIdentifier: kFavoriteListCellID, for: indexPath) as? FavoriteListCell {
            let webtoonItem = GeneralHelper.sharedInstance.favoriteItem.webtoons[indexPath.row]
            cell.bind(webtoonItem, self.type)
            cell.delegate = self
            
            return cell
        }
        else if let cell = tableView.dequeueReusableCell(withIdentifier: kGeneralNodataCellID, for: indexPath) as? GeneralNodataCell {
            
            switch self.type {
            case .recents:
                cell.bind("empty_lastseen", "최근 본 작품이 없어요 😭")
            case .favorite:
                cell.bind("empty_favorite", "즐겨찾는 작품이 없어요 😭")
            }
            
            return cell
        }
                    
        return .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.type == .recents, GeneralHelper.sharedInstance.recentItem.webtoons.count > 0 {
            let webtoonItem = GeneralHelper.sharedInstance.recentItem.webtoons[indexPath.row]
            self.delegate?.didWebtoonFavoriteListViewController(controller: self, webtoon: webtoonItem)
        }
        else if self.type == .favorite, GeneralHelper.sharedInstance.favoriteItem.webtoons.count > 0 {
            let webtoonItem = GeneralHelper.sharedInstance.favoriteItem.webtoons[indexPath.row]
            self.delegate?.didWebtoonFavoriteListViewController(controller: self, webtoon: webtoonItem)
        }
    }
    
}

// MARK: - FavoriteListCell

extension FavoriteListViewController: FavoriteListCellDelegate {
    
    func didEventFavoriteListCell(cell: FavoriteListCell) {
        guard let idx = self.mainTableView.indexPath(for: cell)?.row else { return }
        
        GeneralHelper.sharedInstance.doVibrate()
        
        switch cell.type {
        case .recents:
            let webtoonItem = GeneralHelper.sharedInstance.recentItem.webtoons[idx]
            self.removeRecent(webtoonItem)
        case .favorite:
            let webtoonItem = GeneralHelper.sharedInstance.favoriteItem.webtoons[idx]
            self.removeFavorite(webtoonItem)
        case .none:
            return
        }
    }
    
    func removeRecent(_ webtoonItem: Webtoon) {
        guard let idx = GeneralHelper.sharedInstance.recentItem.webtoons.firstIndex(where: { $0.id == webtoonItem.id }) else  {
            return
        }

        GeneralHelper.sharedInstance.removeRecentWebtoon(webtoonItem)
        
        if GeneralHelper.sharedInstance.recentItem.webtoons.count == 0 {
            self.mainTableView.reloadData()
        }
        else {
            self.mainTableView.deleteRows(at: [IndexPath.init(row: idx, section: 0)], with: .left)
        }
    }
    
    func removeFavorite(_ webtoonItem: Webtoon) {
        guard let idx = GeneralHelper.sharedInstance.favoriteItem.webtoons.firstIndex(where: { $0.id == webtoonItem.id }) else  {
            return
        }

        GeneralHelper.sharedInstance.removeFavoriteWebtoon(webtoonItem)
        
        if GeneralHelper.sharedInstance.favoriteItem.webtoons.count == 0 {
            self.mainTableView.reloadData()
        }
        else {
            self.mainTableView.deleteRows(at: [IndexPath.init(row: idx, section: 0)], with: .left)
        }
    }
    
}

// MARK: - Activity

extension FavoriteListViewController {
    
    func startActivity() {
        if self.activity.isAnimating() { return }
        self.activity.start()
    }
    
    func stopActivity() {
        if !self.activity.isAnimating() { return }
        self.activity.stop()
    }
    
}
