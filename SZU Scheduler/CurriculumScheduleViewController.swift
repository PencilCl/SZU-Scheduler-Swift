//
//  CurriculumScheduleViewController.swift
//  SZU Scheduler
//
//  Created by 陈林 on 27/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class CurriculumScheduleViewController: UIViewController {
    @IBOutlet weak var schedule: CurriculumScheduleView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.rgbColorFromHex(rgb: 0x5c6bc0)
        // Add right item button on navigation
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "第25周 ▼", style: .plain, target: self, action: nil)
        
        schedule.addCourse(Course(courseName: "计算机系统(2)", venue: "教学楼B506", day: 1, timeBegin: 1, timeEnd: 2, weekBegin: 1, weekEnd: 17))
        schedule.addCourse(Course(courseName: "离散数学", venue: "教学楼B311", day: 1, timeBegin: 3, timeEnd: 4, weekBegin: 1, weekEnd: 17))
        schedule.addCourse(Course(courseName: "互联网编程", venue: "教学楼C407", day: 1, timeBegin: 5, timeEnd: 6, weekBegin: 1, weekEnd: 17))
        schedule.addCourse(Course(courseName: "互联网编程", venue: "实验室", day: 1, timeBegin: 7, timeEnd: 8, weekBegin: 1, weekEnd: 17))
        
        schedule.addCourse(Course(courseName: "操作系统", venue: "教学楼C410", day: 2, timeBegin: 1, timeEnd: 2, weekBegin: 1, weekEnd: 17))
        schedule.addCourse(Course(courseName: "操作系统", venue: "实验室", day: 2, timeBegin: 3, timeEnd: 4, weekBegin: 1, weekEnd: 17))
        schedule.addCourse(Course(courseName: "计算机论题", venue: "教学楼C513", day: 2, timeBegin: 5, timeEnd: 6, weekBegin: 1, weekEnd: 17))
        schedule.addCourse(Course(courseName: "软件工程", venue: "实验室", day: 2, timeBegin: 7, timeEnd: 8, weekBegin: 1, weekEnd: 17))
        schedule.addCourse(Course(courseName: "马克思主义基本原理", venue: "文科楼H-06", day: 2, timeBegin: 9, timeEnd: 10, weekBegin: 1, weekEnd: 17))
        schedule.addCourse(Course(courseName: "毛泽东思想和中国特色社会主义理论体系概论(2)", venue: "师院A204", day: 2, timeBegin: 11, timeEnd: 12, weekBegin: 1, weekEnd: 17))

        schedule.addCourse(Course(courseName: "离散数学", venue: "教学楼B311", day: 3, timeBegin: 1, timeEnd: 2, weekBegin: 1, weekEnd: 17))
        schedule.addCourse(Course(courseName: "计算机网络", venue: "教学楼C414", day: 3, timeBegin: 5, timeEnd: 6, weekBegin: 1, weekEnd: 17))
        schedule.addCourse(Course(courseName: "计算机网络", venue: "实验室", day: 3, timeBegin: 7, timeEnd: 8, weekBegin: 1, weekEnd: 17))
        
        schedule.addCourse(Course(courseName: "软件工程", venue: "教学楼A207", day: 4, timeBegin: 3, timeEnd: 4, weekBegin: 1, weekEnd: 17))
        schedule.addCourse(Course(courseName: "计算机系统(2)", venue: "实验室", day: 4, timeBegin: 7, timeEnd: 8, weekBegin: 1, weekEnd: 17))

    }

}
