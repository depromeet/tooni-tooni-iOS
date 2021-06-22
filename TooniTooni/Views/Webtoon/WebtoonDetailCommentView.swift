//
//  WebtoonDetailCommentView.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/06/05.
//

import UIKit

protocol WebtoonDetailCommentViewDelegate: AnyObject {
    func didSendWebtoonDetailCommentView(view: WebtoonDetailCommentView, text: String?)
    func didMenuWebtoonDetailCommentView(view: WebtoonDetailCommentView, commentItem: Comment?, type: WebtoonDetailCommentMenuType)
}

class WebtoonDetailCommentView: BaseCustomView {
    
    // MARK: - Vars
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var commentInputView: WebtoonDetailCommentInputView!
    @IBOutlet weak var commentInputViewHeightConstraint: NSLayoutConstraint!

    var commentList: [Comment]?
    
    weak var delegate: WebtoonDetailCommentViewDelegate?
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.clipsToBounds = true
    }
    
    func initBackgroundView() {
        self.baseView.backgroundColor = kWHITE
    }
    
    func initInputView() {
        self.commentInputView.delegate = self
    }
    
    func initTableView() {
        let commentCell = UINib.init(nibName: kWebtoonDetailCommentCellID, bundle: nil)
        self.mainTableView.register(commentCell, forCellReuseIdentifier: kWebtoonDetailCommentCellID)

        let nodataCell = UINib.init(nibName: kGeneralNodataCellID, bundle: nil)
        self.mainTableView.register(nodataCell, forCellReuseIdentifier: kGeneralNodataCellID)

        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.separatorStyle = .none
        self.mainTableView.backgroundColor = kWHITE
        self.mainTableView.rowHeight = UITableView.automaticDimension
        self.mainTableView.estimatedRowHeight = 200.0
        self.mainTableView.sectionHeaderHeight = UITableView.automaticDimension
        self.mainTableView.estimatedSectionHeaderHeight = 40.0
        self.mainTableView.sectionFooterHeight = UITableView.automaticDimension
        self.mainTableView.estimatedSectionFooterHeight = 16.0
        self.mainTableView.showsVerticalScrollIndicator = false
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initVars()
        self.initBackgroundView()
        self.initInputView()
        self.initTableView()
    }
    
}

// MARK: - Event

extension WebtoonDetailCommentView {
    
    func reset() {
        self.commentInputView.contentTextView.text = nil
        self.commentInputView.contentTextView.resignFirstResponder()
        self.commentInputViewHeightConstraint.constant = 50.0
    }
    
}

// MARK: - Bind

extension WebtoonDetailCommentView {
    
    func bind(_ commentList: [Comment]?) {
        self.commentList = commentList
        
        self.commentInputView.contentTextView.textColor = kGRAY_50
        self.commentInputView.contentTextView.text = "투니의 의견을 작성해주세요 🤩"
        self.commentInputView.contentTextView.delegate = self
        self.commentInputView.contentTextView.keyboardDismissMode = .interactive

        self.mainTableView.reloadData()
    }
    
}

// MARK: - UITableView

extension WebtoonDetailCommentView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let commentList = self.commentList, commentList.count > 0 {
            return commentList.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let commentList = self.commentList, commentList.count > 0,
           let cell = tableView.dequeueReusableCell(withIdentifier: kWebtoonDetailCommentCellID, for: indexPath) as? WebtoonDetailCommentCell {
            let commentItem = commentList[indexPath.row]
            cell.bind(commentItem)
            cell.divider(indexPath.row == commentList.count - 1 ? false : true)
            cell.delegate = self
            
            return cell
        }
        else if let cell = tableView.dequeueReusableCell(withIdentifier: kGeneralNodataCellID, for: indexPath) as? GeneralNodataCell {
            cell.bind("empty_comment", "아직 댓글이 없어요 😭")

            return cell
        }
        
        return .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}

// MARK: - WebtoonDetailCommentCell

extension WebtoonDetailCommentView: WebtoonDetailCommentCellDelegate {
    
    func didMenuWebtoonDetailCommentCell(cell: WebtoonDetailCommentCell, commentItem: Comment?, type: WebtoonDetailCommentMenuType) {
        if let indexPath = self.mainTableView.indexPath(for: cell),
           let commentList = self.commentList, commentList.count > 0 {
            let commentItem = commentList[indexPath.row]

            self.delegate?.didMenuWebtoonDetailCommentView(view: self, commentItem: commentItem, type: type)
        }
    }
    
}

// MARK: - WebtoonDetailCommentInputView

extension WebtoonDetailCommentView: WebtoonDetailCommentInputViewDelegate {
    
    func didCommentWebtoonDetailCommentInputView(view: WebtoonDetailCommentInputView, text: String?) {
        self.delegate?.didSendWebtoonDetailCommentView(view: self, text: text)
    }
    
}

// MARK: - UIScrollView

extension WebtoonDetailCommentView: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.endEditing(true)
    }
    
}

// MARK: - UITextView

extension WebtoonDetailCommentView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: self.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        
        if estimatedSize.height < 50.0 {
            self.commentInputViewHeightConstraint.constant = 50.0
        }
        else if estimatedSize.height > 140.0 {
            self.commentInputViewHeightConstraint.constant = 140.0
        }
        else {
            self.commentInputViewHeightConstraint.constant = estimatedSize.height
        }
        
        if let text = textView.text, text.count > 0 {
            self.commentInputView.typing(true)
        }
        else {
            self.commentInputView.typing(false)
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == kGRAY_50 {
            textView.text = nil
            textView.textColor = kGRAY_90
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "투니의 의견을 작성해주세요 🤩"
            textView.textColor = kGRAY_50
        }
    }
    

}
