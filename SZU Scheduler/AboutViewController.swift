//
//  AboutViewController.swift
//  SZU Scheduler
//
//  Created by 陈林 on 06/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var commitButton: UIButton!
    @IBOutlet weak var placeholderLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commitButton.decorate()
        
        feedbackTextView.layer.borderColor = 0xeeeeee.uiColor.cgColor
        feedbackTextView.layer.borderWidth = 1
        feedbackTextView.layer.cornerRadius = 8
        feedbackTextView.delegate = self
    }

    @IBAction func commit(_ sender: UIButton) {
        
    }
}

extension AboutViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == nil || textView.text!.isEmpty {
            placeholderLabel.text = "请输入您想要发送的消息"
        } else {
            placeholderLabel.text = ""
        }
    }
}
