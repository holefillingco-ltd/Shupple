//
//  WebQuestionnaireViewController.swift
//  Shupple
//
//  Created by 磯崎 裕太 on 2019/10/04.
//  Copyright © 2019 HoleFillingCo.,Ltd. All rights reserved.
//

import UIKit
import WebKit

class WebQuestionnaireViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var header: UINavigationBar!
    let indicator = Indicator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Header().setHeader(header: header, view: view, color: .headerGray)
        
        indicator.start(view: view)
        let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSeoSCOmYCrL5nzilc5Not31fDLOK4ZmxK1NYCXUfA5UbHB-cQ/viewform?usp=sf_link")
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
}
