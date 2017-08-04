//
//  Subject+CoreDataProperties.swift
//  SZU Scheduler
//
//  Created by 陈林 on 03/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import CoreData


extension Subject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subject> {
        return NSFetchRequest<Subject>(entityName: "Subject")
    }

    @NSManaged public var courseId: String?
    @NSManaged public var subjectName: String?
    @NSManaged public var termNum: String?
    @NSManaged public var courseNum: String?
    @NSManaged public var homeworks: NSSet?
    @NSManaged public var student: Student?

}

// MARK: Generated accessors for homeworks
extension Subject {

    @objc(addHomeworksObject:)
    @NSManaged public func addToHomeworks(_ value: Homework)

    @objc(removeHomeworksObject:)
    @NSManaged public func removeFromHomeworks(_ value: Homework)

    @objc(addHomeworks:)
    @NSManaged public func addToHomeworks(_ values: NSSet)

    @objc(removeHomeworks:)
    @NSManaged public func removeFromHomeworks(_ values: NSSet)

}
