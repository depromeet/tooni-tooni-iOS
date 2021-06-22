//
//  HomeAuthorListCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/27.
//

import UIKit

let kHomeAuthorListCellID =                                        "HomeAuthorListCell"

protocol HomeAuthorListCellDelegate: AnyObject {
    func didAuthorHomeAuthorListCell(cell: HomeAuthorListCell, author: Author)
}

class HomeAuthorListCell: UITableViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var authorList: [Author] = []
    
    weak var delegate: HomeAuthorListCellDelegate?
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
    }
    
    func initCollectionView() {
        let authorCell = UINib.init(nibName: kHomeAuthorCellID, bundle: nil)
        self.mainCollectionView.register(authorCell, forCellWithReuseIdentifier: kHomeAuthorCellID)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: 80.0, height: 124.0)
        layout.minimumLineSpacing = 12.0
        layout.minimumInteritemSpacing = 0.0
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        layout.sectionInset = UIEdgeInsets.init(top: 0.0, left: 24.0, bottom: 0.0, right: 24.0)
        
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

extension HomeAuthorListCell {
    
    func bind(_ authorList: [Author]) {
        self.authorList = Array(authorList[0...5])
        self.mainCollectionView.reloadData()
    }
    
}

// MARK: - UICollectionView

extension HomeAuthorListCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.authorList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kHomeAuthorCellID, for: indexPath) as? HomeAuthorCell {
            let authorItem = self.authorList[indexPath.row]
            cell.bind(authorItem)
            
            return cell
        }
        
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let authorItem = self.authorList[indexPath.row]
        self.delegate?.didAuthorHomeAuthorListCell(cell: self, author: authorItem)
    }
    
}
