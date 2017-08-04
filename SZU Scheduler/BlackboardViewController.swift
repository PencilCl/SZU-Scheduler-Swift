//
//  BlackboardViewController.swift
//  SZU Scheduler
//
//  Created by 陈林 on 25/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

class BlackboardViewController: UIViewController {
    
    var pageViewController: UIPageViewController!
    var unfinishedHomeworkController: HomeworkViewController!
    var subjectController: SubjectTableViewController!
    @IBOutlet weak var sliderView: UIView!
    
    let moduleColor = 0x9ccc65.uiColor
    
    var currentPage: Int = 0 {
        didSet {
            if currentPage != oldValue {
                if currentPage == 0 {
                    changeToHomework()
                } else {
                    changeToSubject()
                }
            }
        }
    }
    
    var nextPage: Int = 0
    
    private func changeToHomework() {
        unfinishedHomeworkButton.setTitleColor(UIColor.white, for: .normal)
        subjectButton.setTitleColor(0xE6E6E6.uiColor, for: .normal)
        UIView.animate(withDuration: 0.5) { [weak self] in
            if let view = self?.view {
                for constraint in view.constraints {
                    if constraint.firstItem as? UIView == self?.sliderView,
                        constraint.firstAttribute == .leading{
                        constraint.constant = 0
                        view.layoutIfNeeded()
                        break
                    }
                }
            }
        }
        pageViewController?.setViewControllers([unfinishedHomeworkController], direction: .reverse, animated: true, completion: nil)
    }
    
    private func changeToSubject() {
        subjectButton.setTitleColor(UIColor.white, for: .normal)
        unfinishedHomeworkButton.setTitleColor(0xE6E6E6.uiColor, for: .normal)
        UIView.animate(withDuration: 0.5) { [weak self] in
            if let view = self?.view,
                let button = self?.unfinishedHomeworkButton {
                for constraint in view.constraints {
                    if constraint.firstItem as? UIView == self?.sliderView,
                        constraint.firstAttribute == .leading{
                        constraint.constant = button.frame.width
                        view.layoutIfNeeded()
                        break
                    }
                }
            }
        }
        pageViewController?.setViewControllers([subjectController], direction: .forward, animated: true, completion: nil)
    }
    
    @IBAction func clickUnfinsihedHomework(_ sender: UIButton) {
        currentPage = 0
    }
    
    @IBAction func clickSubjectList(_ sender: UIButton) {
        currentPage = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageViewController = self.childViewControllers.first as! UIPageViewController
        pageViewController.delegate = self
        unfinishedHomeworkController = storyboard?.instantiateViewController(withIdentifier: "UnfinishedHomeworkControllerID") as! HomeworkViewController
        unfinishedHomeworkController.homeworkArray = filterUnfinishedHomework()
        subjectController = storyboard?.instantiateViewController(withIdentifier: "SubjectControllerID") as! SubjectTableViewController
        subjectController.subjects = UserService.currentUser!.subjects
        
        pageViewController.dataSource = self
        pageViewController?.setViewControllers([unfinishedHomeworkController], direction: .forward, animated: true, completion: nil)

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.barTintColor = moduleColor
        }
        navigationController?.hideHireLine()
        
        // 代码中设置按钮背景颜色 storyboard中设置有色差
        subjectButton.backgroundColor = moduleColor
        unfinishedHomeworkButton.backgroundColor = moduleColor
    }
    
    private func filterUnfinishedHomework() -> [Homework] {
        var res = [Homework]()
        if let subjects = UserService.currentUser!.subjects {
            for subject in (subjects.allObjects as! [Subject]) {
                if let homeworks = subject.homeworks {
                    for homework in (homeworks.allObjects as! [Homework]) {
                        if !homework.finished {
                            res.append(homework)
                        }
                    }
                }
            }
        }
        return res
    }
    
    @IBOutlet weak var unfinishedHomeworkButton: UIButton!
    @IBOutlet weak var subjectButton: UIButton!
}

extension BlackboardViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let vc = pendingViewControllers.first {
            nextPage = vc.isKind(of: HomeworkViewController.self) ? 0 : 1
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            currentPage = nextPage
        }
    }
}

extension BlackboardViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: HomeworkViewController.self) {
            return subjectController
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: SubjectTableViewController.self) {
            return unfinishedHomeworkController
        }
        return nil
    }
}

extension UINavigationController {
    //纯色转图片
    private func imageFromColor(color: UIColor) -> UIImage? {
        let rect: CGRect = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        
        if let image = context.makeImage() {
            return UIImage.init(cgImage: image)
        }
        return nil
    }
    
    //隐藏NavigationBar底部黑线的方法
    func hideHireLine() {
        navigationBar.setBackgroundImage(imageFromColor(color: navigationBar.barTintColor!), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    func showHireLine() {
        navigationBar.setBackgroundImage(nil, for: .default)
    }
}
