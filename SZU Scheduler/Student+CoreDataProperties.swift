//
//  Student+CoreDataProperties.swift
//  SZU Scheduler
//
//  Created by 陈林 on 01/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var stuNum: String?
    @NSManaged public var username: String?
    @NSManaged public var password: String?
    @NSManaged public var subjects: NSSet?
    @NSManaged public var books: NSSet?
    @NSManaged public var lessons: NSSet?

}

// MARK: Generated accessors for subjects
extension Student {

    @objc(addSubjectsObject:)
    @NSManaged public func addToSubjects(_ value: Subject)

    @objc(removeSubjectsObject:)
    @NSManaged public func removeFromSubjects(_ value: Subject)

    @objc(addSubjects:)
    @NSManaged public func addToSubjects(_ values: NSSet)

    @objc(removeSubjects:)
    @NSManaged public func removeFromSubjects(_ values: NSSet)

}

// MARK: Generated accessors for books
extension Student {

    @objc(addBooksObject:)
    @NSManaged public func addToBooks(_ value: Library)

    @objc(removeBooksObject:)
    @NSManaged public func removeFromBooks(_ value: Library)

    @objc(addBooks:)
    @NSManaged public func addToBooks(_ values: NSSet)

    @objc(removeBooks:)
    @NSManaged public func removeFromBooks(_ values: NSSet)

}

// MARK: Generated accessors for lessons
extension Student {

    @objc(addLessonsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)

    @objc(removeLessonsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)

    @objc(addLessons:)
    @NSManaged public func addToLessons(_ values: NSSet)

    @objc(removeLessons:)
    @NSManaged public func removeFromLessons(_ values: NSSet)

}
