//
//  TodoItemProtocol.swift
//  SZU Scheduler
//
//  Created by 陈林 on 01/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation

public protocol TodoItemProtocol {
    var timeBegin: String { get set }
    var timeEnd: String { get set }
    var title: String { get set }
    var detail: String { get set }
}
