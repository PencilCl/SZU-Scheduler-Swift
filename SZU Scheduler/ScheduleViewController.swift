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
        
        let currentDate = Date()
        selectMonthLabel.text = CVDate(date: currentDate, calendar: Calendar.init(identifier: .gregorian)).globalDescription
        refreshTodoList(date: currentDate)
        
        self.menuView.menuViewDelegate = self
        self.calendarView.calendarDelegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    func refreshTodoList(date: Date) {
        todoItemList = BlackboardService.getTodoList(date: date)
        todoItemList += CurriculumScheduleService.getTodoList(date: date)
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
        let date = dayView.date.convertedDate()!
        refreshTodoList(date: date)
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
