//
//  Module+CoreDataClass.swift
//  SZU Scheduler
//
//  Created by 陈林 on 01/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import CoreData

@objc(Module)
public class Module: NSManagedObject {
    func toggle() {
        self.show = !self.show
    }
}
