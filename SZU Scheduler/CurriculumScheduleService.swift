//
//  CurriculumScheduleService.swift
//  SZU Scheduler
//
//  Created by 陈林 on 05/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import CoreData

import Alamofire

public class CurriculumScheduleService {
    private static let currentTerm = "20162"
    private static let scheduleUrl = "http://pencilsky.cn:9090/api/curriculum/?stuNum=%@&term=%@"
    private static let classTimeReg = "([^0-9]+)([0-9]+),([0-9]+)"
    
    private static let lessonEntityName = "Lesson"
    
    public class func refresh() {
        removeAllData()
        let user = UserService.currentUser!
        Alamofire.request(String.init(format: scheduleUrl, user.stuNum!, currentTerm))
            .responseJSON { response in
                switch response.result {
                case .success(_):
                    if let json = response.result.value as? [String: Any] {
                        if let code = json["code"] as? Int,
                            code != 10000 {
                            print("查询课程表数据失败")
                            return
                        }
                        
                        if let data = json["data"] as? [String: Any],
                            let coursesInfo = data[currentTerm] as? [[String: String]] {
                            for courseInfo in coursesInfo {
                                if courseInfo["courseTime"] == "." {
                                    // 上课时间为.的课程为慕课课程，不需要添加到课程表中
                                    continue
                                }
                                
                                if let classWeek = courseInfo["classWeek"]?.components(separatedBy: "-"),
                                    let classTime = courseInfo["classTime"]?.components(separatedBy: ";"),
                                    let venue = courseInfo["venue"]?.components(separatedBy: ";"),
                                    let lessonName = courseInfo["courseName"] {
                                    for i in 0..<classTime.count {
                                        let res = try! RegExUtil.matchs(pattern: classTimeReg, from: classTime[i])
                                        if res.count > 0 {
                                            let matcher = res[0]
                                            let lesson = NSEntityDescription.insertNewObject(forEntityName: lessonEntityName, into: CommonUtil.context) as! Lesson
                                            lesson.lessonName = lessonName
                                            lesson.venue = venue[i]
                                            lesson.day = getDay(classTime[i].substring(with: matcher.rangeAt(1)))
                                            lesson.begin = Int16.init(classTime[i].substring(with: matcher.rangeAt(2)))!
                                            lesson.end = Int16.init(classTime[i].substring(with: matcher.rangeAt(3)))!
                                            lesson.classWeekBegin = Int16.init(classWeek[0])!
                                            lesson.classWeekEnd = Int16.init(classWeek[1])!
                                            lesson.time = classTime[i].hasPrefix("周") ?  Lesson.allWeek : (classTime[i].hasPrefix("单") ? Lesson.oddWeek : Lesson.evenWeek)
                                            
                                            lesson.student = user
                                        }
                                    }
                                }
                            }
                        }
                    }
                case .failure(_):
                    print("获取课程表数据失败")
                }
        }
    }
    
    public static func getTodoList(date: Date) -> [TodoItem] {
        var res = [TodoItem]()
        let timeTpl = "第%d节"
        
        if let lessons = UserService.currentUser!.lessons?.allObjects as? [Lesson] {
            for lesson in lessons {
                if Int(lesson.day) == date.weekDay() {
                    res.append(TodoItem(timeBegin: String.init(format: timeTpl, lesson.begin),
                                        timeEnd: String.init(format: timeTpl, lesson.end),
                                        title: lesson.lessonName!, detail: lesson.venue!))
                }
            }
        }
        
        return res
    }
    
    private class func removeAllData() {
        if let lessons = UserService.currentUser!.lessons?.allObjects as? [Lesson] {
            for lesson in lessons {
                CommonUtil.context.delete(lesson)
            }
        }
    }
    
    private static func getDay(_ dayStr: String) -> Int16 {
        switch dayStr.substring(from: dayStr.characters.count - 2) {
        case "周一": return 1
        case "周二": return 2
        case "周三": return 3
        case "周四": return 4
        case "周五": return 5
        default: return 0
        }
    }
    
}
