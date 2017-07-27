//
//  BookTableViewCell.swift
//  SZU Scheduler
//
//  Created by 陈林 on 27/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    var book: Book? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var bookNameLabel: UILabel!
    @IBOutlet weak var borrowTimeLabel: UILabel!
    @IBOutlet weak var returnDeadlineLabel: UILabel!
    
    private func updateUI() {
        if let book = book {
            bookNameLabel.text = book.bookName
            borrowTimeLabel.text = "借阅时间: " + book.borrowTime.format(with: "yyyy-MM-dd")
            returnDeadlineLabel.text = "归还时间: " + book.returnDeadline.format(with: "yyyy-MM-dd")
        }
    }
}
