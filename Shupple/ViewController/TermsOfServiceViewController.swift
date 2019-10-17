//
//  TermsOfServiceViewController.swift
//  Shupple
//
//  Created by 磯崎 裕太 on 2019/10/17.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit
import WebKit

class TermsOfServiceViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var header: UINavigationBar!
    @IBOutlet weak var webView: WKWebView!
    let indicator = Indicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        Header().setHeader(header: header, view: view, color: .headerGray)
        
        indicator.start(view: view)
        let url = URL(string: "https://nojigeitu.com/privacy/")
        let muRequest = URLRequest(url: url!)
        webView.load(muRequest)
        indicator.stop(view: view)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicator.start(view: webView)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stop(view: webView)
    }
    
    private func setLayout() {
        var webViewRect = webView.frame
        webViewRect.size.width = view.frame.width
        webView.frame = webViewRect
    }
    
}
