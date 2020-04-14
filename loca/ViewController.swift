//
//  ViewController.swift
//  loca
//
//  Created by Dalton on 4/10/20.
//  Copyright © 2020 Dalton. All rights reserved.
//

import UIKit
import WebKit


class ViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAddress()
    }
    
    private func loadAddress() {
        indicator.startAnimating()
        let aa = URL.init(string: "https://beta.localoca.vn")
        webView.navigationDelegate = self
        webView.load(URLRequest(url: aa!))
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {indicator.stopAnimating()
        Messages.displayErrorMessage(message: "Không thể tải dữ liệu. Vui lòng thử lại sau!")
    }
}

