//
//  SearchHeaderView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/06.
//

import UIKit

class SearchHeaderView: BaseCustomView {
    
    // MARK: - VArs
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var textView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var dividerImageView: UIImageView!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
        
        self.dividerImageView.image = UIImage.imageFromColor(kGRAY_90)
    }
    
    func initTextField() {
        self.textField.font = kBODY1_REGULAR
        self.textField.textColor = kGRAY_90
        self.textField.autocorrectionType = .no
        self.textField.autocapitalizationType = .none
        self.textField.clearButtonMode = .whileEditing
        self.textField.returnKeyType = .search
        self.textField.placeholder = "작가, 작품을 검색해 보세요 🧐"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initTextField()
    }
    
}

// MARK: -
