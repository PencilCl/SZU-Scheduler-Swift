//
//  TodoItem.swift
//  SZU Scheduler
//
//  Created by 陈林 on 29/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

public class TodoItem: NSObject, TodoItemProtocol {
    public var timeBegin: String
    public var timeEnd: String
    public var detail: String
    public var title: String
    
    init(timeBegin: String, timeEnd: String, title: String, detail: String) {
        self.timeBegin = timeBegin
        self.timeEnd = timeEnd
        self.title = title
        self.detail = detail
    }
}
