//
//  Lesson+CoreDataProperties.swift
//  SZU Scheduler
//
//  Created by 陈林 on 01/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import CoreData


extension Lesson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        return NSFetchRequest<Lesson>(entityName: "Lesson")
    }

    @NSManaged public var lessonName: String?
    @NSManaged public var venue: String?
    @NSManaged public var classWeekBegin: Int16
    @NSManaged public var classWeekEnd: Int16
    @NSManaged public var time: Int16
    @NSManaged public var day: Int16
    @NSManaged public var begin: Int16
    @NSManaged public var end: Int16
    @NSManaged public var student: Student?

}
