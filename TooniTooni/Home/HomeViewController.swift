//
//  ViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/12.
//

import UIKit

protocol HomeViewSectionTitle {
    var title: String? { get }
}

enum HomeViewType: Int, HomeViewSectionTitle {
    case banner
    case weekday
    case popular
    case genre
    case binge
    
    var title: String? {
        switch self {
        case .banner:
            return nil
        case .weekday:
            return "불금 추천 투니"
        case .popular:
            return "인기 급상승 투니"
        case .genre:
            return "장르별 추천 투니"
        case .binge:
            return "정주행하기 좋은 투니"
        }
    }
    
    static let count = 5
}

class HomeViewController: BaseViewController {

    // MARK: - Vars
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var activity: GeneralActivity!

    var home: Home? {
        didSet {
            DispatchQueue.main.async {
                self.stopActivity()
                self.mainTableView.reloadData()
            }
        }
    }

    // MARK: - Life Cycle
    
    func initVars() {
        self.showBigTitle = false
    }
    
    func initBackgroundView() {
        self.view.backgroundColor = kWHITE
    }
        
    func initTableView() {
        let headerView = UINib.init(nibName: kGeneralTitleHeaderViewID, bundle: nil)
        self.mainTableView.register(headerView, forHeaderFooterViewReuseIdentifier: kGeneralTitleHeaderViewID)
                
        let newCell = UINib.init(nibName: kHomeNewListCellID, bundle: nil)
        self.mainTableView.register(newCell, forCellReuseIdentifier: kHomeNewListCellID)
        
        let webtoonCell = UINib.init(nibName: kHomeWebtoonListCellID, bundle: nil)
        self.mainTableView.register(webtoonCell, forCellReuseIdentifier: kHomeWebtoonListCellID)
        
        let popularCell = UINib.init(nibName: kHomePopularCellID, bundle: nil)
        self.mainTableView.register(popularCell, forCellReuseIdentifier: kHomePopularCellID)
        
        let genreCell = UINib.init(nibName: kHomeGenreListCellID, bundle: nil)
        self.mainTableView.register(genreCell, forCellReuseIdentifier: kHomeGenreListCellID)
        
        let driveCell = UINib.init(nibName: kHomeDriveCellID, bundle: nil)
        self.mainTableView.register(driveCell, forCellReuseIdentifier: kHomeDriveCellID)
                
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.separatorStyle = .none
        self.mainTableView.backgroundColor = kWHITE
        self.mainTableView.rowHeight = UITableView.automaticDimension
        self.mainTableView.estimatedRowHeight = 200.0
        self.mainTableView.sectionHeaderHeight = UITableView.automaticDimension
        self.mainTableView.estimatedSectionHeaderHeight = 44.0
        self.mainTableView.contentInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        self.mainTableView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.initVars()
        self.initBackgroundView()
        self.initTableView()
        
        self.startActivity()
        self.fetchHome()
    }

}

// MARK: - Event

extension HomeViewController {
    
    @objc
    func doSearch() {
        self.showReadyAlert(vc: self)
    }
    
}

// MARK: - Home

extension HomeViewController {
    
    func fetchHome() {        
        TooniNetworkService.shared.request(to: .home, decoder: Home.self) { [unowned self] response in
            switch response.result {
            case .success:
                guard let home = response.json as? Home else { return }
                
                self.home = home
            case .failure:
                print(response)
            }
        }
    }

}

// MARK: - UITableView

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeViewType.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == HomeViewType.weekday.rawValue,
           let weekdayList = self.home?.weekdayList, weekdayList.count > 0 {
            return 1
        }
        else if section == HomeViewType.popular.rawValue,
           let trendingList = self.home?.trendingList, trendingList.count > 0 {
            return trendingList.count
        }
        else if section == HomeViewType.genre.rawValue,
                let genreList = self.home?.genreList, genreList.count > 0 {
            return 1
        }
        else if section == HomeViewType.binge.rawValue,
                let bingeList = self.home?.bingeList, bingeList.count > 0 {
            return bingeList.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kGeneralTitleHeaderViewID) as? GeneralTitleHeaderView,
           let title = HomeViewType.init(rawValue: section)?.title {
            headerView.bind(title)
            
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let _ = HomeViewType.init(rawValue: section)?.title {
            return UITableView.automaticDimension
        }
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == HomeViewType.weekday.rawValue,
           let weekdayList = self.home?.weekdayList, weekdayList.count > 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: kHomeWebtoonListCellID, for: indexPath) as? HomeWebtoonListCell {
            cell.bind(weekdayList)
            
            return cell
        }
        else if indexPath.section == HomeViewType.popular.rawValue,
                let trendingList = self.home?.trendingList, trendingList.count > 0,
                let cell = tableView.dequeueReusableCell(withIdentifier: kHomePopularCellID, for: indexPath) as? HomePopularCell {
            let webtoonItem = trendingList[indexPath.row]
            cell.bind(webtoonItem)
            
            return cell
        }
        else if indexPath.section == HomeViewType.genre.rawValue,
                let genreList = self.home?.genreList, genreList.count > 0,
                let cell = tableView.dequeueReusableCell(withIdentifier: kHomeGenreListCellID, for: indexPath) as? HomeGenreListCell {
            cell.bind(genreList)
            
            return cell
        }
        else if indexPath.section == HomeViewType.binge.rawValue,
                let bingeList = self.home?.bingeList, bingeList.count > 0,
                let cell = tableView.dequeueReusableCell(withIdentifier: kHomeDriveCellID, for: indexPath) as? HomeDriveCell {
            let webtoonItem = bingeList[indexPath.row]
            cell.bind(webtoonItem)

            return cell
        }
        
        return .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

// MARK: - Activity

extension HomeViewController {
    
    func startActivity() {
        if self.activity.isAnimating() { return }
        self.activity.start()
    }
    
    func stopActivity() {
        if !self.activity.isAnimating() { return }
        self.activity.stop()
    }
    
}

