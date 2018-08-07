//
//  ZSCWebController.swift
//  DouYin
//
//  Created by Niu Changming on 5/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import WebKit

class ZSCWebController: UIViewController, WKNavigationDelegate {
    
    lazy var progressBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.frame = CGRect(x: 0, y: Constants.Dimension.STATUS_BAR_HEIGHT, width: self.view.frame.size.width, height: 2)
        progressBar.sizeToFit()
        self.view.addSubview(progressBar)
        return progressBar
    }()
    
    lazy var zscWebView: WKWebView = {
        let zscWebView = WKWebView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - Constants.Dimension.BOTTOM_MARGE))
        zscWebView.navigationDelegate = self
        zscWebView.allowsBackForwardNavigationGestures = true
        zscWebView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        self.view.addSubview(zscWebView)
        return zscWebView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = URL(string: "http://www.zscsg.com/")!
        self.zscWebView.load(URLRequest(url: url))
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            self.progressBar.progress = Float(self.zscWebView.estimatedProgress)
            
            if self.progressBar.progress == 1 {
                self.progressBar.isHidden = true
            }
        }
    }
}
