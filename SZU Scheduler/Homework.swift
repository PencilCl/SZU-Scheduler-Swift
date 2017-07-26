//
//  Homework.swift
//  SZU Scheduler
//
//  Created by 陈林 on 26/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

public class Homework {
    var homeworkName: String!
    var subject: Subject!
    var deadline: Date!
    var score: Int!
    
    init(homeworkName: String, subject: Subject, deadline: Date, score: Int) {
        self.homeworkName = homeworkName
        self.subject = subject
        self.deadline = deadline
        self.score = score
    }
}
