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
    
    override func viewDidAppear(_ animated: Bool) {
        // 用户已登录则直接加载主界面
        if let user = UserService.getUserFromUserDefaults() {
            UserService.currentUser = user
            performSegue(withIdentifier: "login", sender: nil)
            return
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        if let username = account.text, let pass = password.text,
            !username.isEmpty, !pass.isEmpty {
            UserService.login(username: username, password: pass)
                .subscribe { [weak self] event in
                    switch event {
                    case .next(_):
                        if let user = event.element {
                            UserService.currentUser = user
                            UserService.saveCurrentUserInfo()
                            self?.performSegue(withIdentifier: "login", sender: nil)
                        } else {
                            self?.present(CommonUtil.getErrorAlertController(message: "获取用户信息失败"), animated: true, completion: nil)
                        }
                    case .error(let error):
                        var errorMsg = "发生未知错误"
                        if let e = error as? UserService.OperationError {
                            switch e {
                            case .AuthError(let msg), .RequestError(let msg), .NotFoundError(let msg):
                                errorMsg = msg
                            }
                        }
                        self?.present(CommonUtil.getErrorAlertController(message: errorMsg), animated: true, completion: nil)
                    default:
                        break
                    }
                }
        } else {
            present(CommonUtil.getErrorAlertController(message: "用户名或密码不能为空"), animated: true, completion: nil)
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
}

