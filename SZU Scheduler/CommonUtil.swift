//
//  CommonUtil.swift
//  SZU Scheduler
//
//  Created by 陈林 on 31/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import UIKit

public class CommonUtil {
    public class func getErrorAlertController(message: String) -> UIAlertController {
        let ac = UIAlertController.init(title: "错误", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return ac
    }
}
