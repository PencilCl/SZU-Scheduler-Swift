//
//  Lesson+CoreDataClass.swift
//  SZU Scheduler
//
//  Created by 陈林 on 01/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import CoreData

@objc(Lesson)
public class Lesson: NSManagedObject {
    public static let allWeek: Int16 = 0
    public static let oddWeek: Int16 = 1
    public static let evenWeek: Int16 = 2
}
