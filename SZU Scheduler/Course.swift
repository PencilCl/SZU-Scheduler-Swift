//
//  Course.swift
//  SZU Scheduler
//
//  Created by 陈林 on 28/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

public class Course: NSObject {
    var courseName: String
    var venue: String
    var day: Int
    var timeBegin: Int
    var timeEnd: Int
    var weekBegin: Int
    var weekEnd: Int
    
    init(courseName: String, venue: String, day: Int, timeBegin: Int, timeEnd: Int, weekBegin: Int, weekEnd: Int) {
        self.courseName = courseName
        self.venue = venue
        self.day = day
        self.timeBegin = timeBegin
        self.timeEnd = timeEnd
        self.weekBegin = weekBegin
        self.weekEnd = weekEnd
    }
}
