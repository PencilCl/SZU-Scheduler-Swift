//
//  Module.swift
//  SZU Scheduler
//
//  Created by 陈林 on 24/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit
import Foundation

public struct Module {
    let name: String
    let color: UIColor
    var show: Bool
    
    mutating func toggle() {
        show = !show
    }
}
