//
//  HomeworkViewController.swift
//  SZU Scheduler
//
//  Created by 陈林 on 26/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class HomeworkViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var homeworkArray: [Homework]? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension HomeworkViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeworkArray == nil ? 0 : homeworkArray!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 86
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homework", for: indexPath) as! HomeworkTableViewCell
        cell.homework = homeworkArray?[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
}
