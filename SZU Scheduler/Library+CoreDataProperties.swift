//
//  Library+CoreDataProperties.swift
//  SZU Scheduler
//
//  Created by 陈林 on 01/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import CoreData


extension Library {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Library> {
        return NSFetchRequest<Library>(entityName: "Library")
    }

    @NSManaged public var bookName: String?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var endDate: NSDate?
    @NSManaged public var student: Student?

}
