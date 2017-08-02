//
//  LaunchViewController.swift
//  SZU Scheduler
//
//  Created by 陈林 on 02/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        // 用户已登录则直接加载主界面
        if let user = UserService.getUserFromUserDefaults() {
            UserService.currentUser = user
            performSegue(withIdentifier: "main", sender: nil)
            return
        }
        performSegue(withIdentifier: "login", sender: nil)
    }
    
}
