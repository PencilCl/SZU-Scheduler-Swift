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
    var lastNavigationBarColor: UIColor!

    @IBOutlet weak var moduleTableView: UITableView! {
        didSet {
            self.moduleTableView.delegate = self
            self.moduleTableView.dataSource = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        if let navigationBar = navigationController?.navigationBar {
            lastNavigationBarColor = navigationBar.barTintColor
            navigationBar.barTintColor = 0xE84E40.uiColor
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 恢复状态栏颜色
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = lastNavigationBarColor
        }
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
