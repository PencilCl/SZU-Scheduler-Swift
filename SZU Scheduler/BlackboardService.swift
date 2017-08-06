//
// Created by 陈林 on 02/08/2017.
// Copyright (c) 2017 Pencil. All rights reserved.
//

import Foundation
import CoreData

import RxSwift
import RxCocoa
import Alamofire

public class BlackboardService {
    
    private static let baseUrl = "http://elearning.szu.edu.cn"
    private static let enterBBUrl = "http://elearning.szu.edu.cn/webapps/cbb-sdgxtyM-BBLEARN/checksession.jsp"
    private static let bbUrl = "http://elearning.szu.edu.cn/webapps/portal/frameset.jsp"; // 成功进入bb的页面
    private static let courseUrl = "http://elearning.szu.edu.cn/webapps/portal/execute/tabs/tabAction";
    
    private static let currentTerm = "20162"
    
    private static let subjectEntityName = "Subject"
    private static let attachmentEntityName = "Attachment"
    private static let homeworkEntityName = "Homework"
    
    public static func getTodoList(date: Date) -> [TodoItem] {
        var res = [TodoItem]()
        
        if let homeworks = getAllHomework() {
            for homework in homeworks {
                if !homework.finished,
                    homework.deadline != nil,
                    Calendar.current.isDate(homework.deadline! as Date, inSameDayAs: date) {
                    res.append(TodoItem(timeBegin: "00:00", timeEnd: homework.deadline!.format(with: "hh:mm"), title: homework.homeworkName!, detail: homework.subject!.subjectName!))
                }
            }
        }
        
        return res
    }
    
    public static func getUnfinishedHomeworks() -> [Homework] {
        var res = [Homework]()
        
        if let homeworks = getAllHomework() {
            for homework in homeworks {
                if !homework.finished {
                    res.append(homework)
                }
            }
        }
        
        return res
    }
    
    public static func refreshSubject() {
        loginBB()
            .subscribe { event in
                switch event {
                case .next(_):
                    getSubjectFromNetwork()
                case .error(let e):
                    if let error = e as? MsgError {
                        print(error.msg)
                    }
                    print("unkown error")
                default:
                    break
                }
        }
    }
    
