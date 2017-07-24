//
//  ModuleControlTableViewCell.swift
//  SZU Scheduler
//
//  Created by 陈林 on 24/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class ModuleControlTableViewCell: UITableViewCell {
    var module: Module? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var moduleNameLabel: UILabel!
    @IBOutlet weak var moduleSwitcher: UISwitch!
    @IBAction func toggleModule(_ sender: UISwitch) {
        module?.toggle()
    }
    
    func updateUI() {
        if let module = module {
            moduleNameLabel.text = module.name
            moduleSwitcher.isOn = module.show
        }
    }
    
}
