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
