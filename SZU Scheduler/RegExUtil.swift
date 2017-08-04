//
//  RegExUtil.swift
//  SZU Scheduler
//
//  Created by 陈林 on 03/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

public class RegExUtil {
    class func matchs(pattern: String, from str: String) throws -> [NSTextCheckingResult] {
        do {
            let regex = try NSRegularExpression.init(pattern: pattern, options: .init(rawValue: 0))
            return regex.matches(in: str, options: .init(rawValue: 0), range: NSMakeRange(0, str.characters.count))
        } catch {
            throw error
        }
    }
}
