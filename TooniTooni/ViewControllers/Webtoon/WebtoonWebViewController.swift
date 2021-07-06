//
//  WebtoonWebViewController.swift
//  TooniTooni
//
//  Created by buzz on 2021/07/04.
//

import UIKit
import WebKit

class WebtoonWebViewController: BaseViewController {

  // MARK: - Properties

  @IBOutlet var navigationView: GeneralNavigationView!
  @IBOutlet var webView: WKWebView!
  @IBOutlet var activity: CustomActivity!

  var webtoonItem: Webtoon?

  // MARK: - Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    initNavigationView()
    setupWebView()
  }

  private func initNavigationView() {
    if let title = webtoonItem?.title {
      navigationView.title(title)
    }
    navigationView.bigTitle(false)
    navigationView.leftButton(true)

    navigationView.leftButton.isHidden = false
    navigationView.leftButton.setImage(UIImage(named: "icon_back")?.withRenderingMode(.alwaysTemplate), for: .normal)
    navigationView.leftButton.tintColor = kGRAY_90
    navigationView.leftButton.addTarget(self, action: #selector(doBack), for: .touchUpInside)
  }

  private func setupWebView() {
    if let webtoon = webtoonItem?.url,
       let url = URL(string: webtoon) {
      webView.load(URLRequest(url: url))
    }

    webView.navigationDelegate = self
  }
}

// MARK: - Event

extension WebtoonWebViewController {

  @objc
  func doBack() {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - WKWebView delegate

extension WebtoonWebViewController: WKNavigationDelegate {

  func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
    startActivity()
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    stopActivity()
  }
}

// MARK: - Activity

extension WebtoonWebViewController {

  func startActivity() {
    if activity.isAnimating() { return }
    activity.start()
  }

  func stopActivity() {
    if !activity.isAnimating() { return }
    activity.stop()
  }
}
