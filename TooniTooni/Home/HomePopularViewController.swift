//
//  HomePopularViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/29.
//

import UIKit

class HomePopularViewController: BaseViewController {
    
    // MARK: - Vars
    
    @IBOutlet weak var navigationView: GeneralNavigationView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var activity: CustomActivity!

    var popularList: [Webtoon]? {
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
        self.navigationView.title("인기 급상승 투니")
        self.navigationView.bigTitle(self.showBigTitle)
        self.navigationView.leftButton(true)
        
        self.navigationView.leftButton.isHidden = false
        self.navigationView.leftButton.setImage(UIImage.init(named: "icon_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.navigationView.leftButton.tintColor = kGRAY_90
        self.navigationView.leftButton.addTarget(self, action: #selector(doBack), for: .touchUpInside)
        
        self.titleLabel.textColor = kGRAY_90
        self.titleLabel.font = kBODY1_BOLD
        self.titleLabel.text = "🔥 TOP 20 🔥"
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

extension HomePopularViewController {
    
    func fetchRandom() {
        TooniNetworkService.shared.request(to: .random, decoder: RandomItem.self) { [weak self] response in
            switch response.result {
            case .success:
                guard let popularList = response.json as? RandomItem else { return }
                
                self?.popularList = popularList.webtoons
            case .failure:
                print(response)
            }
        }
    }
    
}

// MARK: - Event

extension HomePopularViewController {
    
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

extension HomePopularViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let popularList = self.popularList, popularList.count > 0 {
            return popularList.count
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
        if let popularList = self.popularList, popularList.count > 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: kHomePopularCellID, for: indexPath) as? HomePopularCell {
            let webtoonItem = popularList[indexPath.row]
            cell.bind(webtoonItem)

            return cell
        }
                
        return .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
     
        if let popularList = self.popularList, popularList.count > 0 {
            let webtoonItem = popularList[indexPath.row]
            self.openDetailVC(webtoonItem)
        }
    }
    
}

// MARK: - Activity

extension HomePopularViewController {
    
    func startActivity() {
        if self.activity.isAnimating() { return }
        self.activity.start()
    }
    
    func stopActivity() {
        if !self.activity.isAnimating() { return }
        self.activity.stop()
    }
    
}

