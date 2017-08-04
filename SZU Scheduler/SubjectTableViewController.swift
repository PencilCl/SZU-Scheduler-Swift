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
    
    var subjects: NSSet? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier,
            id == "homework",
            let subject = sender as? Subject {
            let cv = segue.destination as! HomeworkViewController
            cv.homeworkArray = subject.homeworks?.allObjects as? [Homework]
        }
    }
}

extension SubjectTableViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (subjects?.count) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subject", for: indexPath)
        if let subject = subjects?.allObjects[indexPath.row] as? Subject {
            cell.textLabel?.text = subject.subjectName
            cell.detailTextLabel?.text = "有新动态"
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let subject = subjects?.allObjects[indexPath.row] as? Subject {
            performSegue(withIdentifier: "homework", sender: subject)
        }
    }
}
