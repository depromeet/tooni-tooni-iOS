//
//  GeneralConeView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/30.
//

import UIKit

class GeneralConeView: BaseCustomView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kCLEAR
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.frame.size.width * 2.0
        let height = self.frame.size.height * 2.0

        let over = UIBezierPath.init(ovalIn: CGRect.init(origin: CGPoint.zero,
                                                         size: CGSize.init(width: width, height: height)))
        let cloverPath = UIBezierPath()
        cloverPath.append(over)
        
        let circleShape = CAShapeLayer()
        circleShape.path = cloverPath.cgPath
        self.baseView.layer.mask = circleShape
    }
    
}

// MARK: - Bind

extension GeneralConeView {
    
    func bind(_ webtoon: Webtoon?) {
        if let image = webtoon?.thumbnail { //}?.replacingOccurrences(of: "http://", with: "https://") {
            self.thumbImageView.kf.setImage(with: URL.init(string: image),
                                           placeholder: nil,
                                           options: [.transition(.fade(0.25))], completionHandler: nil)
        }
    }
    
}
