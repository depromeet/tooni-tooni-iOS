//
//  GeneralMenuView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/29.
//

import UIKit

protocol GeneralMenuViewDelegate: AnyObject {
    func didMenuGeneralMenuView(view: GeneralMenuView, idx: Int)
}

class GeneralMenuView: BaseCustomView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var selectedViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectedViewLeftConstraint: NSLayoutConstraint!

    var selectedIdx = 0
    var titleList: [String]!

    weak var delegate: GeneralMenuViewDelegate?
    
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
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 8.0
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
        self.selectedViewWidthConstraint.constant = 100.0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initCollectionView()
        self.initSelectedView()
    }
    
}

// MARK: - Bind

extension GeneralMenuView {
    
    func color(_ color: UIColor) {
        self.selectedView.backgroundColor = color
    }
    
    func bind(_ selectedIdx: Int, _ titleList: [String]) {
        self.selectedIdx = selectedIdx
        self.titleList = titleList
        
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
        let title = self.titleList[idx]
        let size = title.size(withAttributes: [NSAttributedString.Key.font: kBODY1_BOLD!])
        width = size.width + 8.0

        var leftPadding = 0.0
        for title in self.titleList[0..<idx] {
            leftPadding += Double(title.size(withAttributes: [NSAttributedString.Key.font: kBODY1_BOLD!]).width) + (Double(idx) * 16.0)
        }
        
        UIView.animate(withDuration: animation ? 0.25 : 0.0) {
            self.selectedViewWidthConstraint.constant = width
            self.selectedViewLeftConstraint.constant = CGFloat(leftPadding) + 16.0
            self.layoutIfNeeded()
        }
    }
    
}

// MARK: - UICollectionView

extension GeneralMenuView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWeekMenuCellID, for: indexPath) as? WeekMenuCell {
            let title = self.titleList[indexPath.row]
            cell.bind(title)
            cell.selected(indexPath.row == self.selectedIdx ? true : false)
            
            return cell
        }
        
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        self.move(indexPath.row)
        self.delegate?.didMenuGeneralMenuView(view: self, idx: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width: CGFloat = 24.0
        let title = self.titleList[indexPath.row]
        let size = title.size(withAttributes: [NSAttributedString.Key.font: kBODY1_BOLD!])
        width = size.width + 8.0

        return CGSize.init(width: width, height: 50.0)
    }
    
}
