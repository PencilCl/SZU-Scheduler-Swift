//
//  TodoItem.swift
//  SZU Scheduler
//
//  Created by 陈林 on 29/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

public class TodoItem {
    var timeBegin: String
    var timeEnd: String
    var title: String
    var description: String
    
    init(timeBegin: String, timeEnd: String, title: String, description: String) {
        self.timeBegin = timeBegin
        self.timeEnd = timeEnd
        self.title = title
        self.description = description
    }
}
