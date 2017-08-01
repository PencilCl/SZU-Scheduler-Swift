//
//  Module+CoreDataProperties.swift
//  SZU Scheduler
//
//  Created by 陈林 on 01/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import CoreData


extension Module {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Module> {
        return NSFetchRequest<Module>(entityName: "Module")
    }

    @NSManaged public var name: String?
    @NSManaged public var color: Int32
    @NSManaged public var show: Bool

}
