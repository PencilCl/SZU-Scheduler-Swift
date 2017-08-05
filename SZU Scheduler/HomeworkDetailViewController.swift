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
    @IBOutlet weak var attachmentsTextView: UITextView!
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
            updateDetailUI(homework)
            updateAttachmentUI(homework)
            nameLabel.text = homework.homeworkName!
            deadlineLabel.text = "截止日期: " + (homework.deadline?.format() ?? "无")
            scoreLabel.text = "得分: " + (homework.score == -1 ? "待批改" : String(homework.score))
        }
    }
    
    private func updateDetailUI(_ homework: Homework) {
        DispatchQueue.global().async { [weak self] in
            do {
                let detailText = "<div style=\"font-size: 17px;\">" + homework.detail! + "</div>"
                let detailAttrText = try NSAttributedString(data: detailText.data(using: String.Encoding.unicode, allowLossyConversion: true)!, options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType], documentAttributes: nil)
                
                DispatchQueue.main.async {
                    self?.detailLabel.attributedText = detailAttrText
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateAttachmentUI(_ homework: Homework) {
        if let attachments = homework.attachments {
            DispatchQueue.global().async { [weak self] in
                let attachmentsAttrText = NSMutableAttributedString()
                for attachment in (attachments.allObjects as! [Attachment]) {
                    let appendAttrText = NSMutableAttributedString(string: attachment.attachmentName!.appending("\n"), attributes: [NSFontAttributeName: self?.attachmentsTextView.font!])
                    appendAttrText.beginEditing()
                    appendAttrText.addAttribute(NSLinkAttributeName, value: attachment.attachmentUrl!, range: NSMakeRange(0, appendAttrText.length - 1))
                    appendAttrText.endEditing()
                    attachmentsAttrText.append(appendAttrText)
                }
                DispatchQueue.main.async {
                    self?.attachmentsTextView.attributedText = attachmentsAttrText
                }
            }
        }
    }
}
