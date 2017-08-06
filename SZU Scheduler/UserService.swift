//
//  UserService.swift
//  SZU Scheduler
//
//  Created by 陈林 on 29/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import CoreData

import Alamofire
import RxSwift
import RxCocoa

public class UserService {
    private static let successUrl = "http://elearning.szu.edu.cn/webapps/portal/frameset.jsp"
    private static let stuNumUrl = "http://elearning.szu.edu.cn/webapps/blackboard/execute/editUser?context=self_modify" // 获取学号url
    private static let stuInfoUrl = "http://pencilsky.cn:9090/api/curriculum/student/?stuNum="
    private static let logoutLibraryUrl = "http://opac.lib.szu.edu.cn/opac/user/logout.aspx"
    private static let logoutBBUrl = "http://elearning.szu.edu.cn/webapps/login?action=logout"
    private static let entityName = "Student"
    
    static var currentUser: Student?
    
    // Getting user info from userDefaults
    // If not found, return nil
    public class func getUserFromUserDefaults() -> Student? {
        let userDefaults = UserDefaults.standard
        if let username = userDefaults.string(forKey: "username") {
            return findByUsername(username)
        }
        return nil
    }
    
    public class func saveCurrentUserInfo() {
        let user = currentUser!
        let userDefaults = UserDefaults.standard
        userDefaults.set(user.username, forKey: "username")
        CommonUtil.app.saveContext()
    }
    
