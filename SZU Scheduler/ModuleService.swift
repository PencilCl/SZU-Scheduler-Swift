//
//  ModuleService.swift
//  SZU Scheduler
//
//  Created by 陈林 on 02/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import UIKit
import CoreData

public class ModuleService {
    private static let entityName = "Module"
    
    private static let defaultModuleInfo = [
        "课程表": 0x5c6bc0,
        "Gobye": 0x29b6f6,
        "图书馆": 0xff7043,
        "Blackboard": 0x9ccc65
    ]
    
    static var moduleList: [Module] = {
        if let moduleList = fetchModuleList(),
            moduleList.count > 0 {
            return moduleList
        }
        createDefaultModule()
        if let moduleList = fetchModuleList() {
            return moduleList
        }
        return [Module]()
    }()
    
    // Create default Module table data
    private static func createDefaultModule() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        
        for (name, color) in defaultModuleInfo {
            let module = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! Module
            module.name = name
            module.color = Int32.init(color)
            module.show = true
        }
        
        app.saveContext()
    }
    
    private static func fetchModuleList() -> [Module]? {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        return try? context.fetch(fetchRequest) as! [Module]
    }
    
}
