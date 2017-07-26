//
//  SubjectTableViewController.swift
//  SZU Scheduler
//
//  Created by 陈林 on 26/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class SubjectTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var subjectArray: [Subject]? {
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

extension SubjectTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subjectArray == nil ? 0 : subjectArray!.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subject", for: indexPath)
        if let subject = subjectArray?[indexPath.row] {
            cell.textLabel?.text = subject.subjectName
            cell.detailTextLabel?.text = "有新动态"
            cell.selectionStyle = .none
        }
        return cell
    }
}
