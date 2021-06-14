//
//  HomeGenreListCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/15.
//

import UIKit

let kHomeGenreListCellID =                                                  "HomeGenreListCell"

protocol HomeGenreListCellDelegate: AnyObject {
    func didWebtoonHomeGenreListCell(cell: HomeGenreListCell, webtoon: Webtoon)
}

class HomeGenreListCell: UITableViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mainCollectionView: UICollectionView!

    var webtoonList: [Webtoon] = []

    weak var delegate: HomeGenreListCellDelegate?
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
    }
    
    func initCollectionView() {
        let webtoonCell = UINib.init(nibName: kHomeGenreCellID, bundle: nil)
        self.mainCollectionView.register(webtoonCell, forCellWithReuseIdentifier: kHomeGenreCellID)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: 108.0, height: 156.0)
        layout.minimumLineSpacing = 16.0
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

extension HomeGenreListCell {
    
    func bind(_ webtoonList: [Webtoon]) {
        self.webtoonList = webtoonList
        self.mainCollectionView.reloadData()
    }
    
}

// MARK: - UICollectionView

extension HomeGenreListCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.webtoonList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kHomeGenreCellID, for: indexPath) as? HomeGenreCell {
            let webtoonItem = self.webtoonList[indexPath.row]
            cell.bind(webtoonItem)
            
            return cell
        }
        
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        let webtoonItem = self.webtoonList[indexPath.row]
        self.delegate?.didWebtoonHomeGenreListCell(cell: self, webtoon: webtoonItem)
    }
    
}
