//
//  ScheduleViewController.swift
//  SZU Scheduler
//
//  Created by 陈林 on 28/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit
import CVCalendar

class ScheduleViewController: UIViewController {
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var selectMonthLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    var todoItemList = [TodoItem]() {
        didSet {
            tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectMonthLabel.text = CVDate(date: Date(), calendar: Calendar.init(identifier: .gregorian)).globalDescription
        self.menuView.menuViewDelegate = self
        self.calendarView.calendarDelegate = self
        
        todoItemList = [
            TodoItem(timeBegin: "第一节", timeEnd: "第二节", title: "标题", detail: "详细描述"),
            TodoItem(timeBegin: "第一节", timeEnd: "第二节", title: "标题", detail: "详细描述"),
            TodoItem(timeBegin: "第一节", timeEnd: "第二节", title: "标题", detail: "详细描述"),
            TodoItem(timeBegin: "第一节", timeEnd: "第二节", title: "标题", detail: "详细描述"),
            TodoItem(timeBegin: "第一节", timeEnd: "第二节", title: "标题", detail: "详细描述")
        ]
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
}

extension ScheduleViewController: CVCalendarMenuViewDelegate, CVCalendarViewDelegate {
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    func firstWeekday() -> Weekday {
        return .monday
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        selectMonthLabel.text = date.globalDescription
    }
    
    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool {
        return false
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return true
    }
    
    func didSelectDayView(_ dayView: DayView, animationDidFinish: Bool) {
//        let date = dayView.date.convertedDate()!
    }
}

extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todo", for: indexPath) as! TodoTableViewCell
        cell.selectionStyle = .none
        cell.todoItem = todoItemList[indexPath.row]
        return cell
    }
}
