//
//  ModuleControlViewController.swift
//  SZU Scheduler
//
//  Created by 陈林 on 24/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class ModuleControlViewController: UIViewController,
    UITableViewDelegate,
    UITableViewDataSource {
    
    var module: [Module]?

    @IBOutlet weak var moduleTableView: UITableView! {
        didSet {
            self.moduleTableView.delegate = self
            self.moduleTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return module == nil ? 0 : module!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moduleTableView.dequeueReusableCell(withIdentifier: "moduleControl", for: indexPath) as! ModuleControlTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none // Set cell cannot be selected
        cell.module = module?[indexPath.row]
        return cell
    }

}
