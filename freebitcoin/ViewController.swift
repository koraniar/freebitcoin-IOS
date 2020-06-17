//
//  ViewController.swift
//  freebitcoin
//
//  Created by Esteban Garcia Alvarez on 16/06/20.
//  Copyright © 2020 Esteban Garcia Alvarez. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string:"https://freebitco.in/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
}


