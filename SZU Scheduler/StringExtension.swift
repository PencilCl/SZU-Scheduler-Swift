//
//  StringExtension.swift
//  SZU Scheduler
//
//  Created by 陈林 on 03/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

extension String {
    func substring(with range: NSRange) -> String {
        return (self as NSString).substring(with: range)
    }
    
    func substring(to: Int) -> String {
        return self.substring(to: self.index(self.startIndex, offsetBy: to))
    }
    
    func substring(from: Int) -> String {
        return self.substring(from: self.index(self.endIndex, offsetBy: from - self.characters.count))
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
}
