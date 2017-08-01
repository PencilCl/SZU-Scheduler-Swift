//
//  GobyeViewController.swift
//  SZU Scheduler
//
//  Created by 陈林 on 27/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class GobyeViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView! {
        didSet {
            let url = URL(string: "http://stu.szu.edu.cn/gobye")
            let urlRequest = URLRequest(url: url!)
            webView.loadRequest(urlRequest)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = 0x29b6f6.uiColor
    }
    
}
