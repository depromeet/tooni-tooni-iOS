//
//  FavoriteNodataCell.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/29.
//

import UIKit

let kFavoriteNodataCellID =                                 "FavoriteNodataCell"

class FavoriteNodataCell: UITableViewCell {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
    }
    
}