    public class func logout() {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: "username")
    }
    
    private class func logout(url: String) -> Observable<Void> {
        return Observable.create { observer in
            Alamofire.request(url)
                .responseString { response in
                    observer.onNext()
            }
            
            return Disposables.create { }
        }
    }
    
    private class func logoutLibrary() -> Observable<Void> {
        return logout(url: logoutLibraryUrl)
    }
    
    private class func logoutBB() -> Observable<Void> {
        return logout(url: logoutBBUrl)
    }
    
    // Login but don't get user info
    private class func loginOnly(_ username: String, _ password: String) -> Observable<Void> {
        return Observable<DataResponse<String>>.create { observer -> Disposable in
            Alamofire.request("https://authserver.szu.edu.cn/authserver/login?service=https%3a%2f%2fauth.szu.edu.cn%2fcas.aspx%2flogin%3fservice%3dhttp%3a%2f%2felearning.szu.edu.cn%2fwebapps%2fcbb-sdgxtyM-BBLEARN%2fgetuserid.jsp")
                .responseString { response in
                    switch response.result {
                    case .success(_):
                        observer.onNext(response)
                    case .failure(_):
                        observer.onError(MsgError("获取登录信息失败"))
                    }
            }
            return Disposables.create { }
            }.map { response -> String? in
                if successUrl == response.response?.url?.absoluteString {
                    return nil
                } else if let html = response.result.value,
                    getInputValueByName(html, name: "lt") != nil {
                    return html
                }
                return ""
            }.flatMap {
                postLogin(username: username, password: password, html: $0)
        }
    }
    
    public class func loginCurrentUser() -> Observable<Void> {
        let user = currentUser!
        return loginOnly(user.username!, user.password!)
    }
    
    public class func login(username: String, password: String) -> Observable<Student?> {
        // Logout all website before login
        return Observable<Void>.zip(logoutBB(), logoutLibrary()) { (res1, res2) in
            return
        }.flatMap { _ -> Observable<Void> in
            return loginOnly(username, password)
        }.flatMap { (_) -> Observable<Student?> in
            getUserInfo(username: username, password: password)
        }
    }
    
    // Getting student number、name and gender
    // Note: Need ensuring login
    public class func getUserInfo(username: String, password: String) -> Observable<Student?> {
        return Observable<String>.create { observer -> Disposable in
            Alamofire.request(stuNumUrl)
                .responseString { response in
                    switch response.result {
                    case .success(_):
                        if let html = response.result.value {
                            if let stuNum = getStuNum(html) {
                                observer.onNext(stuNum)
                            } else {
                                observer.onError(MsgError("获取学号信息失败"))
                            }
                        } else {
                            observer.onError(MsgError("获取学号页面信息失败"))
                        }
                    case .failure(_):
                        observer.onError(MsgError("请求学号页面失败"))
                    }
            }
            return Disposables.create { }
        }.flatMap { stuNum -> Observable<Student?> in
            Observable<Student?>.create { observer -> Disposable in
                Alamofire.request(stuInfoUrl + stuNum)
                    .responseJSON { response in
                        switch response.result {
                        case .success(_):
                            if let json = response.result.value as? [String: AnyObject],
                                let code = json["code"] as? Int,
                                code == 10000,
                                let data = json["data"] as? [String: AnyObject],
                                let name = data["name"] as? String,
                                let gender = data["sex"] as? String {
                                
                                // If the current user has logged on
                                // the account is not created repeatedly
                                // and the user data is updated directly
                                var user: Student
                                var newUser = false
                                if let findUser = findByUsername(username) {
                                    user = findUser
                                } else {
                                    user = create()
                                    newUser = true
                                }
                                user.username = username
                                user.password = password
                                user.stuNum = stuNum
                                user.name = name
                                user.gender = gender
                                
                                currentUser = user
                                
                                // If first login, then initializing data
                                if newUser {
                                    BlackboardService.refreshSubject()
                                    CurriculumScheduleService.refresh()
                                }
                                saveCurrentUserInfo()
                                observer.onNext(user)
                            } else {
                                observer.onError(MsgError("获取学生信息失败"))
                            }
                        case .failure(_):
                            observer.onError(MsgError("请求获取学生信息失败"))
                        }
                }
                return Disposables.create { }
            }
        }
    }
    
    private class func postLogin(username: String, password: String, html: String?) -> Observable<Void> {
        return Observable<Void>.create({ observer -> Disposable in
            if html == nil {
                observer.onNext()
            } else {
                let params: Parameters = [
                    "lt": getInputValueByName(html!, name: "lt")!,
                    "execution": getInputValueByName(html!, name: "execution")!,
                    "_eventId": "submit",
                    "dllt": "userNamePasswordLogin",
                    "rmShown": "1",
                    "username": username,
                    "password": password
                ]
                Alamofire.request("https://authserver.szu.edu.cn/authserver/login?service=https%3a%2f%2fauth.szu.edu.cn%2fcas.aspx%2flogin%3fservice%3dhttp%3a%2f%2felearning.szu.edu.cn%2fwebapps%2fcbb-sdgxtyM-BBLEARN%2fgetuserid.jsp", method: .post, parameters: params)
                    .responseString { response in
                        switch response.result {
                        case .success(_):
                            if successUrl == response.response?.url?.absoluteString {
                                observer.onNext()
                            } else if let html = response.result.value,
                                let errorMsg = getLoginError(html) {
                                observer.onError(MsgError(errorMsg))
                            } else {
                                observer.onError(MsgError("登录失败,请重试"))
                            }
                        case .failure(_):
                            observer.onError(MsgError("请求登录失败"))
                        }
                }
            }
            return Disposables.create { }
        })
    }
    
    private class func getStuNum(_ html: String) -> String? {
        return findFirstString(pattern: "<input.*id=\"studentId\".*value=\"(.*?)\".*/>", from: html)
    }
    
    private class func getInputValueByName(_ html: String, name: String) -> String? {
        return findFirstString(pattern: "<input type=\"hidden\" name=\"\(name)\" value=\"(.*)?\"/>", from: html)
    }
    
    private class func getLoginError(_ html: String) -> String? {
        return findFirstString(pattern: "<span id=\"msg\" class=\"auth_error\" style=\"top:-19px;\">(.*)?</span>", from: html)
    }
    
    private class func findFirstString(pattern: String, from str: String) -> String? {
        let res = try! RegExUtil.matchs(pattern: pattern, from: str)
        return res.count > 0 ? str.substring(with: res[0].rangeAt(1)) : nil
    }
    
    private class func create() -> Student {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: CommonUtil.context) as! Student
    }
    
    private class func findByUsername(_ username: String) -> Student? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate.init(format: "username = %@", NSString(string: username))
        if let fetchedObjects = try? CommonUtil.context.fetch(fetchRequest) as! [Student],
            fetchedObjects.count > 0 {
            return fetchedObjects[0]
        }
        return nil
    }
}
