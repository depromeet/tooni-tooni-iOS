//
//  GeneralCloverView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/05/30.
//

import UIKit

class GeneralCloverView: BaseCustomView {
    
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
        
        let width = self.frame.size.width / 2.0
        let size = CGSize.init(width: width, height: width)
        let radius = self.frame.size.width / 4.0
                
        let circlePath1 = UIBezierPath.init(roundedRect: CGRect.init(origin: .zero, size: size), cornerRadius: radius)
        let circlePath2 = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.init(x: width, y: 0.0), size: size), cornerRadius: radius)
        let circlePath3 = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.init(x: 0.0, y: width), size: size), cornerRadius: radius)
        let circlePath4 = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.init(x: width, y: width), size: size), cornerRadius: radius)
        let centerPath = UIBezierPath.init(roundedRect: CGRect.init(origin: CGPoint.init(x: radius, y: radius), size: size), cornerRadius: radius)

        let cloverPath = UIBezierPath()
        cloverPath.append(circlePath1)
        cloverPath.append(circlePath2)
        cloverPath.append(circlePath3)
        cloverPath.append(circlePath4)
        cloverPath.append(centerPath)
        
        let circleShape = CAShapeLayer()
        circleShape.path = cloverPath.cgPath
        self.baseView.layer.mask = circleShape
    }
    
}

// MARK: - Bind

extension GeneralCloverView {
    
    func bind(_ webtoon: Webtoon?) {
        if let image = webtoon?.thumbnail { //}?.replacingOccurrences(of: "http://", with: "https://") {
            self.thumbImageView.kf.setImage(with: URL.init(string: image),
                                           placeholder: nil,
                                           options: [.transition(.fade(0.25))], completionHandler: nil)
        }
    }
    
}
