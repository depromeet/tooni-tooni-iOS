//
//  GenreHeaderView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/09.
//

import UIKit

protocol GenreHeaderViewDelegate: AnyObject {
    func didMenuGenreHeaderView(view: GenreHeaderView, idx: Int)
}

class GenreHeaderView: BaseCustomView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var selectedViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectedViewLeftConstraint: NSLayoutConstraint!

    var selectedIdx = 0
    let cellWidth = (kDEVICE_WIDTH - 32.0) / CGFloat(HomeGenreType.count)
    
    weak var delegate: GenreHeaderViewDelegate?
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
    }
    
    func initCollectionView() {
        let menuCell = UINib.init(nibName: kWeekMenuCellID, bundle: nil)
        self.mainCollectionView.register(menuCell, forCellWithReuseIdentifier: kWeekMenuCellID)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: self.cellWidth, height: 50.0)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0.0
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        layout.sectionInset = UIEdgeInsets.init(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.backgroundColor = kCLEAR
        self.mainCollectionView.showsVerticalScrollIndicator = false
        self.mainCollectionView.showsHorizontalScrollIndicator = false
        self.mainCollectionView.alwaysBounceHorizontal = true
        self.mainCollectionView.alwaysBounceVertical = false
        self.mainCollectionView.isScrollEnabled = false
        self.mainCollectionView.collectionViewLayout = layout
    }
    
    func initSelectedView() {
        self.selectedView.backgroundColor = kBLUE_100
        
        self.selectedViewLeftConstraint.constant = 16.0
        self.selectedViewWidthConstraint.constant = self.cellWidth
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initCollectionView()
        self.initSelectedView()
        
        self.refreshSelectedView(0, false)
    }
    
}

// MARK: - Bind

extension GenreHeaderView {
    
    func bind(_ selectedIdx: Int) {
        self.selectedIdx = selectedIdx
        self.refreshSelectedView(selectedIdx, false)
        self.mainCollectionView.reloadData()
    }
    
    func move(_ idx: Int) {
        self.selectedIdx = idx

        self.refreshSelectedView(idx)
        self.mainCollectionView.reloadData()
    }
    
    func refreshSelectedView(_ idx: Int, _ animation: Bool = true) {
        var width: CGFloat = 24.0
        if let title = HomeGenreType.init(rawValue: idx)?.title {
        let size = title.size(withAttributes: [NSAttributedString.Key.font: kBODY1_BOLD!])
            width = size.width + 12.0
        }

        UIView.animate(withDuration: animation ? 0.25 : 0.0) {
            self.selectedViewWidthConstraint.constant = width
            self.selectedViewLeftConstraint.constant = self.cellWidth * CGFloat(idx) + 16.0 + (self.cellWidth - width) / 2.0
            self.layoutIfNeeded()
        }
    }
    
}

// MARK: - UICollectionView

extension GenreHeaderView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HomeGenreType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWeekMenuCellID, for: indexPath) as? WeekMenuCell {
            let title = HomeGenreType.init(rawValue: indexPath.row)?.title
            cell.bind(title)
            cell.selected(indexPath.row == self.selectedIdx ? true : false)
            
            return cell
        }
        
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        self.move(indexPath.row)
        self.delegate?.didMenuGenreHeaderView(view: self, idx: indexPath.row)
    }
    
}

