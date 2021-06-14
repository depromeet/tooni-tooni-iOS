//
//  WebtoonDetailCommentInputView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/07.
//

import UIKit

protocol WebtoonDetailCommentInputViewDelegate: AnyObject {
    func didCommentWebtoonDetailCommentInputView(view: WebtoonDetailCommentInputView, text: String?)
}

class WebtoonDetailCommentInputView: BaseCustomView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var dividerView: UIImageView!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    weak var delegate: WebtoonDetailCommentInputViewDelegate?
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
        
        self.dividerView.image = UIImage.imageFromColor(kGRAY_90)
    }
    
    func initTextView() {
        self.contentTextView.textContainerInset = UIEdgeInsets.init(top: 12.0, left: 0.0, bottom: 12.0, right: 0.0)
        self.contentTextView.font = kBODY1_REGULAR
        self.contentTextView.textColor = kGRAY_50
        self.contentTextView.text = "투니의 의견을 작성해주세요 🤩"
        self.contentTextView.spellCheckingType = .no
        self.contentTextView.autocapitalizationType = .none
        self.contentTextView.autocorrectionType = .no
    }
    
    func initButton() {
        self.sendButton.setImage(UIImage.init(named: "icon_comment")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.sendButton.tintColor = kGRAY_80
        self.sendButton.setBackgroundImage(UIImage.imageFromColor(kGRAY_10), for: .normal)
        self.sendButton.setBackgroundImage(UIImage.imageFromColor(kGRAY_10_HIGHLIGHT), for: .highlighted)
        self.sendButton.addTarget(self, action: #selector(doComment), for: .touchUpInside)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initTextView()
        self.initButton()
    }
    
}

// MARK: -

extension WebtoonDetailCommentInputView {
    
    @objc
    func doComment() {
        self.delegate?.didCommentWebtoonDetailCommentInputView(view: self, text: self.contentTextView.text)
    }
    
}

// MARK: -

extension WebtoonDetailCommentInputView {
    
    func typing(_ typing: Bool) {
        if typing {
            self.sendButton.tintColor = kWHITE
            self.sendButton.setBackgroundImage(UIImage.imageFromColor(kGRAY_90), for: .normal)
            self.sendButton.setBackgroundImage(UIImage.imageFromColor(kGRAY_90_HIGHLIGHT), for: .highlighted)
        }
        else {
            self.sendButton.tintColor = kGRAY_80
            self.sendButton.setBackgroundImage(UIImage.imageFromColor(kGRAY_10), for: .normal)
            self.sendButton.setBackgroundImage(UIImage.imageFromColor(kGRAY_10_HIGHLIGHT), for: .highlighted)
        }
    }
    
}
