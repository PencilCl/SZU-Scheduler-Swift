//
//  LibraryService.swift
//  SZU Scheduler
//
//  Created by 陈林 on 05/08/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import Foundation
import CoreData

import RxSwift
import RxCocoa
import Alamofire

public class LibraryService {
    
    private static let libraryUrl = "http://opac.lib.szu.edu.cn/opac/user/bookborrowed.aspx"
    private static let bookReg = "<TD width=\"10%\">(.*?)</TD>\\s*?" +
        "<TD width=\"35%\"><[\\s\\S]*?>([\\s\\S]*?)[／/][\\s\\S]*?</a>" +
    "[\\s\\S]*?<TD width=\"10%\">(.*?)</TD>"

    public class func refresh() {
        loginLibrary()
            .subscribe { event in
                switch event {
                case .next(let value):
                    if let html = value {
                        resolveBooksLibrary(html: html)
                    } else {
                        getBooksFromNetwork()
                    }
                case .error(let e):
                    if let error = e as? MsgError {
                        print(error.msg)
                    }
                default:
                    break
                }
        }
    }
    
    private class func resolveBooksLibrary(html: String) {
        let res = try! RegExUtil.matchs(pattern: bookReg, from: html)
        for matcher in res {
            print(html.substring(with: matcher.rangeAt(1)))
            print(html.substring(with: matcher.rangeAt(2)))
            print(html.substring(with: matcher.rangeAt(3)))
        }
    }
    
    private class func getBooksFromNetwork() {
        Alamofire.request(libraryUrl)
            .responseString { response in
                switch response.result {
                case .success(_):
                    if let html = response.result.value {
                        resolveBooksLibrary(html: html)
                    }
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    private class func removeAllData() {
        if let books = UserService.currentUser!.books?.allObjects as? [Library] {
            for book in books {
                CommonUtil.context.delete(book)
            }
        }
    }

    private class func loginLibrary() -> Observable<String?> {
        return Observable<String?>.create { observer -> Disposable in
            Alamofire.request(libraryUrl)
                .responseString { response in
                    switch response.result {
                    case .success(_):
                        if let url = response.response?.url?.absoluteString,
                            url == libraryUrl {
                            observer.onNext(response.result.value)
                        } else {
                            UserService.loginCurrentUser()
                                .subscribe { event in
                                    switch event {
                                    case .next(_):
                                        observer.onNext(nil)
                                    case .error(let e):
                                        observer.onError(e)
                                    default:
                                        break
                                    }
                            }
                        }
                    case .failure(_):
                        observer.onError(MsgError("登录图书馆失败"))
                    }
            }
            
            return Disposables.create { }
        }
    }
    
}
