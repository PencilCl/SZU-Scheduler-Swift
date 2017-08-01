//
//  LibraryViewController.swift
//  SZU Scheduler
//
//  Created by 陈林 on 27/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class LibraryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var bookList: [Library]? {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = 0xff7043.uiColor
        
//        bookList = [Library(bookName: "测试书名", startDate: Date(), endDate: Date())]
    }
}

extension LibraryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookList?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

extension LibraryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "book", for: indexPath) as! BookTableViewCell
        cell.book = bookList?[indexPath.row]
        return cell
    }
}