    private static func getAllHomework() -> [Homework]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: homeworkEntityName)
        return try? CommonUtil.context.fetch(request) as! [Homework]
    }
    
    private static func removeAllData() {
        if let subjects = UserService.currentUser!.subjects {
            for subject in subjects {
                removeSubject(subject: subject as! Subject)
            }
        }
        CommonUtil.app.saveContext()
    }
    
    private static func removeSubject(subject: Subject) {
        if let homeworks = subject.homeworks {
            for homework in homeworks {
                removeHomework(homework: homework as! Homework)
            }
        }
        CommonUtil.context.delete(subject)
    }
    
    private static func removeHomework(homework: Homework) {
        if let attachments = homework.attachments {
            for attachment in attachments {
                CommonUtil.context.delete(attachment as! Attachment)
            }
        }
        CommonUtil.context.delete(homework)
    }
    
    private static func getSubjectFromNetwork() {
        let params: Parameters = [
            "action": "refreshAjaxModule",
            "modId": "_25_1",
            "tabId": "_2_1",
            "tab_tab_group_id": "_2_1"
        ]
        Alamofire.request(courseUrl, method: .post, parameters: params)
            .responseString { response in
                if let html = response.result.value {
                    let res = try! RegExUtil.matchs(pattern: "<a href=\"(.*?)\".*>(.*?)</a>", from: html)
                    for matcher in res {
                        let link = html.substring(with: matcher.rangeAt(1)).trim()
                        let info = html.substring(with: matcher.rangeAt(2)).trim()
                        let termNum = info.substring(to: 5)
                        if termNum != currentTerm {
                            continue
                        }
                        let str = link.components(separatedBy: "%3D")
                        let colonIndex = (info.range(of: ":")?.lowerBound)!
                        
                        let subject = NSEntityDescription.insertNewObject(forEntityName: subjectEntityName, into: CommonUtil.context) as! Subject
                        subject.subjectName = info.substring(from: info.index(colonIndex, offsetBy: 2))
                        subject.courseId = str[str.count - 2].components(separatedBy: "%26")[0]
                        subject.courseNum = info.substring(from: 6).substring(to: info.index(colonIndex, offsetBy: -6))
                        subject.termNum = termNum
                        subject.student = UserService.currentUser!
                        
                        getHomeworkFromNetwork(by: subject)
                    }
                    CommonUtil.app.saveContext()
                }
        }
    }
    
    // Getting all homework of the subject
    private static func getHomeworkFromNetwork(by subject: Subject) {
        Alamofire.request(String.init(format: "http://elearning.szu.edu.cn/webapps/blackboard/execute/modulepage/view?course_id=%@&mode=view", subject.courseId!))
            .responseString { response in
                if let html = response.result.value {
                    let res = try! RegExUtil.matchs(pattern: "<a href=\"(.*?)\" target=\"_self\"><span title=\"网上作业\">网上作业</span></a>", from: html)
                    if res.count == 0 {
                        // Cann't find address of homework, skipping it
                        return
                    }
                    let matcher = res[0]
                    let homeworkUrl = html.substring(with: matcher.rangeAt(1))
                    Alamofire.request(homeworkUrl)
                        .responseString { response in
                            if let html = response.result.value {
                                let res = try! RegExUtil.matchs(pattern: "<li[\\w\\W]*?id=\"contentListItem[\\w\\W]*?>[\\w\\W]*?<a href=\"([\\w\\W]*?)\"><span style=\"color:#000000;\">([\\w\\W]*?)</span>[\\w\\W]*?(<ul class=\"attachments clearfix\">([\\w\\W]*?)</ul>)?[\\w\\W]*?<div class=\"vtbegenerated\">([\\w\\W]*?)<div id=\"[\\w\\W]*?</li>", from: html)
                                for matcher in res {
                                    let singleHomeworkHtml = html.substring(with: matcher.rangeAt(0))
                                    let hasAttachment = singleHomeworkHtml.contains("<th scope=\"row\">已附加文件:</th>")
                                    var singleHomeworkPattern = "<li[\\w\\W]*?id=\"contentListItem[\\w\\W]*?>[\\w\\W]*?<a href=\"([\\w\\W]*?)\"><span style=\"color:#000000;\">([\\w\\W]*?)</span>[\\w\\W]*?<div class=\"vtbegenerated\">([\\w\\W]*?)<div id=\""
                                    if hasAttachment {
                                        singleHomeworkPattern = "<li[\\w\\W]*?id=\"contentListItem[\\w\\W]*?>[\\w\\W]*?<a href=\"([\\w\\W]*?)\"><span style=\"color:#000000;\">([\\w\\W]*?)</span>[\\w\\W]*?<ul class=\"attachments clearfix\">([\\w\\W]*?)</ul>[\\w\\W]*?<div class=\"vtbegenerated\">([\\w\\W]*?)<div id=\""
                                    }
                                    
                                    let singleHomeworkMatcher = try! RegExUtil.matchs(pattern: singleHomeworkPattern, from: singleHomeworkHtml)
                                    
                                    if singleHomeworkMatcher.count == 0 {
                                        print("not found")
                                        continue
                                    }
                                    
                                    let homework = NSEntityDescription.insertNewObject(forEntityName: homeworkEntityName, into: CommonUtil.context) as! Homework
                                    homework.subject = subject
                                    if hasAttachment {
                                        let attachmentPattern = "<a href=\"([\\w\\W]*?)\" target=\"_blank\">([\\w\\W]*?)&nbsp;([\\w\\W]*?)</a>"
                                        let attachmentsHtml = singleHomeworkHtml.substring(with: singleHomeworkMatcher[0].rangeAt(3))
                                        let attachmentsMatcher = try! RegExUtil.matchs(pattern: attachmentPattern, from: attachmentsHtml)
//                                        print(attachmentsHtml)
                                        for attachmentMatcher in attachmentsMatcher {
                                            let attachment = NSEntityDescription.insertNewObject(forEntityName: attachmentEntityName, into: CommonUtil.context) as! Attachment
                                            attachment.attachmentName = attachmentsHtml.substring(with: attachmentMatcher.rangeAt(3))
                                            attachment.attachmentUrl = baseUrl + attachmentsHtml.substring(with: attachmentMatcher.rangeAt(1))
                                            attachment.homework = homework
                                        }
                                    }
                                    homework.homeworkName = singleHomeworkHtml.substring(with: singleHomeworkMatcher[0].rangeAt(2))
                                    homework.detail = singleHomeworkHtml.substring(with: singleHomeworkMatcher[0].rangeAt(hasAttachment ? 4 : 3)).replacingOccurrences(of: "</div>", with: "\n").replacingOccurrences(of: "<div>", with: "").trim()
                                    homework.score = -1
                                    getHomeworkOtherInfo(url: singleHomeworkHtml.substring(with: singleHomeworkMatcher[0].rangeAt(1)), homework: homework)
                                }
                                
                                CommonUtil.app.saveContext()
                            }
                    }
                }
        }
    }
    
    private static func getHomeworkOtherInfo(url: String, homework: Homework) {
        Alamofire.request(baseUrl + url)
            .responseString { response in
                if let html = response.result.value {
                    // Get deadline
                    let matchers = try! RegExUtil.matchs(pattern: "id=\"dueDate\" value=\"(.*?)\"", from: html)
                    if matchers.count > 0 {
                        let deadlineStr = html.substring(with: matchers[0].rangeAt(1))
                        if "&nbsp;" != deadlineStr {
                            homework.deadline = strToDate(deadlineStr) as NSDate
                            CommonUtil.app.saveContext()
                        }
                    }
                    var index = html.range(of: "/webapps/blackboard/execute/attemptExpandListItemGenerator?attempt_id=")
                    if index == nil {
                        index = html.range(of: "/webapps/blackboard/execute/groupAttemptExpandListItemGenerator?groupAttempt_id=")
                    }
                    if index != nil {
                        homework.finished = true
                        let scoreUrl = html.substring(with: index!.lowerBound..<html.range(of: "\"", range: index!.lowerBound..<html.endIndex)!.lowerBound)
                        let params: Parameters = [
                            "course_id": homework.subject!.courseId!,
                            "filterAttemptHref": "%2Fwebapps%2Fblackboard%2Fexecute%2FgradeAttempt"
                        ]
                        Alamofire.request(baseUrl + scoreUrl, method: .post, parameters: params)
                            .responseString { response in
                                if let html = response.result.value {
                                    let matcher = try! RegExUtil.matchs(pattern: "成绩 :.*?([0-9]+).*", from: html)
                                    if matcher.count > 0 {
                                        homework.score = Int16(Int.init(html.substring(with: matcher[0].rangeAt(1)).trim())!)
                                        CommonUtil.app.saveContext()
                                    }
                                }
                        }
                    }
                }
        }
    }
    
    private static func strToDate(_ str: String) -> Date {
        let pattern = "([0-9]+)年([0-9]+)月([0-9]+)日 (.)午([0-9]+)时([0-9]+)分"
        let matcher = try! RegExUtil.matchs(pattern: pattern, from: str)
        if matcher.count > 0 {
            let res = matcher[0]
            let year = Int(str.substring(with: res.rangeAt(1)))!
            let month = Int(str.substring(with: res.rangeAt(2)))!
            let day = Int(str.substring(with: res.rangeAt(3)))!
            var hours = Int(str.substring(with: res.rangeAt(5)))!
            if str.substring(with: res.rangeAt(4)) == "下" {
                hours += 12
            }
            let minutes = Int(str.substring(with: res.rangeAt(6)))!
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMddHHmm"
            if let date = formatter.date(from: String.init(format: "%0.4d%0.2d%0.2d%0.2d%0.2d", year, month, day, hours, minutes)) {
                return date
            }
        }
        return Date()
    }

    // Login blackboard
    private static func loginBB() -> Observable<Void> {
        return Observable<Void>.create { observer in
            Alamofire.request(enterBBUrl)
                .responseString { response in
                    switch response.result {
                    case .success(_):
                        if let url = response.response?.url?.absoluteString,
                            url == bbUrl {
                            observer.onNext()
                        } else {
                            UserService.loginCurrentUser()
                                .subscribe { event in
                                    switch event {
                                    case .next(_):
                                        observer.onNext()
                                    case .error(let e):
                                        observer.onError(e)
                                    default:
                                        break
                                    }
                            }
                        }
                    case .failure(_):
                        observer.onError(MsgError("登录Blackboard失败"))
                    }
            }
            return Disposables.create { }
        }
    }

}
