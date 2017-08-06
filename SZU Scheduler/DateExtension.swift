//
//  DateExtension.swift
//  SZU Scheduler
//
//  Created by 陈林 on 27/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

extension NSDate {
    func format(with dateFormat: String = "yyyy-MM-dd HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self as Date)
    }
}

extension Date {
    func weekDay() -> Int {
        let days = (Int(self.timeIntervalSince1970) + NSTimeZone.local.secondsFromGMT()) / 86400 // 24*60*60
        let weekday = ((days + 4)%7+7)%7
        return weekday == 0 ? 7 : weekday
    }
}
