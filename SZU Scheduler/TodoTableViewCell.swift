//
//  TodoTableViewCell.swift
//  SZU Scheduler
//
//  Created by 陈林 on 29/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    var todoItem: TodoItem? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var timeBeginLabel: UILabel!
    @IBOutlet weak var timeEndLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    private func updateUI() {
        if let item = todoItem {
            timeBeginLabel.text = item.timeBegin
            timeEndLabel.text = item.timeEnd
            titleLabel.text = item.title
            descriptionLabel.text = item.description
        }
    }
}
