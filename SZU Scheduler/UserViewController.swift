//
//  UserViewController.swift
//  SZU Scheduler
//
//  Created by 陈林 on 28/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.decorate()
        aboutButton.decorate()
        let user = UserService.currentUser!
        if user.gender! == "女" {
            avatarImageView.image = #imageLiteral(resourceName: "girl")
        } else {
            avatarImageView.image = #imageLiteral(resourceName: "boy")
        }
        nameLabel.text = user.name!
        
        navigationController?.navigationBar.tintColor = UIColor.white
        // 设置导航栏返回按钮文本为“返回”
        let item = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item;
    }

    @IBAction func logout(_ sender: UIButton) {
        UserService.logout()
        
        // Come back to login window
        if let loginCV = storyboard?.instantiateViewController(withIdentifier: "loginView"),
            let window = UIApplication.shared.delegate?.window,
            let availableWindow = window {
            availableWindow.rootViewController = loginCV
        }
    }
    
    deinit {
        print("销毁用户界面")
    }
    
}
