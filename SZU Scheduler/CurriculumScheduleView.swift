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
        UIColor.rgbColorFromHex(rgb: -1644806),
        UIColor.rgbColorFromHex(rgb: -983056),
        UIColor.rgbColorFromHex(rgb: -983041),
        UIColor.rgbColorFromHex(rgb: -3851),
        UIColor.rgbColorFromHex(rgb: -4133),
        UIColor.rgbColorFromHex(rgb: -4198401),
        UIColor.rgbColorFromHex(rgb: -2031617),
        UIColor.rgbColorFromHex(rgb: -7681)
    ]

    let headerHeight = CGFloat(30)
    let rowHeight =  CGFloat(80)
    let firstColWidth = CGFloat(20)
    let zeroCGFloat = CGFloat(0)
    
    var scrollView: UIScrollView!
    var headerLabelList = [UILabel]()
    
    var courseMap = [Course: UILabel]() {
        didSet {
            layoutIfNeeded()
        }
    }
    
    func addCourse(_ course: Course) {
        let label = UILabel()
        label.text = "\(course.courseName)\n\(course.venue)"
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.font = label.font.withSize(13)
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.clipsToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = colorList[abs(course.courseName.hashValue) % colorList.count]
        courseMap[course] = label
        scrollView.addSubview(label)
    }
    
    func removeCourse(_ course: Course) {
        if let label = courseMap[course] {
            label.removeFromSuperview()
            courseMap.removeValue(forKey: course)
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
        let days = (Int(Date().timeIntervalSince1970) + NSTimeZone.local.secondsFromGMT()) / 86400 // 24*60*60
        var weekday = ((days + 4)%7+7)%7
        weekday = weekday == 0 ? 7 : weekday
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("layout subviews")
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // 设置subviews大小
        let averageWidth = (rect.width - firstColWidth) / 7
        for i in 0..<headerLabelList.count {
            headerLabelList[i].frame = CGRect(x: averageWidth * CGFloat(i) + firstColWidth, y: zeroCGFloat, width: averageWidth, height: headerHeight)
            headerLabelList[i].layoutIfNeeded()
        }
        for (course, label) in courseMap {
            label.frame = CGRect(x: firstColWidth + averageWidth * CGFloat(course.day - 1), y: CGFloat(course.timeBegin - 1) * rowHeight, width: averageWidth, height: CGFloat((course.timeEnd - course.timeBegin + 1)) * rowHeight)
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
