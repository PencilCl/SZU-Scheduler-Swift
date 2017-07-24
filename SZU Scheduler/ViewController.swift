//
//  ViewController.swift
//  SZU Scheduler
//
//  Created by 陈林 on 10/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        let layer = loginButton.layer
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
    }
    
    @IBAction func login(_ sender: UIButton) {
        if let username = account.text,
            let pass = password.text{
            if username == "150888", pass == "123456" {
                performSegue(withIdentifier: "login", sender: self)
                return
            }
        }
        print("login fail")
    }
    
}

