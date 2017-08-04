//
//  MsgError.swift
//  SZU Scheduler
//
//  Created by 陈林 on 02/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

public class MsgError: Error {
    let msg: String
    
    init(_ error: String) {
        msg = error
    }
}
