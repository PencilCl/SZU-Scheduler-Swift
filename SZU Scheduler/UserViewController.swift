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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        decorateButton(logoutButton)
        decorateButton(aboutButton)
    }
    
    private func decorateButton(_ button:UIButton) {
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.backgroundColor = 0x5677FC.uiColor
        button.layer.borderColor = UIColor.lightGray.cgColor
    }
    
}
