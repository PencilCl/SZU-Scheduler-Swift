//
//  HomeworkDetailViewController.swift
//  SZU Scheduler
//
//  Created by 陈林 on 27/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class HomeworkDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var attachmentsLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    private var loadedView = false
    
    var homework: Homework? {
        didSet {
            if loadedView {
                updateUI()
            }
        }
    }
    
    override func viewDidLoad() {
        loadedView = true
        updateUI()
    }
    
    private func updateUI() {
        if let homework = homework {
            nameLabel.text = homework.homeworkName!
            deadlineLabel.text = "截止日期: " + (homework.deadline?.format() ?? "无")
            scoreLabel.text = "得分: " + (homework.score == -1 ? "待批改" : String(homework.score))
            
            DispatchQueue.global().async { [weak self] in
                do {
                    let detailText = "<div style=\"font-size: 17px;\">" + homework.detail! + "</div>"
                    let detailAttrText = try NSAttributedString(data: detailText.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                    
                    DispatchQueue.main.async {
                        self?.detailLabel.attributedText = detailAttrText
                    }
                    
                    var attachmentsHtml = ""
                    if let attachments = homework.attachments {
                        for attachment in (attachments.allObjects as! [Attachment]) {
                            print("find ")
                            attachmentsHtml = attachmentsHtml.appendingFormat("<a style=\"font-size: 17px;color: #8FB166;\" href=\"%@\" target=\"_blank\">%@</a><br>", attachment.attachmentUrl!, attachment.attachmentName!)
                        }
                    }
                    print(attachmentsHtml)
                    let attachmentsAttrText = try NSAttributedString(data: attachmentsHtml.data(using: .unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                    DispatchQueue.main.async {
                        self?.attachmentsLabel.attributedText = attachmentsAttrText
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        }
    }
    
}
