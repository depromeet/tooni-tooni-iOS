//
//  SearchRecentCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/05.
//

import UIKit

let kSearchRecentCellID =                                       "SearchRecentCell"

protocol SearchRecentCellDelegate: AnyObject {
    func didDeleteSearchRecentCell(cell: SearchRecentCell)
}

class SearchRecentCell: UICollectionViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: SearchRecentCellDelegate?
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
    }
    
    func initButton() {
        self.deleteButton.setImage(UIImage.init(named: "icon_delete"), for: .normal)
        self.deleteButton.addTarget(self, action: #selector(doDelete), for: .touchUpInside)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initButton()
    }
    
}

// MARK: - Event

extension SearchRecentCell {
    
    @objc
    func doDelete() {
        self.delegate?.didDeleteSearchRecentCell(cell: self)
    }
    
}

// MARK: - Bind

extension SearchRecentCell {
    
    func bind(_ title: String) {
        self.titleLabel.text = title
    }
    
}
