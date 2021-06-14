//
//  WeekMenuView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/27.
//

import UIKit

enum WeekMenuType: Int, CaseIterable {
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    case sun
    case completed
    
    var title: String {
        switch self {
        case .mon: return "월"
        case .tue: return "화"
        case .wed: return "수"
        case .thu: return "목"
        case .fri: return "금"
        case .sat: return "토"
        case .sun: return "일"
        case .completed: return "완결"
        }
    }
    
    var short: String {
        switch self {
        case .mon: return "mon"
        case .tue: return "tue"
        case .wed: return "wed"
        case .thu: return "thu"
        case .fri: return "fri"
        case .sat: return "sat"
        case .sun: return "sun"
        case .completed: return ""
        }
    }
    
    static var currentWeekday: Int {
        let day = Calendar.current.component(.weekday, from: Date())
        switch day {
        case 1: return WeekMenuType(rawValue: 6)?.rawValue ?? 0
        case 2: return WeekMenuType(rawValue: 0)?.rawValue ?? 0
        case 3: return WeekMenuType(rawValue: 1)?.rawValue ?? 0
        case 4: return WeekMenuType(rawValue: 2)?.rawValue ?? 0
        case 5: return WeekMenuType(rawValue: 3)?.rawValue ?? 0
        case 6: return WeekMenuType(rawValue: 4)?.rawValue ?? 0
        case 7: return WeekMenuType(rawValue: 5)?.rawValue ?? 0
        default: return 0
        }
    }

    static let count = 8
}

protocol WeekMenuViewDelegate: AnyObject {
    func didMenuWeekMenuView(view: WeekMenuView, idx: Int)
}

class WeekMenuView: BaseCustomView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var selectedViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectedViewLeftConstraint: NSLayoutConstraint!

    var selectedIdx = 0
    let cellWidth = (kDEVICE_WIDTH - 32.0) / CGFloat(WeekMenuType.count)
    
    weak var delegate: WeekMenuViewDelegate?
    
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

extension WeekMenuView {
    
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
        if let title = WeekMenuType.init(rawValue: idx)?.title {
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

extension WeekMenuView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WeekMenuType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWeekMenuCellID, for: indexPath) as? WeekMenuCell {
            let title = WeekMenuType.init(rawValue: indexPath.row)?.title
            cell.bind(title)
            cell.selected(indexPath.row == self.selectedIdx ? true : false)
            
            return cell
        }
        
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        self.move(indexPath.row)
        self.delegate?.didMenuWeekMenuView(view: self, idx: indexPath.row)
    }
    
}
