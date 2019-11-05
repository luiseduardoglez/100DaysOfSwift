//
//  DetailViewController.swift
//  Project16
//
//  Created by Luis Eduardo Gonzalez on 2019-11-05.
//  Copyright © 2019 Luis Eduardo Gonzalez. All rights reserved.
//

import Foundation
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var url: String?

    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.load(URLRequest(url: URL(string: url!)!))
    }
}
