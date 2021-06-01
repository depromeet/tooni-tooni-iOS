//
//  DetailWebViewController.swift
//  TooniTooni
//
//  Created by buzz on 2021/05/30.
//

import UIKit
import WebKit

class DetailWebViewController: BaseViewController {

  // MARK: - Vars

  @IBOutlet weak var navigationView: GeneralNavigationView!
  @IBOutlet weak var webView: WKWebView!
  @IBOutlet weak var activity: GeneralActivity!

  var url: String?

  // MARK: - Life Cycle

  func initNavigationView() {
    navigationView.bgColor(.clear)
    navigationView.leftButton.isHidden = false
    navigationView.leftButton.setImage(UIImage(named: "icon_arrow_round_back"), for: .normal)
    navigationView.leftButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
  }

  func initWebView() {
    webView.navigationDelegate = self

    if let url = url {
      let urlRequest = URLRequest(url: URL(string: url)!)
      loadWebView(request: urlRequest)
    }
  }

  func initActivity() {
    webView.addSubview(activity)
    webView.bringSubviewToFront(activity)

    startActivity()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    initNavigationView()
    initWebView()
    initActivity()
  }
}

// MARK: - Event

extension DetailWebViewController {

  @objc
  func pop() {
    navigationController?.popViewController(animated: true)
  }
}

// MARK: - Helper method

extension DetailWebViewController {

  func loadWebView(request: URLRequest) {
    webView.load(request)
  }
}

// MARK: - WKWebView

extension DetailWebViewController: WKNavigationDelegate {

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    stopActivity()
  }
}

// MARK: - Activity

extension DetailWebViewController {

  func startActivity() {
    if activity.isAnimating() { return }
    activity.start()
  }

  func stopActivity() {
    if !activity.isAnimating() { return }
    activity.stop()
  }
}
