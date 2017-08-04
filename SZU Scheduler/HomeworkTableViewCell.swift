//
//  HomeworkTableViewCell.swift
//  SZU Scheduler
//
//  Created by 陈林 on 26/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class HomeworkTableViewCell: UITableViewCell {
    @IBOutlet weak var homeworkNameLabel: UILabel!
    @IBOutlet weak var subjectNameLabel: UILabel!
    @IBOutlet weak var optionalInfoLabel: UILabel!
    
    var homework: Homework? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        if let homework = homework {
            homeworkNameLabel.text = homework.homeworkName
            subjectNameLabel.text = homework.subject!.subjectName
            
            if homework.finished {
                optionalInfoLabel.text = "得分: " + (homework.score == -1 ? "待批改" : String(homework.score))
            } else {
                optionalInfoLabel.text = "截止日期: " + (homework.deadline?.format() ?? "无")
            }
        }
    }
}
