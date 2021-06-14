//
//  GeneralGenreListView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/29.
//

import UIKit

class GeneralGenreListView: BaseCustomView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    
    var genreList: [String]?
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
    }
    
    func initCollectionView() {
        let genreCell = UINib.init(nibName: kGeneralGenreCellID, bundle: nil)
        self.mainCollectionView.register(genreCell, forCellWithReuseIdentifier: kGeneralGenreCellID)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: kDEVICE_WIDTH, height: 60.0)
        layout.minimumLineSpacing = 8.0
        layout.minimumInteritemSpacing = 8.0
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
        self.mainCollectionView.isPagingEnabled = true
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

extension GeneralGenreListView {
    
    func bind(_ webtoonItem: Webtoon) {
        self.genreList = webtoonItem.genres
        self.mainCollectionView.reloadData()
    }
    
}

// MARK: - UICollectionView

extension GeneralGenreListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let genreList = self.genreList, genreList.count > 0 {
            return genreList.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let genreList = self.genreList, genreList.count > 0,
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kGeneralGenreCellID, for: indexPath) as? GeneralGenreCell {
            let genre = genreList[indexPath.row]
            cell.bind(genre)
            
            return cell
        }
        
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let genreList = self.genreList, genreList.count > 0 {
            let genre = "#" + genreList[indexPath.row]
            let size = genre.size(withAttributes: [NSAttributedString.Key.font: kCAPTION2_REGULAR!])
            
            return  CGSize.init(width: size.width + 22.0, height: 60.0)
        }

        return .zero
    }
    

}
