//
//  SearchViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/05.
//

import UIKit

enum SearchType: Int {
    case none
    case typing
    case result
}

class SearchViewController: BaseViewController {

    // MARK: - Vars
    
    @IBOutlet weak var navigationView: GeneralNavigationView!
    @IBOutlet weak var headerView: SearchHeaderView!
    @IBOutlet weak var mainCollectionView: UICollectionView!
    @IBOutlet weak var mainCollectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var activity: CustomActivity!

    var type: SearchType = .none {
        didSet {
//            DispatchQueue.main.async {
                self.mainCollectionView.reloadData()
//            }
        }
    }
    
    var randomList: [Webtoon]? {
        didSet {
            DispatchQueue.main.async {
                self.stopActivity()
                self.mainCollectionView.reloadData()
                
                UIView.animate(withDuration: 0.25) {
                    self.mainCollectionView.alpha = 1.0
                }
            }
        }
    }
    
    var searchList: [Webtoon]? {
        didSet {
            DispatchQueue.main.async {
                self.stopActivity()
                self.mainCollectionView.reloadData()
                
                UIView.animate(withDuration: 0.25) {
                    self.mainCollectionView.alpha = 1.0
                }
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
        self.navigationView.title(nil)
        self.navigationView.bigTitle(self.showBigTitle)
        
        self.navigationView.leftButton.isHidden = false
        self.navigationView.leftButton.setImage(UIImage.init(named: "icon_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.navigationView.leftButton.tintColor = kGRAY_90
        self.navigationView.leftButton.addTarget(self, action: #selector(doBack), for: .touchUpInside)
    }
    
    func initHeaderView() {
        self.headerView.textField.delegate = self
        self.headerView.textField.addTarget(self, action: #selector(textFieldDidChanged(textField:)), for: .editingChanged)
    }
    
    func initCollectionView() {
        let randomCell = UINib.init(nibName: kHomeWebtoonCellID, bundle: nil)
        self.mainCollectionView.register(randomCell, forCellWithReuseIdentifier: kHomeWebtoonCellID)
        
        let recentCell = UINib.init(nibName: kSearchRecentCellID, bundle: nil)
        self.mainCollectionView.register(recentCell, forCellWithReuseIdentifier: kSearchRecentCellID)
        
        let resultCell = UINib.init(nibName: kSearchResultCellID, bundle: nil)
        self.mainCollectionView.register(resultCell, forCellWithReuseIdentifier: kSearchResultCellID)
        
        let footerView = UINib.init(nibName: kSearchNoneFooterViewID, bundle: nil)
        self.mainCollectionView.register(footerView, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: kSearchNoneFooterViewID)
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: (kDEVICE_WIDTH - 64.0) / 3.0, height: (kDEVICE_WIDTH - 64.0) / 3.0 * 140.0 / 104.0)
        layout.minimumLineSpacing = 12.0
        layout.minimumInteritemSpacing = 12.0
        layout.headerReferenceSize = .zero
        layout.footerReferenceSize = .zero
        layout.sectionInset = UIEdgeInsets.init(top: 24.0, left: 20.0, bottom: 0.0, right: 20.0)
        
        self.mainCollectionView.delegate = self
        self.mainCollectionView.dataSource = self
        self.mainCollectionView.backgroundColor = kWHITE
        self.mainCollectionView.showsVerticalScrollIndicator = false
        self.mainCollectionView.showsHorizontalScrollIndicator = false
        self.mainCollectionView.alwaysBounceHorizontal = false
        self.mainCollectionView.alwaysBounceVertical = true
        self.mainCollectionView.isPagingEnabled = false
        self.mainCollectionView.collectionViewLayout = layout
        self.mainCollectionView.alpha = 0.0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initVars()
        self.initBackgroundView()
        self.initNavigationView()
        self.initHeaderView()
        self.initCollectionView()
        
        self.startActivity()
        self.fetchRandom()
        
        self.initObservers()
    }
    
    deinit {
        self.deInitObservers()
    }
    
}

// MARK: - Random

extension SearchViewController {
    
    func fetchRandom() {
        TooniNetworkService.shared.request(to: .random, decoder: RandomItem.self) { [weak self] response in
            switch response.result {
            case .success:
                guard let randomList = response.json as? RandomItem else { return }
                
                self?.randomList = randomList.webtoons
            case .failure:
                print(response)
            }
        }
    }
    
}

// MARK: - Search

extension SearchViewController {
    
    func fetchSearch(_ text: String) {
        GeneralHelper.sharedInstance.addSearches(text)
        
        TooniNetworkService.shared.request(to: .search(text), decoder: SearchItem.self) { [weak self] response in
            switch response.result {
            case .success:
                guard let search = response.json as? SearchItem else { return }

                self?.searchList = search.webtoons
            case .failure:
                print(response)
            }
        }
    }
    
}

// MARK: - Event

extension SearchViewController {
    
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

// MARK: - UICollectionView

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.type {
        case .none:
            if let list = self.randomList {
                if list.count > 0 && list.count < 9 {
                    return list.count
                }
                else {
                    return 9
                }
            }
        case .typing:
            if GeneralHelper.sharedInstance.searchList.count > 0 { return GeneralHelper.sharedInstance.searchList.count }
        case .result:
            if let list = self.searchList, list.count > 0 { return list.count }
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch self.type {
        case .none:
            if let list = self.randomList, list.count > 0,
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kHomeWebtoonCellID, for: indexPath) as? HomeWebtoonCell {
                let webtoonItem = list[indexPath.row]
                cell.bind(webtoonItem)
                cell.clover(true)
                
             return cell
            }
        case .typing:
            if GeneralHelper.sharedInstance.searchList.count > 0,
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kSearchRecentCellID, for: indexPath) as? SearchRecentCell {
                let title = GeneralHelper.sharedInstance.searchList[indexPath.row]
                cell.bind(title)
                cell.delegate = self
                
                return cell
            }
        case .result:
            if let list = self.searchList, list.count > 0,
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kSearchResultCellID, for: indexPath) as? SearchResultCell {
                let webtoonItem = list[indexPath.row]
                cell.bind(webtoonItem)
                
                return cell
            }
        }
        
        return .init()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        switch self.type {
        case .none:
            if let list = self.randomList, list.count > 0 {
                let webtoonItem = list[indexPath.row]
                self.openDetailVC(webtoonItem)
            }
        case .typing:
            let title = GeneralHelper.sharedInstance.searchList[indexPath.row]
            self.fetchSearch(title)
        case .result:
            if let list = self.searchList, list.count > 0 {
                let webtoonItem = list[indexPath.row]
                self.openDetailVC(webtoonItem)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableView: UICollectionReusableView? = nil
        
        if kind == UICollectionView.elementKindSectionFooter,
           let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: kSearchNoneFooterViewID, for: indexPath) as? SearchNoneFooterView {
            footerView.delegate = self
            
            return footerView
        }
        
        return reusableView!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch self.type {
        case .none:
            return CGSize.init(width: kDEVICE_WIDTH, height: 120.0)
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if self.type == .none {
            return 12.0
        }
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if self.type == .none {
            return 12.0
        }
        
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch self.type {
        case .none:
            return CGSize.init(width: (kDEVICE_WIDTH - 64.0) / 3.0, height: (kDEVICE_WIDTH - 64.0) / 3.0 + 56.0)
        case .typing:
            return CGSize.init(width: kDEVICE_WIDTH, height: 40.0)
        case .result:
            return CGSize.init(width: kDEVICE_WIDTH, height: 72.0)
        }
    }
    
}

// MARK: - SearchRecentCell

extension SearchViewController: SearchRecentCellDelegate {
    
    func didDeleteSearchRecentCell(cell: SearchRecentCell) {
        if let indexPath = self.mainCollectionView.indexPath(for: cell) {
           let title = GeneralHelper.sharedInstance.searchList[indexPath.row]
            GeneralHelper.sharedInstance.removeSearches(title)
            self.mainCollectionView.reloadData()
        }
    }
    
}

// MARK: - SearchNoneFooterView

extension SearchViewController: SearchNoneFooterViewDelegate {
    
    func didRefreshSearchNoneFooterView(view: SearchNoneFooterView) {
        self.startActivity()
        self.fetchRandom()
    }
    
}

// MARK: - UITextField

extension SearchViewController: UITextFieldDelegate {
    
    @objc
    func textFieldDidChanged(textField: UITextField) {
        self.type = .typing
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchList = nil

        self.type = .typing
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), text.count > 0 {
            self.type = .result
            
            self.startActivity()
            self.fetchSearch(text)
        }
        else {
            self.type = .none
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
                
        return true
    }
    
}

// MARK: - Activity

extension SearchViewController {
    
    func startActivity() {
        if self.activity.isAnimating() { return }
        self.activity.start()
    }
    
    func stopActivity() {
        if !self.activity.isAnimating() { return }
        self.activity.stop()
    }
    
}

// MARK: -

extension SearchViewController {
    
    func initObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(sender:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(sender:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    func deInitObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    @objc
    func keyboardWillShow(sender: NSNotification) {
        let userInfo = sender.userInfo
        let value = userInfo?[UIResponder.keyboardFrameEndUserInfoKey]
        let keyboardRect = (value as! NSValue).cgRectValue
        
        self.mainCollectionViewBottomConstraint.constant = keyboardRect.size.height - kDEVICE_BOTTOM_AREA
        self.view.layoutIfNeeded()
    }
    
    @objc
    func keyboardWillHide(sender: NSNotification) {
        self.mainCollectionViewBottomConstraint.constant = 0.0
        self.view.layoutIfNeeded()
    }
    
}
