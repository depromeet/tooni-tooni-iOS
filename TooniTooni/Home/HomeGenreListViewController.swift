//
//  HomeGenreListViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/05.
//

import UIKit

class HomeGenreListViewController: BaseViewController {
    
    // MARK: - Vars
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var activity: CustomActivity!
    
    var type: HomeGenreType!
    var genreList: [Webtoon]? {
        didSet {
            DispatchQueue.main.async {
                self.stopActivity()
                self.mainTableView.reloadData()
            }
        }
    }
    
    // MARK: - Life Cycle
    
    func initVars() {
        
    }
    
    func initBackgroundView() {
        self.view.backgroundColor = kWHITE
    }
    
    func initTableView() {
        let listCell = UINib.init(nibName: kHomePopularCellID, bundle: nil)
        self.mainTableView.register(listCell, forCellReuseIdentifier: kHomePopularCellID)
        
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
        
        self.startActivity()
        self.fetchGenre()
    }
        
}

// MARK: - Event

extension HomeGenreListViewController {
    
    func openDetailVC(_ webtoonItem: Webtoon) {
        guard let vc = GeneralHelper.sharedInstance.makeVC("Webtoon", "WebtoonDetailViewController") as? WebtoonDetailViewController else {
            return
        }
        
        vc.webtoonItem = webtoonItem
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - Genre

extension HomeGenreListViewController {

    func fetchGenre() {
        let genre = self.type.title
        TooniNetworkService.shared.request(to: .genre(genre), decoder: Genre.self) { [weak self] response in
            switch response.result {
            case .success:
                guard let genre = response.json as? Genre else { return }
                
                self?.genreList = genre.top20Webtoons
            case .failure:
                print(response)
            }
        }
    }
}

// MARK: - UITableView

extension HomeGenreListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let genreList = self.genreList, genreList.count > 0 {
            return genreList.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let genreList = self.genreList, genreList.count > 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: kHomePopularCellID, for: indexPath) as? HomePopularCell {
            let webtoonItem = genreList[indexPath.row]
            cell.bind(webtoonItem)

            return cell
        }
                
        return .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let genreList = self.genreList, genreList.count > 0 {
            let webtoonItem = genreList[indexPath.row]
            self.openDetailVC(webtoonItem)
        }
    }
    
}

// MARK: - Activity

extension HomeGenreListViewController {
    
    func startActivity() {
        if self.activity.isAnimating() { return }
        self.activity.start()
    }
    
    func stopActivity() {
        if !self.activity.isAnimating() { return }
        self.activity.stop()
    }
    
}

