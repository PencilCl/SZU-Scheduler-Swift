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
        navigationController?.navigationBar.barTintColor = 0x5c6bc0.uiColor
        // Add right item button on navigation
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "第25周 ▼", style: .plain, target: self, action: nil)
        
        if let lessons = UserService.currentUser!.lessons?.allObjects as? [Lesson] {
            for lesson in lessons {
                schedule.addCourse(lesson)
            }
        }
        
    }

}
