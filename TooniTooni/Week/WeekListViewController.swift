//
//  WeekListViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/27.
//

import UIKit

class WeekListViewController: BaseViewController {
    
    // MARK: - Vars
    
    @IBOutlet weak var mainCollectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var activity: CustomActivity!
    
    var webtoonList: [Webtoon]? {
        didSet {
            DispatchQueue.main.async {
                self.stopActivity()
                self.mainCollectionView.reloadData()
                
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.25) {
                    self.mainCollectionView.alpha = 1.0
                } completion: { _ in

                }
            }
        }
    }

    // MARK: - Life Cycle
        
    func initBackgroundView() {
        self.view.backgroundColor = kWHITE
    }
    
    func initCollectionView() {
        let menuCell = UINib.init(nibName: kWeekWebtoonCellID, bundle: nil)
        self.mainCollectionView.register(menuCell, forCellWithReuseIdentifier: kWeekWebtoonCellID)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: (kDEVICE_WIDTH - 64.0) / 3.0, height: (kDEVICE_WIDTH - 64.0) / 3.0 + 64.0)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 12.0
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        layout.sectionInset = UIEdgeInsets.init(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
        
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.backgroundColor = kWHITE
        self.mainCollectionView.showsVerticalScrollIndicator = false
        self.mainCollectionView.showsHorizontalScrollIndicator = false
        self.mainCollectionView.alwaysBounceHorizontal = false
        self.mainCollectionView.alwaysBounceVertical = true
        self.mainCollectionView.collectionViewLayout = layout
        self.mainCollectionView.alpha = 0.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initBackgroundView()
        self.initCollectionView()
        
        if self.webtoonList == nil {
            self.startActivity()
            self.fetchWeekWebtoons()
        }
    }
    
}

// MARK: - Week Webtoon

extension WeekListViewController {
    
    func fetchWeekWebtoons() {
        guard let short = WeekMenuType.init(rawValue: self.pageIdx)?.short else { return }

        TooniNetworkService.shared.request(to: .weekWebtoon(short), decoder: WeekWebtoon.self) { [weak self] response in
            switch response.result {
            case .success:
                guard let webtoons = (response.json as? WeekWebtoon)?.webtoons else { return }
                
                self?.webtoonList = webtoons
            case .failure:
                print(response)
            }
        }
    }
    
}

// MARK: - UICollectionView

extension WeekListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let webtoonList = self.webtoonList else { return 0 }
        
        return webtoonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let webtoonList = self.webtoonList else { return .init() }

        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWeekWebtoonCellID, for: indexPath) as? WeekWebtoonCell {
            let webtoonItem = webtoonList[indexPath.row]
            cell.bind(webtoonItem)
            
            return cell
        }
        
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let webtoonList = self.webtoonList else { return }

        let webtoonItem = webtoonList[indexPath.row]
        self.openDetailVC(webtoonItem)
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

// MARK: - Activity

extension WeekListViewController {
    
    func startActivity() {
        if self.activity.isAnimating() { return }
        self.activity.start()
    }
    
    func stopActivity() {
        if !self.activity.isAnimating() { return }
        self.activity.stop()
    }
    
}

