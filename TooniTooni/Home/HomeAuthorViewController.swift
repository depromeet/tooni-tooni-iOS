//
//  HomeAuthorViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/11.
//

import UIKit

class HomeAuthorViewController: BaseViewController {
    
    // MARK: - Vars
    
    @IBOutlet weak var navigationView: GeneralNavigationView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var activity: CustomActivity!

    var authorItem: Author!
    
    var webtoonList: [Webtoon]? {
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
    
    func initNavigationView() {
        self.navigationView.bgColor(kWHITE)
        
        if let name = self.authorItem.name {
            self.navigationView.title("\(name) 작가님의 투니")
        }
        
        self.navigationView.bigTitle(self.showBigTitle)
        self.navigationView.leftButton(true)
        
        self.navigationView.leftButton.isHidden = false
        self.navigationView.leftButton.setImage(UIImage.init(named: "icon_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.navigationView.leftButton.tintColor = kGRAY_90
        self.navigationView.leftButton.addTarget(self, action: #selector(doBack), for: .touchUpInside)
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
        self.initNavigationView()
        self.initTableView()
        
        self.startActivity()
        self.fetchRandom()
    }
    
}

// MARK: - Random

extension HomeAuthorViewController {
    
    func fetchRandom() {
        guard let authorId = self.authorItem.id?.string else { return }
        
        TooniNetworkService.shared.request(to: .author(authorId), decoder: WeekWebtoon.self) { [weak self] response in
            switch response.result {
            case .success:
                guard let webtoonList = response.json as? WeekWebtoon else { return }
                
                self?.webtoonList = webtoonList.webtoons
            case .failure:
                print(response)
            }
        }
    }
    
}

// MARK: - Event

extension HomeAuthorViewController {
    
    @objc
    func doBack() {
        self.navigationController?.popViewController(animated: true)
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

// MARK: - UITableView

extension HomeAuthorViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let webtoonList = self.webtoonList, webtoonList.count > 0 {
            return webtoonList.count
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
        if let webtoonList = self.webtoonList, webtoonList.count > 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: kHomePopularCellID, for: indexPath) as? HomePopularCell {
            let webtoonItem = webtoonList[indexPath.row]
            cell.bind(webtoonItem)

            return cell
        }
                
        return .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
     
        if let webtoonList = self.webtoonList, webtoonList.count > 0 {
            let webtoonItem = webtoonList[indexPath.row]
            self.openDetailVC(webtoonItem)
        }
    }
    
}

// MARK: - Activity

extension HomeAuthorViewController {
    
    func startActivity() {
        if self.activity.isAnimating() { return }
        self.activity.start()
    }
    
    func stopActivity() {
        if !self.activity.isAnimating() { return }
        self.activity.stop()
    }
    
}


