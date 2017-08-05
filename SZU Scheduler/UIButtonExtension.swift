//
//  UIButtonExtension.swift
//  SZU Scheduler
//
//  Created by 陈林 on 06/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func decorate() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 1
        self.backgroundColor = 0x5677FC.uiColor
        self.layer.borderColor = 0x5677FC.uiColor.cgColor
    }
}
