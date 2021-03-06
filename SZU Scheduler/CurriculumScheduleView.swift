//
//  CurriculumScheduleView.swift
//  SZU Scheduler
//
//  Created by 陈林 on 27/07/2017.
//  Copyright © 2017 Pencil. All rights reserved.
//

import UIKit

@IBDesignable
class CurriculumScheduleView: UIView {
    
    private var colorList = [
        -1644806,
        -983056,
        -983041,
        -3851,
        -4133,
        -4198401,
        -2031617,
        -7681
    ]

    let headerHeight = CGFloat(30)
    let rowHeight =  CGFloat(80)
    let firstColWidth = CGFloat(20)
    let zeroCGFloat = CGFloat(0)
    
    var scrollView: UIScrollView!
    var headerLabelList = [UILabel]()
    
    var lessonMap = [Lesson: UILabel]() {
        didSet {
            layoutIfNeeded()
        }
    }
    
    func addCourse(_ lesson: Lesson) {
        let label = UILabel()
        label.text = "\(lesson.lessonName!)\n\(lesson.venue!)"
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = label.font.withSize(13)
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = colorList[abs(lesson.lessonName!.hashValue) % colorList.count].uiColor
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleTapGesture(sender:))))
        lessonMap[lesson] = label
        scrollView.addSubview(label)
    }
    
    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        if let clickedLabel = sender.view as? UILabel {
            for (lesson, label) in lessonMap {
                if clickedLabel == label {
                    // Get top vc
                    var topVC = UIApplication.shared.keyWindow?.rootViewController
                    while((topVC!.presentedViewController) != nil) {
                        topVC = topVC!.presentedViewController
                    }
                    
                    let alert = UIAlertController(title: lesson.lessonName!, message: "编辑上课地点", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "保存", style: .default, handler: { action in
                        if let text = alert.textFields?.first?.text,
                            !text.isEmpty {
                            lesson.venue = text
                            label.text = "\(lesson.lessonName!)\n\(lesson.venue!)"
                            CommonUtil.app.saveContext()
                        } else {
                            topVC?.present(CommonUtil.getErrorAlertController(message: "保存失败!\n上课地点不能为空"), animated: true, completion: nil)
                        }
                    }))
                    alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                    alert.addTextField(configurationHandler: nil)
                    alert.textFields?.first?.text = lesson.venue!
                    
                    topVC?.present(alert, animated: true, completion: nil)
                    break
                }
            }
        }
    }
    
    func removeCourse(_ lesson: Lesson) {
        if let label = lessonMap[lesson] {
            label.removeFromSuperview()
            lessonMap.removeValue(forKey: lesson)
            layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initView()
    }
    
    // 初始化View
    private func initView() {
        initHeader()
        initSrollView()
    }
    
    private func initHeader() {
        let weekday = Date().weekDay()
        for i in 0..<7 {
            let label = UILabel()
            label.text = "周" + CurriculumScheduleView.getUpperCaseNum(with: i + 1)
            label.adjustsFontSizeToFitWidth = true
            label.font = label.font.withSize(15)
            label.textColor = UIColor.gray
            label.textAlignment = .center
            if i == weekday - 1 {
                label.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2)
            }
            
            headerLabelList.append(label)
            addSubview(label)
        }
    }
    
    private func initSrollView() {
        scrollView = UIScrollView()
        // 绘制左侧上课节数
        for i in 0..<12 {
            let label = UILabel(frame: CGRect(x: 0, y: rowHeight * CGFloat(i), width: firstColWidth, height: rowHeight))
            label.text = "\(i + 1)"
            label.font = label.font.withSize(12)
            label.textColor = UIColor.gray
            label.textAlignment = .center
            scrollView.addSubview(label)
        }
        addSubview(scrollView)
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 设置subviews大小
        let averageWidth = (rect.width - firstColWidth) / 7
        for i in 0..<headerLabelList.count {
            headerLabelList[i].frame = CGRect(x: averageWidth * CGFloat(i) + firstColWidth, y: zeroCGFloat, width: averageWidth, height: headerHeight)
            headerLabelList[i].layoutIfNeeded()
        }
        for (lesson, label) in lessonMap {
            label.frame = CGRect(x: firstColWidth + averageWidth * CGFloat(lesson.day - 1), y: CGFloat(lesson.begin - 1) * rowHeight, width: averageWidth, height: CGFloat((lesson.end - lesson.begin + 1)) * rowHeight)
            label.layoutIfNeeded()
        }
        scrollView.frame = CGRect(x: 0, y: headerHeight, width: rect.width, height: rect.height - headerHeight)
        scrollView.contentSize = CGSize(width: rect.width, height: 12 * rowHeight)
    }
    
    // 将数字转换为大写(仅限1-7)
    class func getUpperCaseNum(with num: Int) -> String {
        switch num {
        case 1:
            return "一"
        case 2:
            return "二"
        case 3:
            return "三"
        case 4:
            return "四"
        case 5:
            return "五"
        case 6:
            return "六"
        case 7:
            return "日"
        default:
            return "零"
        }
    }
}
