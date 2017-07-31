//
//  User.swift
//  SZU Scheduler
//
//  Created by 陈林 on 31/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

public class User {
    public enum Gender {
        case male
        case female
    }
    
    var name: String
    var username: String
    var password: String
    var gender: Gender
    var stuNum: String
    
    init(username: String, password: String, gender: Gender, stuNum: String, name: String) {
        self.username = username
        self.password = password
        self.gender = gender
        self.stuNum = stuNum
        self.name = name
    }
    
    convenience init(username: String, password: String) {
        self.init(username: username, password: password, gender: .male, stuNum: "null", name: "")
    }
}
