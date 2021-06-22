//
//  HomeWebtoonListCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/27.
//

import UIKit

let kHomeWebtoonListCellID =                                        "HomeWebtoonListCell"

protocol HomeWebtoonListCellDelegate: AnyObject {
    func didWebtoonHomeWebtoonListCell(cell: HomeWebtoonListCell, webtoon: Webtoon)
}

class HomeWebtoonListCell: UITableViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var webtoonList: [Webtoon] = []
    
    weak var delegate: HomeWebtoonListCellDelegate?
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
    }
    
    func initCollectionView() {
        let webtoonCell = UINib.init(nibName: kHomeWebtoonCellID, bundle: nil)
        self.mainCollectionView.register(webtoonCell, forCellWithReuseIdentifier: kHomeWebtoonCellID)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: 116.0, height: 192.0)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 0.0
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        layout.sectionInset = UIEdgeInsets.init(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.backgroundColor = kWHITE
        self.mainCollectionView.showsVerticalScrollIndicator = false
        self.mainCollectionView.showsHorizontalScrollIndicator = false
        self.mainCollectionView.alwaysBounceHorizontal = true
        self.mainCollectionView.alwaysBounceVertical = false
        self.mainCollectionView.collectionViewLayout = layout
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initCollectionView()
    }
    
}

// MARK: - Bind

extension HomeWebtoonListCell {
    
    func bind(_ webtoonList: [Webtoon]) {
        self.webtoonList = webtoonList
        self.mainCollectionView.reloadData()
    }
    
}

// MARK: - UICollectionView

extension HomeWebtoonListCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.webtoonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kHomeWebtoonCellID, for: indexPath) as? HomeWebtoonCell {
            let webtoonItem = self.webtoonList[indexPath.row]
            cell.bind(webtoonItem)
            
            return cell
        }
        
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let webtoonItem = self.webtoonList[indexPath.row]
        self.delegate?.didWebtoonHomeWebtoonListCell(cell: self, webtoon: webtoonItem)
    }
    
}
