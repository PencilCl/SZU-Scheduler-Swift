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
    private static let entityName = "Student"
    
    static var currentUser: Student?
    
    private static var app: AppDelegate = {
        UIApplication.shared.delegate as! AppDelegate
    }()
    private static var context: NSManagedObjectContext = {
        app.persistentContainer.viewContext
    }()
    
    public enum OperationError: Error {
        case NotFoundError(String)
        case RequestError(String)
        case AuthError(String)
    }
    
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
        app.saveContext()
    }
    
    public class func login(username: String, password: String) -> Observable<Student?> {
        return Observable<DataResponse<String>>.create { observer -> Disposable in
            Alamofire.request("https://authserver.szu.edu.cn/authserver/login?service=https%3a%2f%2fauth.szu.edu.cn%2fcas.aspx%2flogin%3fservice%3dhttp%3a%2f%2felearning.szu.edu.cn%2fwebapps%2fcbb-sdgxtyM-BBLEARN%2fgetuserid.jsp")
                .responseString { response in
                    switch response.result {
                    case .success(_):
                        observer.onNext(response)
                    case .failure(_):
                        observer.onError(OperationError.RequestError("获取登录信息失败"))
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
                                observer.onError(OperationError.NotFoundError("获取学号信息失败"))
                            }
                        } else {
                            observer.onError(OperationError.RequestError("获取学号页面信息失败"))
                        }
                    case .failure(_):
                        observer.onError(OperationError.RequestError("请求学号页面失败"))
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
                                
                                let user = create()
                                user.username = username
                                user.password = password
                                user.stuNum = stuNum
                                user.name = name
                                user.gender = gender
                                
                                currentUser = user
                                saveCurrentUserInfo()
                                observer.onNext(user)
                            } else {
                                observer.onError(OperationError.RequestError("获取学号信息失败"))
                            }
                        case .failure(_):
                            observer.onError(OperationError.RequestError("请求获取学号失败"))
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
                print(params)
                Alamofire.request("https://authserver.szu.edu.cn/authserver/login?service=https%3a%2f%2fauth.szu.edu.cn%2fcas.aspx%2flogin%3fservice%3dhttp%3a%2f%2felearning.szu.edu.cn%2fwebapps%2fcbb-sdgxtyM-BBLEARN%2fgetuserid.jsp", method: .post, parameters: params)
                    .responseString { response in
                        switch response.result {
                        case .success(_):
                            if successUrl == response.response?.url?.absoluteString {
                                observer.onNext()
                            } else if let html = response.result.value,
                                let errorMsg = getLoginError(html) {
                                observer.onError(OperationError.AuthError(errorMsg))
                            } else {
                                observer.onError(OperationError.RequestError("登录失败,请重试"))
                            }
                        case .failure(_):
                            observer.onError(OperationError.RequestError("请求登录失败"))
                        }
                }
            }
            return Disposables.create { }
        })
    }
    
    private class func getStuNum(_ html: String) -> String? {
        let pattern = "<input.*id=\"studentId\".*value=\"(.*?)\".*/>"
        let regex = try! NSRegularExpression(pattern: pattern, options: .init(rawValue: 0))
        let res = regex.matches(in: html, options: .init(rawValue: 0), range: NSMakeRange(0, html.characters.count))
        if res.count > 0 {
            return (html as NSString).substring(with: res[0].rangeAt(1))
        }
        return nil
    }
    
    private class func getInputValueByName(_ html: String, name: String) -> String? {
        let pattern = "<input type=\"hidden\" name=\"\(name)\" value=\"(.*)?\"/>"
        let regex = try! NSRegularExpression(pattern: pattern, options: .init(rawValue: 0))
        let res = regex.matches(in: html, options: .init(rawValue: 0), range: NSMakeRange(0, html.characters.count))
        if res.count > 0 {
            return (html as NSString).substring(with: res[0].rangeAt(1))
        }
        return nil
    }
    
    private class func getLoginError(_ html: String) -> String? {
        let pattern = "<span id=\"msg\" class=\"auth_error\" style=\"top:-19px;\">(.*)?</span>"
        let regex = try! NSRegularExpression(pattern: pattern, options: .init(rawValue: 0))
        let res = regex.matches(in: html, options: .init(rawValue: 0), range: NSMakeRange(0, html.characters.count))
        if res.count > 0 {
            return (html as NSString).substring(with: res[0].rangeAt(1))
        }
        return nil
    }
    
    private class func create() -> Student {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! Student
    }
    
    private class func findByUsername(_ username: String) -> Student? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.predicate = NSPredicate.init(format: "username = %@", NSString(string: username))
        if let fetchedObjects = try? context.fetch(fetchRequest) as! [Student],
            fetchedObjects.count > 0 {
            return fetchedObjects[0]
        }
        return nil
    }
    
}
