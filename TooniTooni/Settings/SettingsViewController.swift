//
//  SettingsViewController.swift
//  TooniTooni
//
//  Created by GENETORY on 2021/04/12.
//

import UIKit
import SafariServices
import MobileCoreServices
import MessageUI

enum SettingsType: Int, CaseIterable {
    case feedback
    case made
    
    var title: String {
        switch self {
        case .feedback:
            return "피드백 보내기"
        case .made:
            return "만든 사람들"
        }
    }
    
    var image: String {
        switch self {
        case .feedback:
            return "icon_feedback"
        case .made:
            return "icon_made"
        }
    }
    
    static let count = 2
}

class SettingsViewController: BaseViewController {

    // MARK: - Vars
    
    @IBOutlet weak var navigationView: GeneralNavigationView!
    @IBOutlet weak var mainTableView: UITableView!
    
    // MARK: - Life Cycle
    
    func initVars() {
        self.showBigTitle = false
    }
    
    func initBackgroundView() {
        self.view.backgroundColor = kWHITE
    }
    
    func initNavigationView() {
        self.setInteractiveRecognizer()
        
        self.navigationView.title(self.tabItem?.title)
        self.navigationView.bigTitle(self.showBigTitle)
        self.navigationView.leftButton(false)
        
        self.navigationView.rightButton.isHidden = false
        self.navigationView.rightButton.setImage(UIImage.init(named: "icon_search")?.withRenderingMode(.alwaysTemplate), for: .normal)
        self.navigationView.rightButton.tintColor = kGRAY_90
        self.navigationView.rightButton.addTarget(self, action: #selector(doSearch), for: .touchUpInside)
    }
    
    func initTableView() {
        let headerView = UINib.init(nibName: kSettingsHeaderViewID, bundle: nil)
        self.mainTableView.register(headerView, forHeaderFooterViewReuseIdentifier: kSettingsHeaderViewID)
        
        let listCell = UINib.init(nibName: kSettingsListCellID, bundle: nil)
        self.mainTableView.register(listCell, forCellReuseIdentifier: kSettingsListCellID)
        
        self.mainTableView.delegate = self
        self.mainTableView.dataSource = self
        self.mainTableView.separatorStyle = .none
        self.mainTableView.backgroundColor = kWHITE
        self.mainTableView.rowHeight = UITableView.automaticDimension
        self.mainTableView.estimatedRowHeight = 200.0
        self.mainTableView.sectionHeaderHeight = UITableView.automaticDimension
        self.mainTableView.estimatedSectionHeaderHeight = 44.0
        self.mainTableView.showsVerticalScrollIndicator = false
        self.mainTableView.insetsContentViewsToSafeArea = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.initVars()
        self.initBackgroundView()
        self.initNavigationView()
        self.initTableView()
    }

}

// MARK: - Event

extension SettingsViewController {
    
    @objc
    func doSearch() {
        self.openSearchVC()
    }
    
    func openSearchVC() {
        if let vc = GeneralHelper.sharedInstance.makeVC("Search", "SearchViewController") as? SearchViewController {
            vc.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func openMade() {
        if let url = URL.init(string: "https://depromeet.com/project") {
            let safariVC = SFSafariViewController(url: url)
            
            self.present(safariVC, animated: true, completion: nil)
        }
    }

    func openMail() {
        if MFMailComposeViewController.canSendMail() {
            let device = UIDevice.current
            let bodyTemplete = String.init(format: "<br><br><br><br><br><br><br><hr/><small><br>%@<br><br>%@ Version: %@<br>%@ %@<br>%@<br></small>",
                                           "건의사항 제보하기",
                                           device.systemName,
                                           device.systemVersion,
                                           "투니투니",
                                           String().appLongVersion,
                                           device.model)
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject("투니투니 건의사항 제보하기")
            mail.setMessageBody(bodyTemplete, isHTML: true)
            mail.setToRecipients(["genetory@op.gg"])
            
            mail.modalPresentationStyle = .fullScreen
            self.present(mail, animated: true)
        }
        else {
            self.showAlertWithTitle(vc: self, title: "알림", message: "이메일 설정을 확인해주세요 🤩")
        }
    }
    
}

// MARK: - UITableView

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsType.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: kSettingsHeaderViewID) as? SettingsHeaderView {
            headerView.bind()
            
            return headerView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: kSettingsListCellID, for: indexPath) as? SettingsListCell {
            let type = SettingsType.init(rawValue: indexPath.row)
            cell.bind(type)
            
            return cell
        }
        
        return .init()
    }    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == SettingsType.feedback.rawValue {
            self.openMail()
        }
        else if indexPath.row == SettingsType.made.rawValue {
            self.openMade()
        }
    }
    
}

// MARK: - Mail

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

}
