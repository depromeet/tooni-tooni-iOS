//
//  WebtoonMenuView.swift
//  TooniTooni
//
//  Created by buzz on 2021/05/28.
//

import UIKit

protocol WebtoonMenuTitle {
  var title: String { get }
}

enum WebtoonMenuType: Int, WebtoonMenuTitle {
  case home
  case comment

  var title: String {
    switch self {
    case .home: return "투니 홈"
    case .comment: return "투니댓글"
    }
  }

  static let count = 2
}

class WebtoonMenuView: BaseCustomView {

  // MARK: - Vars

  @IBOutlet var baseView: UIView!
  @IBOutlet var mainCollectionView: UICollectionView!
  @IBOutlet var selectedView: UIView!
  @IBOutlet var selectedViewWidthConstraint: NSLayoutConstraint!
  @IBOutlet var selectedViewLeftConstraint: NSLayoutConstraint!

  var selectedIdx = 0
  var cellWidth: CGFloat = 60
  var didMenuWeekMenuView: ((WebtoonMenuView, Int) -> Void)?

  // MARK: - Life Cycle

  func initVars() {
    clipsToBounds = true
  }

  func initBackgroundView() {
    baseView.backgroundColor = kWHITE
  }

  func initCollectionView() {
    let menuCell = UINib(nibName: kWeekMenuCellID, bundle: nil)
    mainCollectionView.register(menuCell, forCellWithReuseIdentifier: kWeekMenuCellID)

    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: cellWidth, height: 50.0)
    layout.minimumLineSpacing = 16.0
    layout.minimumInteritemSpacing = 0.0
    layout.headerReferenceSize = .zero
    layout.footerReferenceSize = .zero
    layout.sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)

    mainCollectionView.delegate = self
    mainCollectionView.dataSource = self
    mainCollectionView.backgroundColor = kCLEAR
    mainCollectionView.showsVerticalScrollIndicator = false
    mainCollectionView.showsHorizontalScrollIndicator = false
    mainCollectionView.alwaysBounceHorizontal = true
    mainCollectionView.alwaysBounceVertical = false
    mainCollectionView.isScrollEnabled = false
    mainCollectionView.collectionViewLayout = layout
  }

  func initSelectedView() {
    selectedView.backgroundColor = kBLUE_100

    selectedViewLeftConstraint.constant = 16.0
    selectedViewWidthConstraint.constant = cellWidth
  }

  override func awakeFromNib() {
    super.awakeFromNib()

    initVars()
    initBackgroundView()
    initCollectionView()
    initSelectedView()

    refreshSelectedView(0, false)
  }
}

// MARK: - Bind

extension WebtoonMenuView {

  func bind(_ selectedIdx: Int, site: String? = nil) {
    self.selectedIdx = selectedIdx
    refreshSelectedView(selectedIdx, false)

    if site?.lowercased() == "naver" {
      selectedView.backgroundColor = kNAVER_100
    } else if site?.lowercased() == "daum" {
      selectedView.backgroundColor = kDAUM_100
    } else if site?.lowercased() == "kakao" {
      selectedView.backgroundColor = kKAKAO_100
    }

    mainCollectionView.reloadData()
  }

  func move(_ idx: Int) {
    selectedIdx = idx

    refreshSelectedView(idx)
    mainCollectionView.reloadData()
  }

  func refreshSelectedView(_ idx: Int, _ animation: Bool = true) {
    UIView.animate(withDuration: animation ? 0.25 : 0.0) {
      self.selectedViewWidthConstraint.constant = self.cellWidth
      self.selectedViewLeftConstraint.constant = self.cellWidth * CGFloat(idx) + 16.0 + (CGFloat(idx) * 16.0)
      self.layoutIfNeeded()
    }
  }
}

// MARK: - UICollectionView

extension WebtoonMenuView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return WebtoonMenuType.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kWeekMenuCellID, for: indexPath) as? WeekMenuCell {
      let title = WebtoonMenuType(rawValue: indexPath.row)?.title
      cell.bind(title)
      cell.selected(indexPath.row == selectedIdx ? true : false)

      return cell
    }

    return .init()
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)

    move(indexPath.row)
    didMenuWeekMenuView?(self, indexPath.row)
  }
}
