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
            subjectNameLabel.text = homework.subject.subjectName
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            optionalInfoLabel.text = "截止日期:" + dateFormatter.string(from: homework.deadline)
        }
    }
    
}