//
//  ViewController.swift
//  SZU Scheduler
//
//  Created by 陈林 on 10/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var account: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        let layer = loginButton.layer
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
    }
    
    @IBAction func login(_ sender: UIButton) {
        if let username = account.text, let pass = password.text,
            !username.isEmpty, !pass.isEmpty {
            loadingIndicator.startAnimating()
            loginButton.isUserInteractionEnabled = false
            loginButton.alpha = 0.4
            UserService.login(username: username, password: pass)
                .subscribe { [weak self] event in
                    self?.loadingIndicator.stopAnimating()
                    self?.loginButton.isUserInteractionEnabled = true
                    self?.loginButton.alpha = 1
                    switch event {
                    case .next(_):
                        if event.element != nil {
                            self?.performSegue(withIdentifier: "login", sender: nil)
                        } else {
                            self?.present(CommonUtil.getErrorAlertController(message: "获取用户信息失败"), animated: true, completion: nil)
                        }
                    case .error(let error):
                        var errorMsg = "发生未知错误"
                        if let e = error as? MsgError {
                            errorMsg = e.msg
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
    
    deinit {
        print("销毁登录界面")
    }
    
}

