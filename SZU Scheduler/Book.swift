//
//  Book.swift
//  SZU Scheduler
//
//  Created by 陈林 on 27/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

public class Book {
    var bookName: String
    var borrowTime: Date
    var returnDeadline: Date
    
    init(bookName: String, borrowTime: Date, returnDeadline: Date) {
        self.bookName = bookName
        self.borrowTime = borrowTime
        self.returnDeadline = returnDeadline
    }
}
