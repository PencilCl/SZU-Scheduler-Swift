//
//  Int32Extension.swift
//  SZU Scheduler
//
//  Created by 陈林 on 01/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import UIKit

extension Int {
    var uiColor: UIColor {
        get {
            return UIColor(red: ((CGFloat)((self & 0xFF0000) >> 16)) / 255.0,
                           green: ((CGFloat)((self & 0xFF00) >> 8)) / 255.0,
                           blue: ((CGFloat)(self & 0xFF)) / 255.0,
                           alpha: 1.0)
        }
        set {
            self.uiColor = newValue
        }
    }
}


